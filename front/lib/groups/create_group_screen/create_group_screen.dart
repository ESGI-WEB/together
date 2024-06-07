import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/groups/group_screen/group_screen.dart';
import 'package:front/groups/groups_screen/blocs/groups_screen_bloc.dart';
import 'package:go_router/go_router.dart';

import 'blocs/create_group_bloc.dart';

class CreateGroupScreen extends StatelessWidget {
  static const String routeName = 'create_group';

  static void navigateTo(
      BuildContext context, GroupsScreenBloc groupsScreenBloc) {
    context.goNamed(routeName, extra: groupsScreenBloc);
  }

  const CreateGroupScreen({super.key, required GroupsScreenBloc groupsScreenBloc});

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
      return List.generate(length, (index) => chars[rand.nextInt(chars.length)])
          .join();
    }

    return BlocProvider<CreateGroupBloc>(
      create: (context) => CreateGroupBloc(),
      child: Scaffold(
        body: Builder(
          builder: (context) {
            return BlocListener<CreateGroupBloc, CreateGroupState>(
              listener: (context, state) {
                if (state.status == CreateGroupStatus.success &&
                    state.newGroup?.id != null) {
                  GroupScreen.navigateTo(context, id: state.newGroup!.id);
                  context
                      .read<GroupsScreenBloc>()
                      .add(GroupJoined(state.newGroup!));
                } else if (state.status == CreateGroupStatus.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMessage ?? 'Erreur inconnue')),
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
                        decoration:
                        const InputDecoration(labelText: 'Description'),
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
                            BlocProvider.of<CreateGroupBloc>(context)
                                .add(CreateGroupSubmitted(newGroup));
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