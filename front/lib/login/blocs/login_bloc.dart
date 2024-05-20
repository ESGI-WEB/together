import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/exceptions/unauthorized_exception.dart';
import 'package:front/core/models/jwt.dart';
import 'package:front/core/services/login_services.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginInitial()) {
    on<LoginViewed>((event, emit) {
      emit(const LoginInitial());
    });

    on<LoginEmailChanged>((event, emit) {
      emit(LoginInitial(email: event.email, password: state.password));
    });

    on<LoginPasswordChanged>((event, emit) {
      emit(LoginInitial(email: state.email, password: event.password));
    });

    on<LoginFormSubmitted>((event, emit) async {
      emit(LoginLoading(email: state.email, password: state.password));

      try {
        final token = await LoginServices.login(state.email, state.password);
        emit(LoginSuccess(jwt: token));
      } on UnauthorizedException catch (error) {
        emit(LoginError(errorMessage: error.message));
      } on ApiException {
        emit(const LoginError(errorMessage: "Une erreur s'est produite"));
      }
    });
  }
}