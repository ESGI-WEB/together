import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/groups/group_screen/group_screen.dart';
import 'package:front/groups/groups_screen/blocs/groups_bloc.dart';
import 'package:go_router/go_router.dart';

import 'blocs/create_group_bloc.dart';

class CreateGroupScreen extends StatelessWidget {
  static const String routeName = 'create_group';

  final GroupsBloc groupsBloc;

  const CreateGroupScreen({super.key, required this.groupsBloc});

  static void navigateTo(
      BuildContext context, GroupsBloc groupsScreenBloc) {
    context.goNamed(routeName, extra: groupsScreenBloc);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: groupsBloc,
      child: BlocProvider(
        create: (context) => CreateGroupBloc(),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocListener<CreateGroupBloc, CreateGroupState>(
              listener: (context, state) {
                if (state.status == CreateGroupStatus.success &&
                    state.newGroup?.id != null) {
                  GroupScreen.navigateTo(context, id: state.newGroup!.id);
                  context
                      .read<GroupsBloc>()
                      .add(GroupJoined(state.newGroup!));
                } else if (state.status == CreateGroupStatus.error) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              state.errorMessage ?? 'Erreur inconnue')),
                    );
                  });
                }
              },
              child: CreateGroupForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class CreateGroupForm extends StatefulWidget {
  @override
  _CreateGroupFormState createState() => _CreateGroupFormState();
}

class _CreateGroupFormState extends State<CreateGroupForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _codeController = TextEditingController();

  String generateRandomCode() {
    const length = 10;
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return List.generate(length, (index) => chars[rand.nextInt(chars.length)])
        .join();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Nom'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un nom';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          TextFormField(
            controller: _codeController,
            decoration: InputDecoration(
              labelText: 'Code',
              suffixIcon: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  _codeController.text = generateRandomCode();
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un code';
              } else if (value.length < 5 || value.length > 20) {
                return 'Le code doit contenir entre 5 et 20 caractères';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() == true) {
                final newGroup = {
                  "name": _nameController.text,
                  "description": _descriptionController.text,
                  "code": _codeController.text,
                };
                BlocProvider.of<CreateGroupBloc>(context)
                    .add(CreateGroupSubmitted(newGroup));
              }
            },
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }
}