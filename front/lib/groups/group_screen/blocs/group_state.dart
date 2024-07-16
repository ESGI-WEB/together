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
  final JwtData? userData;

  GroupState({
    this.status = GroupStatus.initial,
    this.group,
    this.errorMessage,
    this.userData,
  });

  GroupState copyWith({
    GroupStatus? status,
    Group? group,
    String? errorMessage,
    JwtData? userData,
  }) {
    return GroupState(
      status: status ?? this.status,
      group: group ?? this.group,
      errorMessage: errorMessage ?? this.errorMessage,
      userData: userData ?? this.userData,
    );
  }
}
