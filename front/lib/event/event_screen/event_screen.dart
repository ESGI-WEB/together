import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/models/address.dart';
import 'package:front/core/models/event.dart';
import 'package:front/core/partials/error_occurred.dart';
import 'package:front/core/partials/poll/blocs/poll_bloc.dart';
import 'package:front/core/partials/poll/poll_gateway.dart';
import 'package:front/event/event_screen/blocs/event_screen_bloc.dart';
import 'package:front/core/partials/avatar_stack.dart';
import 'package:front/event/event_screen/partials/event_screen_about.dart';
import 'package:front/event/event_screen/partials/event_screen_header.dart';
import 'package:front/event/event_screen/partials/event_screen_location.dart';
import 'package:go_router/go_router.dart';

class EventScreen extends StatelessWidget {
  static const String routeName = '/event-view';

  static void navigateTo(
    BuildContext context, {
    required int groupId,
    required int eventId,
  }) {
    context.goNamed(
      routeName,
      pathParameters: {
        'groupId': groupId.toString(),
        'eventId': eventId.toString(),
      },
    );
  }

  final int groupId;
  final int eventId;

  const EventScreen({
    super.key,
    required this.groupId,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          EventScreenBloc()..add(EventScreenLoaded(eventId: eventId)),
      child: BlocBuilder<EventScreenBloc, EventScreenState>(
        builder: (context, state) {
          if (state.status == EventScreenStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<EventScreenBloc>()
                  .add(EventScreenLoaded(eventId: eventId));
            },
            child: Builder(
              builder: (context) {
                final Event? event = state.event;
                if (state.status == EventScreenStatus.error || event == null) {
                  return const ErrorOccurred(
                    image: Image(
                      width: 150,
                      image: AssetImage('assets/images/event.gif'),
                    ),
                    alertMessage: "Oups ! Une erreur est survenue",
                    bodyMessage:
                        "Nous n'avons pas pu récuperer votre évènement",
                  );
                }

                final Address? address = event.address;

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EventScreenHeader(event: event),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Participants',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall,
                                          ),
                                          const SizedBox(height: 8),
                                          AvatarStack(
                                              users:
                                                  state.firstParticipants ?? []),
                                        ],
                                      ),
                                    ),
                                    if (address != null &&
                                        address.latlng != null)
                                      EventScreenLocation(
                                        localisation: address.latlng!,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            PollGateway(
                              id: event.id,
                              type: PollType.event,
                            ),
                            const SizedBox(height: 16),
                            EventScreenAbout(event: event),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
