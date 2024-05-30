import 'package:flutter/material.dart';
import 'package:front/core/partials/app_layout.dart';
import 'package:go_router/go_router.dart';

class EventDetailScreen extends StatelessWidget {
  static const String routeName = '/event';

  final String id;

  static void navigateTo(BuildContext context, {required int id}) {
    context.goNamed(routeName, pathParameters: {'id': id.toString()});
  }
  
  const EventDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return const AppLayout(
      title: 'Évènement',
      body: Text("évènement"),
    );
  }
}
