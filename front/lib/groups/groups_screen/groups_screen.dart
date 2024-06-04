import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/groups/create_group_screen/create_group_screen.dart';
import 'package:front/groups/groups_screen/partials/group_button.dart';
import 'package:front/groups/groups_screen/partials/group_list.dart';
import 'package:front/groups/join_group_screen/join_group_screen.dart';
import 'package:go_router/go_router.dart';

import 'blocs/groups_screen_bloc.dart';

class GroupsScreen extends StatelessWidget {
  static const String routeName = 'groups';

  static void navigateTo(BuildContext context) {
    context.goNamed(routeName);
  }

  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupsScreenBloc()..add(GroupsScreenLoaded()),
      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<GroupsScreenBloc, GroupsScreenState>(
              builder: (context, state) {
                if (state.status == GroupsScreenStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state.status == GroupsScreenStatus.error) {
                  return Center(
                    child: Text(
                      state.errorMessage ?? 'Failed to load groups',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (state.status == GroupsScreenStatus.success) {
                  return Positioned.fill(
                    child: GroupList(groups: state.groups!),
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