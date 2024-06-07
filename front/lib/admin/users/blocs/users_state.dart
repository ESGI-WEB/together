part of 'users_bloc.dart';

enum UsersStatus {
  initial,
  tableLoading,
  tableSuccess,
  tableError,
}

class UsersState {
  final UsersStatus status;
  final List<User> users;
  final int? pages;
  final int? lastPage;
  final String? errorMessage;

  UsersState({
    this.status = UsersStatus.initial,
    this.users = const [],
    this.pages,
    this.lastPage,
    this.errorMessage,
  });

  UsersState copyWith({
    UsersStatus? status,
    List<User>? users,
    int? pages,
    int? lastPage,
    String? errorMessage,
  }) {
    return UsersState(
      status: status ?? this.status,
      users: users ?? this.users,
      pages: pages ?? this.pages,
      lastPage: lastPage ?? this.lastPage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
