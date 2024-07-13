part of 'event_screen_bloc.dart';

@immutable
sealed class EventScreenEvent {}

class EventScreenLoaded extends EventScreenEvent {
  final int eventId;

  EventScreenLoaded({required this.eventId});
}

class DuplicateEvents extends EventScreenEvent {
  final DateTime date;
  final int eventId;

  DuplicateEvents({required this.date, required this.eventId});
}
