part of 'next_events_list_bloc.dart';

enum NextEventsListStatus {
  initial,
  loading,
  success,
  error,
}

class NextEventsListState {
  final NextEventsListStatus status;
  final String? errorMessage;
  final Paginated<Event>? eventsPage;

  NextEventsListState({
    this.status = NextEventsListStatus.initial,
    this.errorMessage,
    this.eventsPage,
  });

  NextEventsListState copyWith({
    NextEventsListStatus? status,
    Paginated<Event>? eventsPage,
    String? errorMessage,
  }) {
    return NextEventsListState(
      status: status ?? this.status,
      eventsPage: eventsPage ?? this.eventsPage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
