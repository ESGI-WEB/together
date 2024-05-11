import 'package:flutter/material.dart';
import 'package:front/core/red_square.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.separated(
      itemBuilder: (context, index) {
        return GroupEntry(groupId: index.toString());
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 10);
      },
      itemCount: 100000,
    ));
  }
}
