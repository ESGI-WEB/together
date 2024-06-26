import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/partials/custom_icon_button.dart';
import 'package:front/groups/create_group_screen/create_group_screen.dart';
import 'package:front/groups/groups_screen/partials/groups_list_item.dart';
import 'package:front/groups/join_group_screen/join_group_screen.dart';
import 'package:go_router/go_router.dart';

import 'blocs/groups_bloc.dart';

class GroupsScreen extends StatelessWidget {
  static const String routeName = 'groups';

  static void navigateTo(BuildContext context) {
    context.goNamed(routeName);
  }

  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupsBloc()..add(GroupsLoaded()),
      child: Builder(
        builder: (context) => Scaffold(
          body: BlocListener<GroupsBloc, GroupsState>(
            listener: (context, state) {
              if (state.status == GroupsStatus.error) {
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
                context.read<GroupsBloc>().add(GroupsLoaded());
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Groupes',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: BlocBuilder<GroupsBloc, GroupsState>(
                        builder: (context, state) {
                          if (state.status == GroupsStatus.loading &&
                              state.groups == null) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (state.groups != null &&
                              state.groups!.isNotEmpty) {
                            return NotificationListener<ScrollNotification>(
                              onNotification: (ScrollNotification scrollInfo) {
                                if (scrollInfo.metrics.pixels ==
                                        scrollInfo.metrics.maxScrollExtent &&
                                    !state.hasReachedMax) {
                                  context
                                      .read<GroupsBloc>()
                                      .add(GroupsLoadMore());
                                }
                                return false;
                              },
                              child: ListView.separated(
                                itemCount: state.groups!.length +
                                    (state.status == GroupsStatus.loadingMore
                                        ? 1
                                        : 0),
                                itemBuilder: (context, index) {
                                  if (index == state.groups!.length) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    return GroupsListItem(
                                        group: state.groups![index]);
                                  }
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(height: 10);
                                },
                              ),
                            );
                          }

                          if (state.status == GroupsStatus.success &&
                              (state.groups == null || state.groups!.isEmpty)) {
                            return ListView(
                              children: const [
                                Center(
                                  child: Text('Aucun groupe disponible.'),
                                ),
                              ],
                            );
                          }

                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconButton(
                          icon: Icons.add,
                          label: 'Créer',
                          onPressed: () {
                            final groupsScreenBloc = context.read<GroupsBloc>();
                            context.goNamed(CreateGroupScreen.routeName,
                                extra: groupsScreenBloc);
                          },
                        ),
                        const SizedBox(width: 16),
                        CustomIconButton(
                          icon: Icons.group_add,
                          label: 'Rejoindre',
                          onPressed: () {
                            final groupsScreenBloc = context.read<GroupsBloc>();
                            context.goNamed(JoinGroupScreen.routeName,
                                extra: groupsScreenBloc);
                          },
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
