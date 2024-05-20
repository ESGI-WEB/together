import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  GroupBloc() : super(GroupInitial()) {
    on<LoadGroups>((event, emit) async {
      emit(GroupLoading());

      try {
        // Simulate fetching data from an API or database
        await Future.delayed(const Duration(seconds: 2));
        final groups = [
          {
            "id": 1,
            "name": "Groupe 1",
            "description": "Description du groupe 1",
            "imagePath": "lib/core/images/group1.jpg",
          },
          {
            "id": 2,
            "name": "Groupe 2",
            "description": "Description du groupe 2",
            "imagePath": "lib/core/images/group1.jpg",
          },
        ];
        emit(GroupLoadSuccess(groups: groups));
      } catch (error) {
        emit(GroupLoadError(errorMessage: 'Failed to load groups'));
      }
    });

    on<CreateGroup>((event, emit) {
      // Handle group creation logic here
    });

    on<JoinGroup>((event, emit) {
      // Handle joining a group logic here
    });
  }
}