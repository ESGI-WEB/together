part of 'event_types_count_bloc.dart';

enum EventTypesCountStatus {
  initial,
  loading,
  success,
  error,
}

class EventTypesCountState {
  final EventTypesCountStatus status;
  final String? errorMessage;
  final List<PieChartCount>? stats;

  EventTypesCountState({
    this.status = EventTypesCountStatus.initial,
    this.errorMessage,
    this.stats,
  });

  EventTypesCountState copyWith({
    EventTypesCountStatus? status,
    List<PieChartCount>? stats,
    String? errorMessage,
  }) {
    return EventTypesCountState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
