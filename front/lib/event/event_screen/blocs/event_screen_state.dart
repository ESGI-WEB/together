part of 'event_screen_bloc.dart';

enum EventScreenStatus {
  initial,
  loading,
  success,
  error,
}

class EventScreenState {
  final EventScreenStatus status;
  final Event? event;
  final String? errorMessage;

  EventScreenState({
    this.status = EventScreenStatus.initial,
    this.event,
    this.errorMessage,
  });

  EventScreenState copyWith({
    EventScreenStatus? status,
    Event? event,
    String? errorMessage,
  }) {
    return EventScreenState(
      status: status ?? this.status,
      event: event ?? this.event,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
