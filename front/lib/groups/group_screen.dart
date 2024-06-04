import 'package:flutter/material.dart';
import 'package:front/event/create_event_screen.dart';
import 'package:front/core/partials/next_event_of_group/next_event_of_group.dart';

import 'package:go_router/go_router.dart';

class GroupScreen extends StatelessWidget {
  static const String routeName = 'group';

  final int id;

  static void navigateTo(BuildContext context, {required int id}) {
    context.goNamed(routeName, pathParameters: {'id': id.toString()});
  }

  const GroupScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: NextEventOfGroup(groupId: id),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CreateEventScreen.navigateTo(context, id);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
