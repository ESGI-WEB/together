import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/groups/group_screen/group_screen.dart';
import 'package:front/groups/groups_screen/blocs/groups_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'blocs/create_group_bloc.dart';

class CreateGroupScreen extends StatelessWidget {
  static const String routeName = 'create_group';

  final GroupsBloc groupsBloc;

  const CreateGroupScreen({super.key, required this.groupsBloc});

  static void navigateTo(BuildContext context, GroupsBloc groupsScreenBloc) {
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
                  context.read<GroupsBloc>().add(GroupJoined(state.newGroup!));
                } else if (state.status == CreateGroupStatus.error) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(state.errorMessage ??
                              AppLocalizations.of(context)!.errorOccurred)),
                    );
                  });
                }
              },
              child: const CreateGroupForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class CreateGroupForm extends StatefulWidget {
  const CreateGroupForm({super.key});

  @override
  CreateGroupFormState createState() => CreateGroupFormState();
}

class CreateGroupFormState extends State<CreateGroupForm> {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.createNewGroup,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.name,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.group),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.nameRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.description,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.description),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _codeController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.code,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.vpn_key),
              suffixIcon: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  _codeController.text = generateRandomCode();
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.codeRequired;
              } else if (value.length < 5 || value.length > 20) {
                return AppLocalizations.of(context)!.codeInvalid(5, 20);
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
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(AppLocalizations.of(context)!.create),
          ),
        ],
      ),
    );
  }
}
