import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/group.dart';
import 'package:front/core/services/group_services.dart';
import 'package:flutter/foundation.dart';

part 'groups_screen_event.dart';
part 'groups_screen_state.dart';

class GroupsScreenBloc extends Bloc<GroupsScreenEvent, GroupsScreenState> {
  GroupsScreenBloc() : super(GroupsScreenState()) {
    on<GroupsScreenLoaded>((event, emit) async {
      emit(state.copyWith(
        status: GroupsScreenStatus.loading,
      ));

      try {
        final groups = await GroupServices.fetchGroups();
        emit(state.copyWith(
          status: GroupsScreenStatus.success,
          groups: groups,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: GroupsScreenStatus.error,
          errorMessage: error.message,
        ));
      }
    });

    on<GroupJoined>((event, emit) {
      final List<Group> updatedGroups = List.from(state.groups ?? []);
      updatedGroups.add(event.group);
      emit(state.copyWith(groups: updatedGroups));
    });

  }
}
