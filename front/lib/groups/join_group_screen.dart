import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/partials/app_layout.dart';
import 'package:front/groups/blocs/group_bloc.dart';
import 'package:front/groups/group_home_screen.dart';

class JoinGroupScreen extends StatelessWidget {
  static const String routeName = '/joinGroup';

  static Future<void> navigateTo(BuildContext context,
      {bool removeHistory = false}) {
    return Navigator.of(context)
        .pushNamedAndRemoveUntil(routeName, (route) => !removeHistory);
  }

  const JoinGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController codeController = TextEditingController();

    return BlocProvider<GroupBloc>(
      create: (context) => GroupBloc(),
      child: AppLayout(
        title: "Rejoindre un groupe",
        body: Builder(
          builder: (context) {
            return BlocListener<GroupBloc, GroupState>(
              listener: (context, state) {
                if (state is GroupsLoadSuccess) {
                  GroupHomeScreen.navigateTo(context,
                      groupId: state.groups.last.id);
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
                        controller: codeController,
                        decoration: const InputDecoration(
                          labelText: 'Code du groupe',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un code.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            final code = {"code": codeController.text};
                            BlocProvider.of<GroupBloc>(context)
                                .add(JoinGroup(code));
                          }
                        },
                        child: const Text('Rejoindre'),
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
