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
