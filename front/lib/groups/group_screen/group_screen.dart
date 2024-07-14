import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/partials/next_event_of_group/next_event_of_group.dart';
import 'package:front/core/partials/poll/poll_gateway.dart';
import 'package:go_router/go_router.dart';

import 'blocs/group_screen_bloc.dart';

class GroupScreen extends StatelessWidget {
  static const String routeName = 'group';

  final int id;

  static void navigateTo(BuildContext context, {required int id}) {
    context.goNamed(routeName, pathParameters: {'groupId': id.toString()});
  }

  const GroupScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupScreenBloc()..add(LoadGroupScreen(groupId: id)),
      child: BlocBuilder<GroupScreenBloc, GroupScreenState>(
        builder: (context, state) {
          if (state.status == GroupScreenStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == GroupScreenStatus.error) {
            return Center(child: Text(state.errorMessage ?? 'Erreur inconnue'));
          }

          final group = state.group;
          if (group == null) {
            return const Center(child: Text('Groupe introuvable'));
          }

          final isGroupOwner = state.group?.ownerId == state.userData?.id;

          return SingleChildScrollView(
            child: Column(
              children: [
                PollGateway(
                  id: id,
                  hasParentEditionRights: isGroupOwner,
                ),
                NextEventOfGroup(
                  groupId: id,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
