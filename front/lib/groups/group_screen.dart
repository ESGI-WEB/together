import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/chat/chat_screen.dart';

import '../core/partials/layout.dart';
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
      child: Layout(
        title: "group",
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
                    Text(group.description ?? ''),
                    ElevatedButton(
                      onPressed: () {
                        ChatScreen.navigateTo(context, groupId: group.id);
                      },
                      child: const Text('Chat'),
                    ),
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
