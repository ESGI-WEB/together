import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EventsScreen extends StatelessWidget {
  static const String routeName = '/events';

  static void navigateTo(BuildContext context) {
    context.goNamed(routeName);
  }

  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("évènements"),
    );
  }
}
