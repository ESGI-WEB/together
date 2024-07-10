import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/publications/blocs/publications_bloc.dart';
import 'package:go_router/go_router.dart';

import 'blocs/create_publication_bloc.dart';
import 'blocs/create_publication_event.dart';
import 'blocs/create_publication_state.dart';

class CreatePublicationScreen extends StatelessWidget {
  static const String routeName = 'create_publication';
  static const String routeNameForEvent = 'create_publication_on_event';

  final int groupId;
  final int? eventId;

  const CreatePublicationScreen({required this.groupId, this.eventId, super.key});

  static void navigateTo(BuildContext context) {
    context.goNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreatePublicationBloc(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<CreatePublicationBloc, CreatePublicationState>(
            listener: (context, state) {
              if (state.status == CreatePublicationStatus.success && state.newPublication?.id != null) {
                context.read<PublicationsBloc>().add(PublicationAdded(state.newPublication!));
                //context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Publication créée avec succès!')),
                );
              } else if (state.status == CreatePublicationStatus.error) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage ?? 'Erreur inconnue'),
                    ),
                  );
                });
              }
            },
            child: const CreatePublicationForm(),
          ),
        ),
      ),
    );
  }
}

class CreatePublicationForm extends StatefulWidget {
  const CreatePublicationForm({super.key});

  @override
  CreatePublicationFormState createState() => CreatePublicationFormState();
}

class CreatePublicationFormState extends State<CreatePublicationForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Créer une nouvelle publication',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Titre',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.title),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un titre';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _contentController,
            decoration: InputDecoration(
              labelText: 'Contenu',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.description),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un contenu';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() == true) {
                final newPublication = {
                  "title": _titleController.text,
                  "content": _contentController.text,
                };
                BlocProvider.of<CreatePublicationBloc>(context).add(CreatePublicationSubmitted(newPublication));
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }
}