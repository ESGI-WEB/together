import 'package:flutter/material.dart';
import 'package:front/core/models/event.dart';

class EventScreenAbout extends StatelessWidget {
  final Event event;

  const EventScreenAbout({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "A propos de l'évènement",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          event.description,
        ),
      ],
    );
  }
}
