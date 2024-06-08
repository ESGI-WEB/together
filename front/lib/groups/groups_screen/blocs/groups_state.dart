part of 'groups_bloc.dart';

enum GroupsStatus {
  initial,
  loading,
  loadingMore,
  success,
  error,
}

class GroupsState {
  final GroupsStatus status;
  final List<Group>? groups;
  final String? errorMessage;
  final int page;
  final int limit;
  final int? total;
  final int? pages;
  final bool hasReachedMax;

  GroupsState({
    this.status = GroupsStatus.initial,
    this.groups,
    this.errorMessage,
    this.page = 1,
    this.limit = 5,
    this.total,
    this.pages,
    this.hasReachedMax = false,
  });

  GroupsState copyWith({
    GroupsStatus? status,
    List<Group>? groups,
    String? errorMessage,
    int? page,
    int? limit,
    int? total,
    int? pages,
    bool? hasReachedMax,
  }) {
    return GroupsState(
      status: status ?? this.status,
      groups: groups ?? this.groups,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      total: total ?? this.total,
      pages: pages ?? this.pages,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}