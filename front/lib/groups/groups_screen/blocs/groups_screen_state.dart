part of 'groups_screen_bloc.dart';

enum GroupsScreenStatus {
  initial,
  loading,
  success,
  error,
}

class GroupsScreenState {
  final GroupsScreenStatus status;
  final List<Group>? groups;
  final String? errorMessage;

  GroupsScreenState({
    this.status = GroupsScreenStatus.initial,
    this.groups,
    this.errorMessage,
  });

  GroupsScreenState copyWith({
    GroupsScreenStatus? status,
    List<Group>? groups,
    String? errorMessage,
  }) {
    return GroupsScreenState(
      status: status ?? this.status,
      groups: groups ?? this.groups,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}