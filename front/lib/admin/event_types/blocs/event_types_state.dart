part of 'event_types_bloc.dart';

enum EventTypesStatus {
  initial,
  tableLoading,
  tableSuccess,
  tableError,
  addOrEditTypeLoading,
  addOrEditTypeError,
  addOrEditTypeSuccess,
}

class EventTypesState {
  final EventTypesStatus status;
  final String? errorMessage;
  final List<EventType>? types;

  EventTypesState({
    this.status = EventTypesStatus.initial,
    this.errorMessage,
    this.types,
  });

  EventTypesState copyWith({
    EventTypesStatus? status,
    List<EventType>? types,
    String? errorMessage,
  }) {
    return EventTypesState(
      status: status ?? this.status,
      types: types ?? this.types,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
