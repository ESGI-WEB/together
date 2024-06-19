import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/event.dart';
import 'package:front/core/models/filter.dart';
import 'package:front/core/models/paginated.dart';
import 'package:front/core/services/events_services.dart';

part 'next_events_list_event.dart';

part 'next_events_list_state.dart';

class NextEventsListBloc
    extends Bloc<NextEventsListEvent, NextEventsListState> {
  NextEventsListBloc() : super(NextEventsListState()) {
    on<NextEventsListLoaded>((event, emit) async {
      emit(state.copyWith(
        status: NextEventsListStatus.loading,
      ));

      try {
        final eventsPage = await EventsServices.getEvents(
          sort: 'date asc',
          limit: 10,
          filters: [
            Filter(
              column: 'date',
              operator: '>=',
              value: DateTime.now().toIso8601String(),
            ),
          ],
        );
        emit(state.copyWith(
          status: NextEventsListStatus.success,
          eventsPage: eventsPage,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: NextEventsListStatus.error,
          errorMessage: error.message,
        ));
      }
    });
  }
}
