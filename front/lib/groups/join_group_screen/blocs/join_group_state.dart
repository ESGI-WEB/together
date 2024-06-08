part of 'join_group_bloc.dart';

enum JoinGroupStatus {
  initial,
  loading,
  success,
  error,
}

class JoinGroupState {
  final JoinGroupStatus status;
  final Group? newGroup;
  final String? errorMessage;

  JoinGroupState({
    this.status = JoinGroupStatus.initial,
    this.newGroup,
    this.errorMessage,
  });

  JoinGroupState copyWith({
    JoinGroupStatus? status,
    Group? newGroup,
    String? errorMessage,
  }) {
    return JoinGroupState(
      status: status ?? this.status,
      newGroup: newGroup ?? this.newGroup,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}