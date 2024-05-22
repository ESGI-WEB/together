import 'package:flutter/material.dart';
import 'package:front/core/partials/layout.dart';

class GroupScreen extends StatefulWidget {
  static const String routeName = '/group';

  static Future<void> navigateTo(BuildContext context,
      {required String groupId, bool removeHistory = false}) {
    return Navigator.of(context).pushNamedAndRemoveUntil(
        routeName, (route) => !removeHistory,
        arguments: groupId);
  }

  final String groupId;

  const GroupScreen({super.key, required this.groupId});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  Widget build(BuildContext context) {
    return Layout(
      title: 'Group ${widget.groupId}',
      body: Text('Group ${widget.groupId}'),
    );
  }
}
