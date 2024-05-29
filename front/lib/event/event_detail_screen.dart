import 'package:flutter/material.dart';
import 'package:front/core/partials/app_layout.dart';

class EventDetailScreen extends StatelessWidget {
  static const String routeName = '/event-view';

  static Future<void> navigateTo(
    BuildContext context, {
    required int eventId,
    bool removeHistory = false,
  }) {
    return Navigator.of(context).pushNamedAndRemoveUntil(
        routeName, (route) => !removeHistory,
        arguments: eventId);
  }

  final int eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Évènement',
      body: Text("évènement"),
    );
  }
}
