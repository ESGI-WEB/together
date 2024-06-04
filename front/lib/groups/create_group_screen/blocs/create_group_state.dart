part of 'create_group_bloc.dart';

enum CreateGroupStatus {
  initial,
  loading,
  success,
  error,
}

class CreateGroupState {
  final CreateGroupStatus status;
  final List<Group>? groups;
  final String? errorMessage;

  CreateGroupState({
    this.status = CreateGroupStatus.initial,
    this.groups,
    this.errorMessage,
  });

  CreateGroupState copyWith({
    CreateGroupStatus? status,
    List<Group>? groups,
    String? errorMessage,
  }) {
    return CreateGroupState(
      status: status ?? this.status,
      groups: groups ?? this.groups,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
