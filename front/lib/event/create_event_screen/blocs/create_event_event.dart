part of 'create_event_bloc.dart';

@immutable
sealed class CreateEventEvent {}

class CreateEventSubmitted extends CreateEventEvent {
  final EventCreate newEvent;

  CreateEventSubmitted(this.newEvent);
}
