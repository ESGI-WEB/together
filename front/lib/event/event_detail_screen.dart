import 'package:flutter/material.dart';
import 'package:front/core/services/events_services.dart';
import 'package:front/core/models/event.dart';

class EventDetailScreen extends StatelessWidget {
  static const String routeName = '/eventDetail';

  final int eventId;

  const EventDetailScreen({required this.eventId, Key? key}) : super(key: key);

  Future<Event> _fetchEventDetails() async {
    return await EventsServices.getEventById(eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de l\'événement'),
      ),
      body: FutureBuilder<Event>(
        future: _fetchEventDetails(),
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
                  Text('Nom: ${event.name}',
                      style: Theme.of(context).textTheme.headline6),
                  const SizedBox(height: 8),
                  Text('Description: ${event.description}'),
                  const SizedBox(height: 8),
                  Text('Date: ${event.date}'),
                  const SizedBox(height: 8),
                  Text('Heure: ${event.time}'),
                  // Display other event details...
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
