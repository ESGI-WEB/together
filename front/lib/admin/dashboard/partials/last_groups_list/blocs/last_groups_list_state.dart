part of 'last_groups_list_bloc.dart';

enum LastGroupsListStatus {
  initial,
  loading,
  success,
  error,
}

class LastGroupsListState {
  final LastGroupsListStatus status;
  final String? errorMessage;
  final Paginated<Group>? groupsPage;

  LastGroupsListState({
    this.status = LastGroupsListStatus.initial,
    this.errorMessage,
    this.groupsPage,
  });

  LastGroupsListState copyWith({
    LastGroupsListStatus? status,
    Paginated<Group>? groupsPage,
    String? errorMessage,
  }) {
    return LastGroupsListState(
      status: status ?? this.status,
      groupsPage: groupsPage ?? this.groupsPage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
