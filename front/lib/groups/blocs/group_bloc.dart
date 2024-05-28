import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../core/exceptions/api_exception.dart';
import '../../core/models/group.dart';
import '../../core/services/group_services.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  GroupBloc() : super(GroupInitial()) {
    on<LoadGroups>(_onLoadGroups);
    on<CreateGroup>(_onCreateGroup);
    on<JoinGroup>(_onJoinGroup);
    on<LoadGroup>(_onLoadGroup);
  }

  void _onLoadGroups(LoadGroups event, Emitter<GroupState> emit) async {
    emit(GroupLoading());
    try {
      final groups = await GroupServices.fetchGroups();
      emit(GroupsLoadSuccess(groups: groups));
    } catch (error) {
      emit(GroupsLoadError(errorMessage: error is ApiException ? error.message : 'Failed to load groups'));
    }
  }

  void _onCreateGroup(CreateGroup event, Emitter<GroupState> emit) async {
    emit(GroupLoading());
    try {
      await GroupServices.createGroup(event.newGroup);
      final updatedGroups = await GroupServices.fetchGroups();
      emit(GroupsLoadSuccess(groups: updatedGroups));
    } catch (error) {
      emit(GroupsLoadError(errorMessage: error is ApiException ? error.message : 'Failed to create group'));
    }
  }

  void _onJoinGroup(JoinGroup event, Emitter<GroupState> emit) async {
    emit(GroupLoading());
    try {
      await GroupServices.joinGroup(event.code);
      final updatedGroups = await GroupServices.fetchGroups();
      emit(GroupsLoadSuccess(groups: updatedGroups));
    } catch (error) {
      emit(GroupsLoadError(errorMessage: error is ApiException ? error.message : 'Failed to join group'));
    }
  }

  void _onLoadGroup(LoadGroup event, Emitter<GroupState> emit) async {
    emit(GroupLoading());
    try {
      final group = await GroupServices.getGroupById(event.groupId);
      emit(GroupLoadSingleSuccess(group: group));
    } catch (error) {
      emit(GroupsLoadError(errorMessage: error is ApiException ? error.message : 'Failed to load group'));
    }
  }

}