import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../core/exceptions/api_exception.dart';
import '../../core/models/group.dart';
import '../../core/services/group_services.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {

  GroupBloc() : super(GroupInitial()) {
    on<LoadGroups>((event, emit) async {
      emit(GroupLoading());
      try {
        final groups = await GroupServices.fetchGroups();
        emit(GroupLoadSuccess(groups: groups));
      } catch (error) {
        if (error is ApiException) {
          emit(GroupLoadError(errorMessage: error.message));
        } else {
          emit(GroupLoadError(errorMessage: 'Failed to load groups'));
        }
      }
    });

    on<CreateGroup>((event, emit) async {
      emit(GroupLoading());
      try {
        final newGroup = await GroupServices.createGroup(event.newGroup);
        if (state is GroupLoadSuccess) {
          final updatedGroups = List<Group>.from((state as GroupLoadSuccess).groups)..add(newGroup);
          emit(GroupLoadSuccess(groups: updatedGroups));
        } else {
          emit(GroupLoadSuccess(groups: [newGroup]));
        }
      } catch (error) {
        if (error is ApiException) {
          emit(GroupLoadError(errorMessage: error.message));
        } else {
          emit(GroupLoadError(errorMessage: 'Failed to create group'));
        }
      }
    });

    on<JoinGroup>((event, emit) async {
      emit(GroupLoading());
      try {
        await GroupServices.joinGroup(event.groupId);
        add(LoadGroups()); // Reload groups after joining
      } catch (error) {
        if (error is ApiException) {
          emit(GroupLoadError(errorMessage: error.message));
        } else {
          emit(GroupLoadError(errorMessage: 'Failed to join group'));
        }
      }
    });
  }
}