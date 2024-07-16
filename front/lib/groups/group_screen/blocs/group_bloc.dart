import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/services/group_services.dart';
import 'package:front/core/models/group.dart';
import 'package:front/core/services/storage_service.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  GroupBloc() : super(GroupState()) {
    on<LoadGroup>((event, emit) async {
      emit(state.copyWith(
        status: GroupStatus.loading,
      ));

      try {
        final group = await GroupServices.getGroupById(event.groupId);
        final userData = await StorageService.readJwtDataFromToken();
        emit(state.copyWith(
          status: GroupStatus.success,
          group: group,
          userData: userData,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: GroupStatus.error,
          errorMessage: error.message,
        ));
      }
    });
  }
}
