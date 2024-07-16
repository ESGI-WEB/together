import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/groups/group_screen/group_screen.dart';
import 'package:front/groups/groups_screen/blocs/groups_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'blocs/join_group_bloc.dart';

class JoinGroupScreen extends StatelessWidget {
  static const String routeName = 'join_group';

  final GroupsBloc groupsBloc;

  const JoinGroupScreen({required this.groupsBloc, super.key});

  static void navigateTo(BuildContext context, GroupsBloc groupsBloc) {
    context.goNamed(routeName, extra: groupsBloc);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: groupsBloc,
      child: BlocProvider(
        create: (context) => JoinGroupBloc(),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<JoinGroupBloc, JoinGroupState>(
                builder: (context, state) {
              if (state.status == JoinGroupStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == JoinGroupStatus.error) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.errorMessage ??
                            AppLocalizations.of(context)!.unableToJoinGroup,
                      ),
                    ),
                  );
                });
              }

              if (state.status == JoinGroupStatus.success &&
                  state.newGroup?.id != null) {
                GroupScreen.navigateTo(context, id: state.newGroup!.id);
                context.read<GroupsBloc>().add(GroupJoined(state.newGroup!));
              }
              return const JoinGroupForm();
            }),
          ),
        ),
      ),
    );
  }
}

class JoinGroupForm extends StatefulWidget {
  const JoinGroupForm({super.key});

  @override
  JoinGroupFormState createState() => JoinGroupFormState();
}

class JoinGroupFormState extends State<JoinGroupForm> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.joinAGroup,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _codeController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.groupCode,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.vpn_key),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.codeRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() == true) {
                BlocProvider.of<JoinGroupBloc>(context).add(
                  JoinGroupSubmitted({'code': _codeController.text}),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(AppLocalizations.of(context)!.join),
          ),
        ],
      ),
    );
  }
}
