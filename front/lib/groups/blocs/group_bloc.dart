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
      if (state is GroupLoadSuccess) {
        final updatedGroups =
            List<Map<String, dynamic>>.from((state as GroupLoadSuccess).groups);
        updatedGroups.add(event.newGroup);
        emit(GroupLoadSuccess(groups: updatedGroups));
      }
    });

    on<JoinGroup>((event, emit) {
      // Handle joining a group logic here
      // For simplicity, let's assume we add a member to a group
      if (state is GroupLoadSuccess) {
        final updatedGroups = (state as GroupLoadSuccess).groups.map((group) {
          if (group["id"] == event.groupId) {
            // Simulate joining a group by updating the group details
            return {
              ...group,
              "members":
                  (group["members"] ?? 0) + 1, // Example member count increment
            };
          }
          return group;
        }).toList();
        emit(GroupLoadSuccess(groups: updatedGroups));
      }
    });
  }
}
