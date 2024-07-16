import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/chat/blocs/websocket_bloc.dart';
import 'package:front/chat/blocs/websocket_state.dart';
import 'package:front/core/models/address.dart';
import 'package:front/core/models/event.dart';
import 'package:front/core/models/user.dart';
import 'package:front/core/partials/avatar_stack.dart';
import 'package:front/core/partials/error_occurred.dart';
import 'package:front/core/partials/poll/blocs/poll_bloc.dart';
import 'package:front/core/partials/poll/poll_gateway.dart';
import 'package:front/event/event_screen/blocs/event_screen_bloc.dart';
import 'package:front/event/event_screen/partials/event_attends_list.dart';
import 'package:front/event/event_screen/partials/event_screen_about.dart';
import 'package:front/event/event_screen/partials/event_screen_header.dart';
import 'package:front/event/event_screen/partials/event_screen_location.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EventScreen extends StatelessWidget {
  static const String routeName = 'event-view';

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

  final List<User> participants = [];

  EventScreen({
    super.key,
    required this.groupId,
    required this.eventId,
  });

  void _onAttendChanged(BuildContext context, EventScreenState state) {
    context.read<EventScreenBloc>().add(
          EventAttendChanged(
            eventId: eventId,
            isAttending: state.isAttending != null ? !state.isAttending! : true,
          ),
        );
  }

  void _openAttendsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(32),
          child: EventAttendsList(
            eventId: eventId,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventScreenBloc()
        ..add(
          EventScreenLoaded(
            eventId: eventId,
            groupId: groupId,
          ),
        )
        ..add(
          EventScreenEventAttendeesRequested(
            eventId: eventId,
            page: 1,
          ),
        ),
      child: BlocBuilder<WebSocketBloc, WebSocketState>(
        builder: (context, state) {
          return BlocListener<WebSocketBloc, WebSocketState>(
            listener: (context, state) {
              if (state is EventAttendChangedState) {
                context.read<EventScreenBloc>().add(
                      EventScreenEventAttendeesRequested(
                        eventId: eventId,
                        page: 1,
                      ),
                    );
              }
            },
            child: BlocListener<EventScreenBloc, EventScreenState>(
              listener: (context, state) {
                if (state.status == EventScreenStatus.attendsSuccess) {
                  final page = state.participantsPage;
                  if (page != null) {
                    if (page.page == 1) {
                      participants.clear();
                    }

                    participants.addAll(
                      page.rows
                          .where((e) => e.user != null)
                          .where((e) =>
                              !participants.any((u) => u.id == e.user?.id))
                          .map((e) => e.user!)
                          .toList(),
                    );
                  }
                }
                if (state.status == EventScreenStatus.duplicateSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!
                          .eventSuccessFullyDuplicated),
                    ),
                  );
                }
                if (state.status == EventScreenStatus.duplicateError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage ??
                          AppLocalizations.of(context)!.errorOccurred),
                    ),
                  );
                }
              },
              child: BlocBuilder<EventScreenBloc, EventScreenState>(
                builder: (context, state) {
                  if (state.status == EventScreenStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<EventScreenBloc>().add(
                            EventScreenLoaded(
                              eventId: eventId,
                              groupId: groupId,
                            ),
                          );
                    },
                    child: Builder(
                      builder: (context) {
                        final Event? event = state.event;
                        if (state.status == EventScreenStatus.error ||
                            event == null) {
                          return ErrorOccurred(
                            image: const Image(
                              width: 150,
                              image: AssetImage('assets/images/event.gif'),
                            ),
                            alertMessage: AppLocalizations.of(context)!
                                .oopsAnErrorOccurred,
                            bodyMessage:
                                AppLocalizations.of(context)!.eventNotQueried,
                          );
                        }

                        final Address? address = event.address;
                        final bool hasParentEditionRights =
                            state.event?.organizerId == state.userData?.id ||
                                state.group?.ownerId == state.userData?.id;

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
                                        padding:
                                            const EdgeInsets.only(left: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${state.participantsPage?.total} participants',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  GestureDetector(
                                                    onTap: () =>
                                                        _openAttendsSheet(
                                                            context),
                                                    child: AvatarStack(
                                                      users: participants,
                                                      total: state
                                                          .participantsPage
                                                          ?.total,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  OutlinedButton(
                                                      onPressed: state.status ==
                                                              EventScreenStatus
                                                                  .changeAttendanceLoading
                                                          ? null
                                                          : () =>
                                                              _onAttendChanged(
                                                                  context,
                                                                  state),
                                                      child: Text(
                                                        state.isAttending ==
                                                                true
                                                            ? AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .notParticipate
                                                            : AppLocalizations
                                                                    .of(context)!
                                                                .participate,
                                                      ))
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
                                      hasParentEditionRights:
                                          hasParentEditionRights,
                                    ),
                                    const SizedBox(height: 16),
                                    EventScreenAbout(event: event),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () async {
                                        DateTime? selectedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now()
                                              .add(const Duration(days: 1)),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2101),
                                        );

                                        if (selectedDate != null) {
                                          context.read<EventScreenBloc>().add(
                                                DuplicateEvents(
                                                  eventId: eventId,
                                                  date: selectedDate,
                                                ),
                                              );
                                        }
                                      },
                                      child: Text(AppLocalizations.of(context)!
                                          .duplicateAnotherDay),
                                    ),
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
            ),
          );
        },
      ),
    );
  }
}
