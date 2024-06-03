import 'package:flutter/material.dart';
import 'package:front/event/create_event_screen.dart';
import 'package:go_router/go_router.dart';

class GroupScreen extends StatelessWidget {
  static const String routeName = 'group';

  final String groupId;

  static void navigateTo(BuildContext context, {required String groupId}) {
    context.goNamed(routeName, pathParameters: {'groupId': groupId});
  }

  const GroupScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("Accueil du group"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CreateEventScreen.navigateTo(context, groupId);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
