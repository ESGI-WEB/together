import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/group_bloc.dart';
import 'goup_button.dart';
import 'group_list.dart';

class GroupsScreen extends StatelessWidget {
  static const String routeName = '/groups';

  static Future<void> navigateTo(BuildContext context) {
    return Navigator.of(context).pushNamed(routeName);
  }

  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupBloc()..add(LoadGroups()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Groupes')),
        body: Stack(
          children: [
            BlocBuilder<GroupBloc, GroupState>(
              builder: (context, state) {
                if (state is GroupLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is GroupLoadError) {
                  return Center(
                    child: Text(
                      state.errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (state is GroupLoadSuccess) {
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
                      // Action à effectuer lors du clic sur le bouton "Créer"
                    },
                  ),
                  const SizedBox(width: 10.0), // Espacement entre les boutons
                  GroupButton(
                    text: 'Rejoindre',
                    icon: Icons.person_add,
                    onPressed: () {
                      // Action à effectuer lors du clic sur le bouton "Rejoindre"
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