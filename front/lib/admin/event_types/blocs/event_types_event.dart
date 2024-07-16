part of 'event_types_bloc.dart';

@immutable
sealed class EventTypesEvent {}

class EventTypesDataTableLoaded extends EventTypesEvent {}

class EventTypeCreatedOrEdited extends EventTypesEvent {
  final EventTypeCreateOrEdit type;

  EventTypeCreatedOrEdited(this.type);
}
