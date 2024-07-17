import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/event.dart';
import 'package:front/core/models/group.dart';
import 'package:front/core/services/group_services.dart';
import 'package:front/core/services/user_services.dart';

part 'groups_event.dart';
part 'groups_state.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  GroupsBloc() : super(GroupsState()) {
    on<GroupsLoaded>((event, emit) async {
      emit(state.copyWith(
        status: GroupsStatus.loading,
        page: event.page,
        hasReachedMax: false,
      ));

      try {
        final paginatedGroups = await GroupServices.fetchGroups(state.page, state.limit);

        if (event.page == 1) {
          try {
            final nextEventOfUser = await UserServices.getUserNextEvents();
            emit(state.copyWith(nextEventOfUser: nextEventOfUser.rows.firstOrNull));
          } catch (error) {
            // Do nothing, we don't want to block the groups loading
          }
        }

        emit(state.copyWith(
          status: GroupsStatus.success,
          groups: paginatedGroups.rows,
          total: paginatedGroups.total,
          pages: paginatedGroups.pages,
          hasReachedMax: paginatedGroups.page >= paginatedGroups.pages,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: GroupsStatus.error,
          errorMessage: error.message,
        ));
      }
    });

    on<GroupJoined>((event, emit) {
      final List<Group> updatedGroups = List.from(state.groups ?? []);
      updatedGroups.add(event.group);
      emit(state.copyWith(groups: updatedGroups));
    });

    on<GroupsLoadMore>((event, emit) async {
      if (state.hasReachedMax || state.status == GroupsStatus.loadingMore) return;

      try {
        emit(state.copyWith(status: GroupsStatus.loadingMore));
        final newPage = state.page + 1;
        final paginatedGroups = await GroupServices.fetchGroups(newPage, state.limit);
        final updatedGroups = List<Group>.from(state.groups ?? [])..addAll(paginatedGroups.rows);
        emit(state.copyWith(
          status: GroupsStatus.success,
          groups: updatedGroups,
          page: newPage,
          hasReachedMax: newPage >= paginatedGroups.pages,
        ));
      } on ApiException catch (error) {
        emit(state.copyWith(
          status: GroupsStatus.error,
          errorMessage: error.message,
        ));
      }
    });
  }
}