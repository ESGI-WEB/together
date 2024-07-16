part of 'register_bloc.dart';

@immutable
sealed class RegisterState {
  final String name;
  final String email;
  final String password;

  const RegisterState({
    this.name = '',
    this.email = '',
    this.password = '',
  });
}

class RegisterInitial extends RegisterState {
  const RegisterInitial({
    super.name,
    super.email,
    super.password,
  });
}

class RegisterLoading extends RegisterState {
  const RegisterLoading({
    required super.name,
    required super.email,
    required super.password,
  });
}

class RegisterCheckingAvailability extends RegisterState {
  const RegisterCheckingAvailability({
    required super.name,
    required super.email,
    required super.password,
  });
}

class RegisterSuccess extends RegisterState {
  final User user;

  const RegisterSuccess({required this.user});
}

class RegisterError extends RegisterState {
  final String errorMessage;

  const RegisterError({
    required this.errorMessage,
    required super.name,
    required super.email,
    required super.password,
  });
}

class RegisterFeatureDisabled extends RegisterState {
  const RegisterFeatureDisabled({
    required super.name,
    required super.email,
    required super.password,
  });
}
