part of 'event_screen_bloc.dart';

@immutable
sealed class EventScreenEvent {}

class EventScreenLoaded extends EventScreenEvent {
  final int eventId;
  final int groupId;

  EventScreenLoaded({
    required this.eventId,
    required this.groupId,
  });
}

class EventAttendChanged extends EventScreenEvent {
  final int eventId;
  final bool isAttending;

  EventAttendChanged({
    required this.eventId,
    required this.isAttending,
  });
}

class EventScreenEventAttendeesRequested extends EventScreenEvent {
  final int eventId;
  final int page;

  EventScreenEventAttendeesRequested({
    required this.eventId,
    this.page = 1,
  });
}

class DuplicateEvents extends EventScreenEvent {
  final DateTime date;
  final int eventId;

  DuplicateEvents({required this.date, required this.eventId});
}
