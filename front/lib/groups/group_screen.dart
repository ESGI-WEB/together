import 'package:flutter/material.dart';

class GroupScreen extends StatefulWidget {
  static const String routeName = '/group';

  static Future<void> navigateTo(BuildContext context,
      {required String groupId, bool removeHistory = false}) {
    return Navigator.of(context).pushNamedAndRemoveUntil(
        routeName, (route) => !removeHistory,
        arguments: groupId);
  }

  final String id;

  const GroupScreen({super.key, required this.id});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Group ${widget.id}')),
      body: Center(child: Text('Group ${widget.id}')),
    );
  }
}
