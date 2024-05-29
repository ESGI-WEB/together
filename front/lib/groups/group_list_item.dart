import 'package:flutter/material.dart';
import 'package:front/core/models/group.dart';
import 'package:front/core/partials/group_layout.dart';

class GroupListItem extends StatelessWidget {
  final Group group;

  const GroupListItem({required this.group, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        GroupLayout.navigateTo(context, groupId: group.id);
      },
      title: Text(group.name),
      subtitle: group.description != null ? Text(group.description!) : null,
    );
  }
}
