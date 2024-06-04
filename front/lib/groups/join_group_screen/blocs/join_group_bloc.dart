import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/group.dart';
import 'package:front/core/services/group_services.dart';
import 'package:flutter/foundation.dart';

part 'join_group_event.dart';
part 'join_group_state.dart';

class JoinGroupBloc extends Bloc<JoinGroupEvent, JoinGroupState> {
  JoinGroupBloc() : super(JoinGroupState()) {
    on<JoinGroupSubmitted>((event, emit) async {
      emit(state.copyWith(
        status: JoinGroupStatus.loading,
      ));

      try {
        await GroupServices.joinGroup(event.code);
        final updatedGroups = await GroupServices.fetchGroups();
        emit(state.copyWith(
          status: JoinGroupStatus.success,
          groups: updatedGroups,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: JoinGroupStatus.error,
          errorMessage: error.message,
        ));
      }
    });
  }
}
