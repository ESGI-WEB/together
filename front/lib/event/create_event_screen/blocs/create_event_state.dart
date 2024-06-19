part of 'create_event_bloc.dart';

enum CreateEventStatus {
  initial,
  loading,
  success,
  error,
}

class CreateEventState {
  final CreateEventStatus status;
  final Event? newEvent;
  final String? errorMessage;

  CreateEventState({
    this.status = CreateEventStatus.initial,
    this.newEvent,
    this.errorMessage,
  });

  CreateEventState copyWith({
    CreateEventStatus? status,
    Event? newEvent,
    String? errorMessage,
  }) {
    return CreateEventState(
      status: status ?? this.status,
      newEvent: newEvent ?? this.newEvent,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
