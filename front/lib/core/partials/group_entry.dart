import 'package:flutter/material.dart';
import 'package:front/groups/group_screen.dart';

class GroupEntry extends StatelessWidget{
  const GroupEntry({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        GroupScreen.navigateTo(context, groupId: groupId);
      },
      child: Text(groupId),
    );
  }
}