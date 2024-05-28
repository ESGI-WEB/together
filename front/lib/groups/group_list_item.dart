import 'package:flutter/material.dart';

import '../core/models/group.dart';
import 'group_screen.dart';

class GroupListItem extends StatelessWidget {
  final Group group;

  const GroupListItem({required this.group, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        GroupScreen.navigateTo(context, groupId: group.id);
      },
      title: Text(group.name),
      subtitle: group.description != null ? Text(group.description!) : null,
    );
  }
}
