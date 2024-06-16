import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/models/event.dart';
import 'package:front/core/partials/event_card.dart';
import 'package:front/event/event_screen/event_screen.dart';

import 'blocs/next_events_list_bloc.dart';

class NextEventsList extends StatelessWidget {
  const NextEventsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "10 prochains évènements",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 24),
        BlocProvider(
          create: (context) =>
              NextEventsListBloc()..add(NextEventsListLoaded()),
          child: BlocBuilder<NextEventsListBloc, NextEventsListState>(
            builder: (BuildContext context, NextEventsListState state) {
              if (state.status == NextEventsListStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == NextEventsListStatus.error) {
                return Center(
                  child: Text(
                    state.errorMessage ??
                        'Une erreur est survenue lors du chargement des données.',
                  ),
                );
              }

              final List<Event>? events = state.eventsPage?.rows;
              if (events == null || events.isEmpty) {
                return const Center(
                  child: Text(
                    'Aucun évènement créé.',
                  ),
                );
              }

              return Container(
                constraints: const BoxConstraints(
                  maxHeight: 400,
                ),
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Event event = events[index];
                    return EventCard(
                      event: event,
                      onTap: () {
                        EventScreen.navigateTo(context, groupId: event.groupId, eventId: event.id);
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
