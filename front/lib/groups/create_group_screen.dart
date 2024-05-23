import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/group_bloc.dart';

class CreateGroupScreen extends StatelessWidget {
  static const String routeName = '/createGroup';

  static Future<void> navigateTo(BuildContext context, {bool removeHistory = false}) {
    return Navigator.of(context).pushNamedAndRemoveUntil(routeName, (route) => !removeHistory);
  }

  const CreateGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final codeController = TextEditingController();

    return BlocProvider<GroupBloc>(
      create: (context) => GroupBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Créer un groupe')),
        body: Builder(
          builder: (context) {
            final groupBloc = BlocProvider.of<GroupBloc>(context);

            return BlocListener<GroupBloc, GroupState>(
              listener: (context, state) {
                if (state is GroupLoadSuccess) {
                  Navigator.of(context).pop();
                } else if (state is GroupLoadError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMessage)),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Nom'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un nom';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(labelText: 'Description'),
                      ),
                      TextFormField(
                        controller: codeController,
                        decoration: const InputDecoration(labelText: 'Code'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un code';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            final newGroup = {
                              "name": nameController.text,
                              "description": descriptionController.text,
                              "code": codeController.text
                            };

                            groupBloc.add(CreateGroup(newGroup)); // Utilisez groupBloc ici
                          }
                        },
                        child: const Text('Créer'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}