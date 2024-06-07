import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/group.dart';
import 'package:front/core/services/group_services.dart';
import 'package:flutter/foundation.dart';

part 'groups_event.dart';
part 'groups_state.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  GroupsBloc() : super(GroupsState()) {
    on<GroupsLoaded>((event, emit) async {
      emit(state.copyWith(
        status: GroupsStatus.loading,
        page: 1,
        hasReachedMax: false,
      ));

      try {
        final groups = await GroupServices.fetchGroups(state.page, state.limit);
        emit(state.copyWith(
          status: GroupsStatus.success,
          groups: groups,
          hasReachedMax: groups.length < state.limit,
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
        final groups = await GroupServices.fetchGroups(newPage, state.limit);
        final updatedGroups = List<Group>.from(state.groups ?? [])..addAll(groups);
        emit(state.copyWith(
          status: GroupsStatus.success,
          groups: updatedGroups,
          page: newPage,
          hasReachedMax: groups.length < state.limit,
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