import 'package:flutter/material.dart';
import 'package:front/core/models/event.dart';

class EventScreenMembersAndLocation extends StatelessWidget {
  final Event event;

  const EventScreenMembersAndLocation({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Row(
        children: [
          Text("X membres"),
          Spacer(),
          Text("Carte maps"),
        ],
      ),
    );
  }
}
