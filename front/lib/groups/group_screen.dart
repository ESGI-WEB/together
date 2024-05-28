import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/group_bloc.dart';

class GroupScreen extends StatelessWidget {
  static const String routeName = '/group';

  static Future<void> navigateTo(BuildContext context,
      {required int groupId, bool removeHistory = false}) {
    return Navigator.of(context).pushNamedAndRemoveUntil(
        routeName, (route) => !removeHistory,
        arguments: groupId);
  }

  final int groupId;

  const GroupScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupBloc()..add(LoadGroup(groupId)),
      child: Scaffold(
        appBar: AppBar(title: Text('Group $groupId')),
        body: BlocBuilder<GroupBloc, GroupState>(
          builder: (context, state) {
            if (state is GroupLoadSingleSuccess) {
              final group = state.group;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(group.name),
                    const SizedBox(height: 10),
                    // Add some spacing between name and description
                    Text(group.description ?? ''),
                  ],
                ),
              );
            } else if (state is GroupsLoadError) {
              return Center(child: Text(state.errorMessage));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
