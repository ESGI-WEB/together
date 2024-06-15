part of 'monthly_last_year_registration_bloc.dart';

enum MonthlyLastYearRegistrationStatus {
  initial,
  loading,
  success,
  error,
}

class MonthlyLastYearRegistrationState {
  final MonthlyLastYearRegistrationStatus status;
  final String? errorMessage;
  final List<MonthlyChartData>? stats;

  MonthlyLastYearRegistrationState({
    this.status = MonthlyLastYearRegistrationStatus.initial,
    this.errorMessage,
    this.stats,
  });

  MonthlyLastYearRegistrationState copyWith({
    MonthlyLastYearRegistrationStatus? status,
    List<MonthlyChartData>? stats,
    String? errorMessage,
  }) {
    return MonthlyLastYearRegistrationState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
