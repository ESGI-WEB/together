part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

class RegisterFormSubmitted extends RegisterEvent {}

class RegisterAvailabilityChecked extends RegisterEvent {}

class RegisterFormChanged extends RegisterEvent {
  final String name;
  final String email;
  final String password;

  RegisterFormChanged(
      {required this.name, required this.email, required this.password});
}
