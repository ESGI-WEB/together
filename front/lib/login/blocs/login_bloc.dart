import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/exceptions/unauthorized_exception.dart';
import 'package:front/core/services/storage_service.dart';
import 'package:front/core/services/user_services.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginInitial()) {
    on<LoginEmailChanged>((event, emit) {
      emit(LoginInitial(email: event.email, password: state.password));
    });

    on<LoginPasswordChanged>((event, emit) {
      emit(LoginInitial(email: state.email, password: event.password));
    });

    on<LoginFormSubmitted>((event, emit) async {
      emit(LoginLoading(email: state.email, password: state.password));

      try {
        final jwt = await UserServices.login(state.email, state.password);
        await StorageService.writeToken(jwt.token);
        emit(LoginSuccess());
      } on UnauthorizedException catch (error) {
        emit(LoginError(
            errorMessage: error.message,
            email: state.email,
            password: state.password));
      } on ApiException {
        emit(LoginError(
            errorMessage: 'An error occurred',
            email: state.email,
            password: state.password));
      }
    });
  }
}
