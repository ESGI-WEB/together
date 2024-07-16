part of 'login_bloc.dart';

@immutable
sealed class LoginState {
  final String email;
  final String password;

  const LoginState({this.email = '', this.password = ''});
}

final class LoginInitial extends LoginState {
  const LoginInitial({super.email, super.password});
}

final class LoginLoading extends LoginState {
  const LoginLoading({super.email, super.password});
}

final class LoginSuccess extends LoginState {}

final class LoginError extends LoginState {
  final String errorMessage;

  const LoginError({required this.errorMessage, super.email, super.password});
}
