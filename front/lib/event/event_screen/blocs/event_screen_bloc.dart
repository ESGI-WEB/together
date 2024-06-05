import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/event.dart';
import 'package:front/core/models/user.dart';
import 'package:front/core/services/events_services.dart';

part 'event_screen_event.dart';

part 'event_screen_state.dart';

class EventScreenBloc extends Bloc<EventScreenEvent, EventScreenState> {
  EventScreenBloc() : super(EventScreenState()) {
    on<EventScreenLoaded>((event, emit) async {
      emit(state.copyWith(
        status: EventScreenStatus.loading,
      ));

      try {
        final nextEvent = await EventsServices.getEventById(event.eventId);
        final acceptedParticipants = await EventsServices.getEventAttends(eventId: event.eventId, hasAttended: true);
        emit(state.copyWith(
          status: EventScreenStatus.success,
          event: nextEvent,
          firstParticipants: acceptedParticipants.rows.where((element) => element.user != null).map((e) => e.user as User).toList()
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: EventScreenStatus.error,
          errorMessage: error.message,
        ));
      }
    });
  }
}
