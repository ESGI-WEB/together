import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/models/user.dart';
import 'package:front/event/event_screen/blocs/event_screen_bloc.dart';

class EventAttendsList extends StatelessWidget {
  final int eventId;

  final List<User> users = [];

  EventAttendsList({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventScreenBloc()
        ..add(
          EventScreenEventAttendeesRequested(
            eventId: eventId,
            page: 1,
          ),
        ),
      child: BlocListener<EventScreenBloc, EventScreenState>(
        listener: (context, state) {
          if (state.status == EventScreenStatus.attendsSuccess) {
            final page = state.participantsPage;
            if (page != null) {
              if (page.page == 1) {
                users.clear();
              }

              users.addAll(
                page.rows
                    .where((e) => e.user != null)
                    .where((e) => !users.any((u) => u.id == e.user?.id))
                    .map((e) => e.user!)
                    .toList(),
              );
            }
          }
        },
        child: BlocBuilder<EventScreenBloc, EventScreenState>(
          builder: (context, state) {
            // if nothing to show, display message
            if (state.status == EventScreenStatus.attendsSuccess && users.isEmpty) {
              return const Center(
                child: Text("Aucun participants à l'évènement"),
              );
            }

            // show a list of user, and add infinite scroll to load more pages when on bottom where page < pages
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
