import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/pie_chart_count.dart';
import 'package:front/core/services/stats_services.dart';

part 'event_types_count_event.dart';
part 'event_types_count_state.dart';

class EventTypesCountBloc extends Bloc<EventTypesCountEvent, EventTypesCountState> {
  EventTypesCountBloc() : super(EventTypesCountState()) {
    on<EventTypesCountLoaded>((event, emit) async {
      emit(state.copyWith(
        status: EventTypesCountStatus.loading,
      ));

      try {
        final stats = await StatsServices.getEventTypesCount();
        emit(state.copyWith(
          status: EventTypesCountStatus.success,
          stats: stats,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: EventTypesCountStatus.error,
          errorMessage: error.message,
        ));
      }
    });
  }
}
