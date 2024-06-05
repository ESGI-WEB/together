part of 'event_screen_bloc.dart';

@immutable
sealed class EventScreenEvent {}

class EventScreenLoaded extends EventScreenEvent {
  final int eventId;

  EventScreenLoaded({required this.eventId});
}
