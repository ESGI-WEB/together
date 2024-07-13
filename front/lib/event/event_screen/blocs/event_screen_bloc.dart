import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/event.dart';
import 'package:front/core/models/group.dart';
import 'package:front/core/models/jwt_data.dart';
import 'package:front/core/models/user.dart';
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
        final (nextEvent, acceptedParticipants, group, userData) = await (
          EventsServices.getEventById(event.eventId),
          EventsServices.getEventAttends(
            eventId: event.eventId,
            hasAttended: true,
          ),
          GroupServices.getGroupById(event.groupId),
          StorageService.readJwtDataFromToken(),
        ).wait;

        emit(state.copyWith(
          status: EventScreenStatus.success,
          event: nextEvent,
          firstParticipants: acceptedParticipants.rows
              .where((element) => element.user != null)
              .map((e) => e.user as User)
              .toList(),
          group: group,
          userData: userData,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: EventScreenStatus.error,
          errorMessage: error.message,
        ));
      }
    });

    on<DuplicateEvents>((event, emit) async {
      try {
        await EventsServices.duplicateEventsForDate(event.eventId, event.date);
        emit(state.copyWith(
          status: EventScreenStatus.success,
        ));
      } catch (error) {
        emit(state.copyWith(
          status: EventScreenStatus.error,
          errorMessage: error.toString(),
        ));
      }
    });
  }
}
