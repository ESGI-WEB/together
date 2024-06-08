part of 'event_types_bloc.dart';

@immutable
sealed class EventTypesEvent {}

class EventTypesDataTableLoaded extends EventTypesEvent {}

class EventTypeEdited extends EventTypesEvent {
  final EventTypeCreateOrEdit type;

  EventTypeEdited(this.type);
}
