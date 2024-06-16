import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/event.dart';
import 'package:front/core/services/events_services.dart';

part 'create_event_event.dart';
part 'create_event_state.dart';

class CreateEventBloc extends Bloc<CreateEventEvent, CreateEventState> {
  CreateEventBloc() : super(CreateEventState()) {
    on<CreateEventSubmitted>((event, emit) async {
      emit(state.copyWith(
        status: CreateEventStatus.loading,
      ));

      try {
        final newEvent = await EventsServices.createEvent(event.newEvent);
        emit(state.copyWith(
          status: CreateEventStatus.success,
          newEvent: newEvent,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: CreateEventStatus.error,
          errorMessage: error.message,
        ));
      }
    });
  }
}
