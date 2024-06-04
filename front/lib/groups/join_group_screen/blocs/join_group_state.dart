part of 'join_group_bloc.dart';

enum JoinGroupStatus {
  initial,
  loading,
  success,
  error,
}

class JoinGroupState {
  final JoinGroupStatus status;
  final List<Group>? groups;
  final String? errorMessage;

  JoinGroupState({
    this.status = JoinGroupStatus.initial,
    this.groups,
    this.errorMessage,
  });

  JoinGroupState copyWith({
    JoinGroupStatus? status,
    List<Group>? groups,
    String? errorMessage,
  }) {
    return JoinGroupState(
      status: status ?? this.status,
      groups: groups ?? this.groups,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
