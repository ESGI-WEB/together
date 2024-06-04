import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/event.dart';
import 'package:front/core/services/group_services.dart';

part 'next_event_of_group_event.dart';

part 'next_event_of_group_state.dart';

class NextEventOfGroupBloc
    extends Bloc<NextEventOfGroupEvent, NextEventOfGroupState> {
  NextEventOfGroupBloc() : super(NextEventOfGroupState()) {
    on<NextEventOfGroupLoaded>((event, emit) async {
      emit(state.copyWith(
        status: NextEventOfGroupStatus.loading,
      ));

      try {
        final nextEvent = await GroupServices.getGroupNextEvent(event.groupId);
        emit(state.copyWith(
          status: NextEventOfGroupStatus.success,
          event: nextEvent,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: NextEventOfGroupStatus.error,
          errorMessage: error.message,
        ));
      }
    });
  }
}
