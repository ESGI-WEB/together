part of 'monthly_messages_bloc.dart';

enum MonthlyMessagesStatus {
  initial,
  loading,
  success,
  error,
}

class MonthlyMessagesState {
  final MonthlyMessagesStatus status;
  final String? errorMessage;
  final List<MonthlyChartData>? stats;

  MonthlyMessagesState({
    this.status = MonthlyMessagesStatus.initial,
    this.errorMessage,
    this.stats,
  });

  MonthlyMessagesState copyWith({
    MonthlyMessagesStatus? status,
    List<MonthlyChartData>? stats,
    String? errorMessage,
  }) {
    return MonthlyMessagesState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
