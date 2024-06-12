part of 'users_bloc.dart';

@immutable
sealed class UsersEvent {}

class UsersDataTableLoaded extends UsersEvent {
  final int page;
  final String? search;

  UsersDataTableLoaded({
    this.page = 1,
    this.search,
  });
}

class UserCreatedOrEdited extends UsersEvent {
  final UserCreateOrEdit user;
  final int? id;

  UserCreatedOrEdited({
    required this.user,
    this.id,
  });
}
