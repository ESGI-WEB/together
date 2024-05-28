import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/groups/group_screen.dart';
import 'blocs/group_bloc.dart';
import 'dart:math';

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

    String generateRandomCode() {
      const length = 10;
      const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
      final rand = Random();
      return List.generate(length, (index) => chars[rand.nextInt(chars.length)]).join();
    }

    return BlocProvider<GroupBloc>(
      create: (context) => GroupBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Créer un groupe')),
        body: Builder(
          builder: (context) {
            return BlocListener<GroupBloc, GroupState>(
              listener: (context, state) {
                if (state is GroupsLoadSuccess) {
                  GroupScreen.navigateTo(context, groupId: state.groups.last.id);
                } else if (state is GroupsLoadError) {
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
                        decoration: InputDecoration(
                          labelText: 'Code',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: () {
                              codeController.text = generateRandomCode();
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
                          if (formKey.currentState!.validate()) {
                            final newGroup = {
                              "name": nameController.text,
                              "description": descriptionController.text,
                              "code": codeController.text,
                            };
                            BlocProvider.of<GroupBloc>(context).add(CreateGroup(newGroup));
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