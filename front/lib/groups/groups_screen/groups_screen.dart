import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/groups/create_group_screen/create_group_screen.dart';
import 'package:front/groups/groups_screen/partials/groups_list.dart';
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
      child: Builder(
        builder: (context) => Scaffold(
          body: BlocListener<GroupsScreenBloc, GroupsScreenState>(
            listener: (context, state) {
              if (state.status == GroupsScreenStatus.error) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage ??
                          'Impossible de charger les groupes.'),
                    ),
                  );
                });
              }
            },
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<GroupsScreenBloc>().add(GroupsScreenLoaded());
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: BlocBuilder<GroupsScreenBloc, GroupsScreenState>(
                        builder: (context, state) {
                          if (state.status == GroupsScreenStatus.loading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (state.status == GroupsScreenStatus.success &&
                              state.groups != null) {
                            return GroupsList(groups: state.groups!);
                          }

                          return const Center(
                            child: Text('Aucun groupe disponible.'),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final groupsScreenBloc =
                                  context.read<GroupsScreenBloc>();
                              context.goNamed(CreateGroupScreen.routeName,
                                  extra: groupsScreenBloc);
                            },
                            child: const Text('Créer'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final groupsScreenBloc =
                                  context.read<GroupsScreenBloc>();
                              context.goNamed(JoinGroupScreen.routeName,
                                  extra: groupsScreenBloc);
                            },
                            child: const Text('Rejoindre'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
