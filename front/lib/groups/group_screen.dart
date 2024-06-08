import 'package:flutter/material.dart';
import 'package:front/core/partials/next_event_of_group/next_event_of_group.dart';
import 'package:go_router/go_router.dart';

class GroupScreen extends StatelessWidget {
  static const String routeName = 'group';

  final int groupId;

  static void navigateTo(BuildContext context, {required int groupId}) {
    context.goNamed(routeName, pathParameters: {'groupId': groupId.toString()});
  }

  const GroupScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NextEventOfGroup(
          groupId: groupId,
        ),
      ],
    );
  }
}
