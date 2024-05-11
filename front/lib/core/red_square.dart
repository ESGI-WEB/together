import 'package:flutter/material.dart';

class GroupEntry extends StatelessWidget {
  const GroupEntry({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context)
            .pushNamed("/group", arguments: ScreenArguments(groupId));
      },
      child: Text(groupId),
    );
  }
}

class ScreenArguments {
  final String groupId;

  ScreenArguments(this.groupId);
}
