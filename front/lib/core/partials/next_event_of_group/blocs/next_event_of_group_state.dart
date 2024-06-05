part of 'next_event_of_group_bloc.dart';

enum NextEventOfGroupStatus {
  initial,
  loading,
  success,
  error,
}

class NextEventOfGroupState {
  final NextEventOfGroupStatus status;
  final Event? event;
  final String? errorMessage;

  NextEventOfGroupState({
    this.status = NextEventOfGroupStatus.initial,
    this.event,
    this.errorMessage,
  });

  NextEventOfGroupState copyWith({
    NextEventOfGroupStatus? status,
    Event? event,
    String? errorMessage,
  }) {
    return NextEventOfGroupState(
      status: status ?? this.status,
      event: event ?? this.event,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
