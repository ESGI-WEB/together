part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginFormSubmitted extends LoginEvent {}

class LoginEmailChanged extends LoginEvent {
  final String email;

  LoginEmailChanged({required this.email});
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  LoginPasswordChanged({required this.password});
}
