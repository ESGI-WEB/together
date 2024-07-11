part of 'group_bloc.dart';

enum GroupStatus {
  initial,
  loading,
  success,
  error,
}

class GroupState {
  final GroupStatus status;
  final Group? group;
  final String? errorMessage;

  GroupState({
    this.status = GroupStatus.initial,
    this.group,
    this.errorMessage,
  });

  GroupState copyWith({
    GroupStatus? status,
    Group? group,
    String? errorMessage,
  }) {
    return GroupState(
      status: status ?? this.status,
      group: group ?? this.group,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
