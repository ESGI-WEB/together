import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/exceptions/api_exception.dart';
import '../../core/models/group.dart';
import '../../core/services/group_services.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final GroupServices groupServices;

  GroupBloc(this.groupServices) : super(GroupInitial()) {
    on<LoadGroups>((event, emit) async {
      emit(GroupLoading());

      try {
        final groups = await groupServices.fetchGroups();
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
      if (state is GroupLoadSuccess) {
        try {
          final newGroup = await groupServices.createGroup(event.newGroup);
          final updatedGroups = List<Group>.from((state as GroupLoadSuccess).groups)..add(newGroup);
          emit(GroupLoadSuccess(groups: updatedGroups));
        } catch (error) {
          if (error is ApiException) {
            emit(GroupLoadError(errorMessage: error.message));
          } else {
            emit(GroupLoadError(errorMessage: 'Failed to create group'));
          }
        }
      }
    });

    on<JoinGroup>((event, emit) async {
      if (state is GroupLoadSuccess) {
        try {
          await groupServices.joinGroup(event.groupId);
          add(LoadGroups());
        } catch (error) {
          if (error is ApiException) {
            emit(GroupLoadError(errorMessage: error.message));
          } else {
            emit(GroupLoadError(errorMessage: 'Failed to join group'));
          }
        }
      }
    });
  }
}