part of 'group_screen_bloc.dart';

enum GroupScreenStatus {
  initial,
  loading,
  success,
  error,
}

class GroupScreenState {
  final GroupScreenStatus status;
  final Group? group;
  final String? errorMessage;

  GroupScreenState({
    this.status = GroupScreenStatus.initial,
    this.group,
    this.errorMessage,
  });

  GroupScreenState copyWith({
    GroupScreenStatus? status,
    Group? group,
    String? errorMessage,
  }) {
    return GroupScreenState(
      status: status ?? this.status,
      group: group ?? this.group,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
