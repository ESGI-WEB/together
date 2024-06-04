import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/models/address.dart';
import 'package:front/core/models/event.dart';
import 'package:front/core/partials/app_layout.dart';
import 'package:front/core/partials/error_occurred.dart';
import 'package:front/event/event_screen/blocs/event_screen_bloc.dart';
import 'package:front/event/event_screen/partials/event_screen_about.dart';
import 'package:front/event/event_screen/partials/event_screen_header.dart';
import 'package:front/event/event_screen/partials/event_screen_members_and_location.dart';
import 'package:front/event/event_screen/partials/event_screen_poll.dart';

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
    return BlocProvider(
      create: (context) =>
          EventScreenBloc()..add(EventScreenLoaded(eventId: eventId)),
      child: BlocBuilder<EventScreenBloc, EventScreenState>(
        builder: (context, state) {
          if (state.status == EventScreenStatus.loading) {
            return const AppLayout(
              title: "Évènement",
              body: CircularProgressIndicator(),
            );
          }

          final Event? event = state.event;
          if (state.status == EventScreenStatus.error || event == null) {
            return const AppLayout(
              title: "Évènement",
              body: ErrorOccurred(
                image: Image(
                  width: 150,
                  image: AssetImage('assets/images/event.gif'),
                ),
                alertMessage: "Oups ! Une erreur est survenue",
                bodyMessage: "Nous n'avons pas pu récuperer votre évènement",
              ),
            );
          }

          return AppLayout(
            title: event.name,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EventScreenHeader(event: event),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        EventScreenMembersAndLocation(event: event),
                        const SizedBox(height: 16),
                        const EventScreenPoll(),
                        const SizedBox(height: 16),
                        EventScreenAbout(event: event),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
