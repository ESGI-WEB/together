import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/models/event.dart';
import '../core/services/events_services.dart';

class EventScreen extends StatelessWidget {
  static const String routeName = 'events';

  final String eventId;

  static void navigateTo(BuildContext context,
      {required String groupId, required String eventId}) {
    context.goNamed(routeName,
        pathParameters: {'id': groupId, 'eventId': eventId});
  }

  const EventScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Évènement"),
      ),
      body: FutureBuilder<Event>(
        future: EventsServices.getEventById(int.parse(eventId)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Aucun événement trouvé'));
          } else {
            final event = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Description: ${event.description}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Date: ${event.date}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 8.0),
                  if (event.time != null)
                    Text(
                      'Heure: ${event.time}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Type ID: ${event.typeId}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Organizer ID: ${event.organizerId}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Address ID: ${event.addressId}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
