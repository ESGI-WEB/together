import 'package:flutter/material.dart';
import 'package:front/event/create_event_screen.dart';
import 'package:front/event/event_screen.dart';
import 'package:go_router/go_router.dart';

class GroupScreen extends StatelessWidget {
  static const String routeName = 'group';

  final String id;

  static void navigateTo(BuildContext context, {required String id}) {
    context.goNamed(routeName, pathParameters: {'id': id});
  }

  const GroupScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("Accueil du group"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CreateEventScreen.navigateTo(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}