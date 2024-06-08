import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/group.dart';
import 'package:front/core/services/group_services.dart';

part 'create_group_event.dart';
part 'create_group_state.dart';

class CreateGroupBloc extends Bloc<CreateGroupEvent, CreateGroupState> {
  CreateGroupBloc() : super(CreateGroupState()) {
    on<CreateGroupSubmitted>((event, emit) async {
      emit(state.copyWith(
        status: CreateGroupStatus.loading,
      ));

      try {
        final newGroup = await GroupServices.createGroup(event.newGroup);
        emit(state.copyWith(
          status: CreateGroupStatus.success,
          newGroup: newGroup,
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
