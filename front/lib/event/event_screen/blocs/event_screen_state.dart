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
  final List<User>? firstParticipants;
  final String? errorMessage;

  EventScreenState({
    this.status = EventScreenStatus.initial,
    this.event,
    this.firstParticipants,
    this.errorMessage,
  });

  EventScreenState copyWith({
    EventScreenStatus? status,
    Event? event,
    List<User>? firstParticipants,
    String? errorMessage,
  }) {
    return EventScreenState(
      status: status ?? this.status,
      event: event ?? this.event,
      firstParticipants: firstParticipants ?? this.firstParticipants,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
