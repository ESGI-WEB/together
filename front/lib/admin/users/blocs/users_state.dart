part of 'users_bloc.dart';

enum UsersStatus {
  initial,
  tableLoading,
  tableSuccess,
  tableError,
  formLoading,
  formSuccess,
  formError,
}

class UsersState {
  final UsersStatus status;
  final List<User> users;
  final int? pages;
  final int? lastPage;
  final String? search;
  final String? errorMessage;
  final String? formErrorMessage;

  UsersState({
    this.status = UsersStatus.initial,
    this.users = const [],
    this.pages,
    this.lastPage,
    this.search,
    this.errorMessage,
    this.formErrorMessage,
  });

  UsersState copyWith({
    UsersStatus? status,
    List<User>? users,
    int? pages,
    int? lastPage,
    String? search,
    String? errorMessage,
    String? formErrorMessage,
  }) {
    return UsersState(
      status: status ?? this.status,
      users: users ?? this.users,
      pages: pages ?? this.pages,
      lastPage: lastPage ?? this.lastPage,
      search: search ?? this.search,
      errorMessage: errorMessage ?? this.errorMessage,
      formErrorMessage: formErrorMessage ?? this.formErrorMessage,
    );
  }
}
