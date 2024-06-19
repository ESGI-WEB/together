import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/monthly_chart_data.dart';
import 'package:front/core/services/stats_services.dart';

part 'monthly_last_year_registration_event.dart';
part 'monthly_last_year_registration_state.dart';

class MonthlyLastYearRegistrationBloc extends Bloc<MonthlyLastYearRegistrationEvent, MonthlyLastYearRegistrationState> {
  MonthlyLastYearRegistrationBloc() : super(MonthlyLastYearRegistrationState()) {
    on<MonthlyLastYearRegistrationLoaded>((event, emit) async {
      emit(state.copyWith(
        status: MonthlyLastYearRegistrationStatus.loading,
      ));

      try {
        final stats = await StatsServices.getLastYearRegistrationsCount();
        emit(state.copyWith(
          status: MonthlyLastYearRegistrationStatus.success,
          stats: stats,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: MonthlyLastYearRegistrationStatus.error,
          errorMessage: error.message,
        ));
      }
    });
  }
}
