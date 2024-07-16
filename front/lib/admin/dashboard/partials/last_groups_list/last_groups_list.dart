import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/models/group.dart';
import 'package:front/groups/groups_screen/partials/groups_list_item.dart';

import 'blocs/last_groups_list_bloc.dart';

class LastGroupsList extends StatelessWidget {
  const LastGroupsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "10 derniers groupes",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 24),
        BlocProvider(
          create: (context) =>
              LastGroupsListBloc()..add(LastGroupsListLoaded()),
          child: BlocBuilder<LastGroupsListBloc, LastGroupsListState>(
            builder: (BuildContext context, LastGroupsListState state) {
              if (state.status == LastGroupsListStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == LastGroupsListStatus.error) {
                return Center(
                  child: Text(
                    state.errorMessage ??
                        'Une erreur est survenue lors du chargement des données.',
                  ),
                );
              }

              final List<Group>? groups = state.groupsPage?.rows;
              if (groups == null || groups.isEmpty) {
                return const Center(
                  child: Text(
                    'Aucun groupe créé.',
                  ),
                );
              }

              return Container(
                constraints: const BoxConstraints(
                  maxHeight: 400,
                ),
                child: ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Group group = groups[index];
                    return GroupsListItem(
                      group: group,
                      showNavigation: false,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
