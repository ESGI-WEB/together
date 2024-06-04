import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/group.dart';
import 'package:front/core/services/group_services.dart';
import 'package:flutter/foundation.dart';

part 'create_group_event.dart';
part 'create_group_state.dart';

class CreateGroupBloc extends Bloc<CreateGroupEvent, CreateGroupState> {
  CreateGroupBloc() : super(CreateGroupState()) {
    on<CreateGroupSubmitted>((event, emit) async {
      emit(state.copyWith(
        status: CreateGroupStatus.loading,
      ));

      try {
        await GroupServices.createGroup(event.newGroup);
        final updatedGroups = await GroupServices.fetchGroups();
        emit(state.copyWith(
          status: CreateGroupStatus.success,
          groups: updatedGroups,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: CreateGroupStatus.error,
          errorMessage: error.message,
        ));
      }
    });
  }
}
