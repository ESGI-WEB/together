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
  final Group? group;
  final JwtData? userData;
  final List<User>? firstParticipants;
  final String? errorMessage;

  EventScreenState({
    this.status = EventScreenStatus.initial,
    this.event,
    this.group,
    this.userData,
    this.firstParticipants,
    this.errorMessage,
  });

  EventScreenState copyWith({
    EventScreenStatus? status,
    Event? event,
    Group? group,
    JwtData? userData,
    List<User>? firstParticipants,
    String? errorMessage,
  }) {
    return EventScreenState(
      status: status ?? this.status,
      event: event ?? this.event,
      group: group ?? this.group,
      userData: userData ?? this.userData,
      firstParticipants: firstParticipants ?? this.firstParticipants,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
