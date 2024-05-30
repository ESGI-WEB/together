import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EventScreen extends StatelessWidget {
  static const String routeName = '/event';

  final String id;

  static void navigateTo(BuildContext context, {required int id}) {
    context.goNamed(routeName, pathParameters: {'id': id.toString()});
  }
  
  const EventScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("évènement"),
    );
  }
}
