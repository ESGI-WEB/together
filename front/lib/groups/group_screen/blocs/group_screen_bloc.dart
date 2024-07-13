import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/group.dart';
import 'package:front/core/models/jwt_data.dart';
import 'package:front/core/services/group_services.dart';
import 'package:front/core/services/storage_service.dart';

part 'group_screen_event.dart';

part 'group_screen_state.dart';

class GroupScreenBloc extends Bloc<GroupScreenEvent, GroupScreenState> {
  GroupScreenBloc() : super(GroupScreenState()) {
    on<LoadGroupScreen>((event, emit) async {
      emit(state.copyWith(
        status: GroupScreenStatus.loading,
      ));

      try {
        final group = await GroupServices.getGroupById(event.groupId);
        final userData = await StorageService.readJwtDataFromToken();
        emit(state.copyWith(
          status: GroupScreenStatus.success,
          group: group,
          userData: userData,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: GroupScreenStatus.error,
          errorMessage: error.message,
        ));
      }
    });
  }
}
