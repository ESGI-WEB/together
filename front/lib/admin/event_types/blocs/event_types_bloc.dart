import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/exceptions/conflit_exception.dart';
import 'package:front/core/models/event_type.dart';
import 'package:front/core/services/event_type_services.dart';

part 'event_types_event.dart';

part 'event_types_state.dart';

class EventTypesBloc extends Bloc<EventTypesEvent, EventTypesState> {
  EventTypesBloc() : super(EventTypesState()) {
    on<EventTypesDataTableLoaded>((event, emit) async {
      emit(state.copyWith(
        status: EventTypesStatus.tableLoading,
      ));

      try {
        final types = await EventTypeServices.getEventTypes();
        emit(state.copyWith(
          status: EventTypesStatus.tableSuccess,
          types: types,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: EventTypesStatus.tableError,
          errorMessage: error.message,
        ));
      }
    });

    on<EventTypeEdited>((event, emit) async {
      emit(state.copyWith(
        status: EventTypesStatus.addOrEditTypeLoading,
      ));

      try {
        final int? id = event.type.id;
        if (id == null) {
          await EventTypeServices.addEventType(event.type);
        } else {
          await EventTypeServices.editEventType(id, event.type);
        }

        emit(state.copyWith(
          status: EventTypesStatus.addOrEditTypeSuccess,
        ));

        add(EventTypesDataTableLoaded());
      } on ConflictException {
        emit(state.copyWith(
          status: EventTypesStatus.addOrEditTypeError,
          errorMessage: "Ce type d'événement existe déjà.",
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: EventTypesStatus.addOrEditTypeError,
          errorMessage: error.message,
        ));
      }
    });
  }
}
