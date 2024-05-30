import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/partials/app_layout.dart';

import 'package:go_router/go_router.dart';
import 'blocs/group_bloc.dart';
import 'create_group_screen.dart';
import 'group_button.dart';
import 'group_list.dart';
import 'join_group_screen.dart';

class GroupsScreen extends StatelessWidget {
  static const String routeName = 'groups';

  static void navigateTo(BuildContext context) {
    context.goNamed(routeName);
  }

  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupBloc()..add(LoadGroups()),
      child: AppLayout(
        title: "Groupes",
        body: Stack(
          children: [
            BlocBuilder<GroupBloc, GroupState>(
              builder: (context, state) {
                if (state is GroupLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is GroupsLoadError) {
                  return Center(
                    child: Text(
                      state.errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (state is GroupsLoadSuccess) {
                  return Positioned.fill(
                    child: GroupList(groups: state.groups),
                  );
                }

                return const SizedBox();
              },
            ),
            Positioned(
              bottom: 16.0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GroupButton(
                    text: 'Créer',
                    icon: Icons.add,
                    onPressed: () {
                      CreateGroupScreen.navigateTo(context);
                    },
                  ),
                  const SizedBox(width: 10.0),
                  GroupButton(
                    text: 'Rejoindre',
                    icon: Icons.person_add,
                    onPressed: () {
                      JoinGroupScreen.navigateTo(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
