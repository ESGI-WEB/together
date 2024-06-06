import 'package:flutter/material.dart';
import 'package:front/core/models/group.dart';
import 'package:front/groups/group_screen/group_screen.dart';

class GroupsListItem extends StatelessWidget {
  final Group group;

  const GroupsListItem({required this.group, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: () {
          GroupScreen.navigateTo(context, id: group.id);
        },
        title: Text(
          group.name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        subtitle: group.description != null
            ? Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            group.description!,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        )
            : null,
        trailing: Icon(Icons.arrow_forward, color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}