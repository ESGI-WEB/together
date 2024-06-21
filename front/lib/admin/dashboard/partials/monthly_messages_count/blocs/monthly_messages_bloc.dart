import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/monthly_chart_data.dart';
import 'package:front/core/services/stats_services.dart';

part 'monthly_messages_event.dart';
part 'monthly_messages_state.dart';

class MonthlyMessagesBloc extends Bloc<MonthlyMessagesEvent, MonthlyMessagesState> {
  MonthlyMessagesBloc() : super(MonthlyMessagesState()) {
    on<MonthlyMessagesLoaded>((event, emit) async {
      emit(state.copyWith(
        status: MonthlyMessagesStatus.loading,
      ));

      try {
        final stats = await StatsServices.getMonthlyMessagesCount();
        emit(state.copyWith(
          status: MonthlyMessagesStatus.success,
          stats: stats,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: MonthlyMessagesStatus.error,
          errorMessage: error.message,
        ));
      }
    });
  }
}
