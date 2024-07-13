part of 'event_screen_bloc.dart';

enum EventScreenStatus {
  initial,
  loading,
  success,
  error,
  attendsLoading,
  attendsSuccess,
  attendsError,
  changeAttendanceLoading,
  changeAttendanceSuccess,
  changeAttendanceError,
}

class EventScreenState {
  final EventScreenStatus status;
  final Event? event;
  final Group? group;
  final JwtData? userData;
  final Paginated<Attend>? participantsPage;
  final String? errorMessage;
  final bool? isAttending;

  EventScreenState({
    this.status = EventScreenStatus.initial,
    this.event,
    this.group,
    this.userData,
    this.participantsPage,
    this.errorMessage,
    this.isAttending,
  });

  EventScreenState copyWith({
    EventScreenStatus? status,
    Event? event,
    Group? group,
    JwtData? userData,
    Paginated<Attend>? participantsPage,
    String? errorMessage,
    bool? isAttending,
  }) {
    return EventScreenState(
      status: status ?? this.status,
      event: event ?? this.event,
      group: group ?? this.group,
      userData: userData ?? this.userData,
      participantsPage: participantsPage ?? this.participantsPage,
      errorMessage: errorMessage ?? this.errorMessage,
      isAttending: isAttending ?? this.isAttending,
    );
  }
}
