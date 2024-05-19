import 'package:flutter/material.dart';
import 'package:front/core/partials/group_entry.dart';
import 'package:front/core/partials/layout.dart';

class GroupsListScreen extends StatelessWidget {
  static const String routeName = '/groups';

  static Future<void> navigateTo(BuildContext context) {
    return Navigator.of(context).pushNamed(routeName);
  }
  const GroupsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
        title: 'Groups',
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
