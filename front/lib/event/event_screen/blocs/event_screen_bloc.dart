import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/attend.dart';
import 'package:front/core/models/event.dart';
import 'package:front/core/models/group.dart';
import 'package:front/core/models/jwt_data.dart';
import 'package:front/core/models/paginated.dart';
import 'package:front/core/services/events_services.dart';
import 'package:front/core/services/group_services.dart';
import 'package:front/core/services/storage_service.dart';

part 'event_screen_event.dart';

part 'event_screen_state.dart';

class EventScreenBloc extends Bloc<EventScreenEvent, EventScreenState> {
  EventScreenBloc() : super(EventScreenState()) {
    on<EventScreenLoaded>((event, emit) async {
      emit(state.copyWith(
        status: EventScreenStatus.loading,
      ));

      try {
        final (
          nextEvent,
          group,
          userData,
          userAttend,
        ) = await (
          EventsServices.getEventById(event.eventId),
          GroupServices.getGroupById(event.groupId),
          StorageService.readJwtDataFromToken(),
          EventsServices.getUserAttendEvent(
            event.eventId,
          ),
        ).wait;

        emit(state.copyWith(
          status: EventScreenStatus.success,
          event: nextEvent,
          group: group,
          userData: userData,
          isAttending: userAttend?.hasAttended ?? false,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: EventScreenStatus.error,
          errorMessage: error.message,
        ));
      }
    });

    on<EventScreenEventAttendeesRequested>((event, emit) async {
      emit(state.copyWith(
        status: EventScreenStatus.attendsLoading,
      ));

      try {
        final page = await EventsServices.getEventAttends(
          eventId: event.eventId,
          hasAttended: true,
          page: event.page,
        );

        emit(state.copyWith(
          status: EventScreenStatus.attendsSuccess,
          participantsPage: page,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: EventScreenStatus.attendsError,
          errorMessage: error.message,
        ));
      }
    });

    on<EventAttendChanged>((event, emit) async {
      emit(state.copyWith(
        status: EventScreenStatus.changeAttendanceLoading,
      ));

      try {
        final attend = await EventsServices.changeEventAttend(
          eventId: event.eventId,
          isAttending: event.isAttending,
        );

        emit(state.copyWith(
          status: EventScreenStatus.success,
          isAttending: attend.hasAttended,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: EventScreenStatus.changeAttendanceError,
          errorMessage: error.message,
        ));
      }
    });
  }
}
