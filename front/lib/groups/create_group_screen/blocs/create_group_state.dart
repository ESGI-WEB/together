part of 'create_group_bloc.dart';

enum CreateGroupStatus {
  initial,
  loading,
  success,
  error,
}

class CreateGroupState {
  final CreateGroupStatus status;
  final Group? newGroup;
  final String? errorMessage;

  CreateGroupState({
    this.status = CreateGroupStatus.initial,
    this.newGroup,
    this.errorMessage,
  });

  CreateGroupState copyWith({
    CreateGroupStatus? status,
    Group? newGroup,
    String? errorMessage,
  }) {
    return CreateGroupState(
      status: status ?? this.status,
      newGroup: newGroup ?? this.newGroup,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
