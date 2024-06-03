import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/exceptions/feature_disabled_exception.dart';
import 'package:front/core/models/feature.dart';
import 'package:front/core/models/user.dart';
import 'package:front/core/services/feature_flipping_services.dart';
import 'package:front/core/services/user_services.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(const RegisterInitial()) {
    on<RegisterFormChanged>((event, emit) {
      emit(RegisterInitial(
        name: event.name,
        email: event.email,
        password: event.password,
      ));
    });

    on<RegisterAvailabilityChecked>((event, emit) async {
      try {
        var registerFeature = await FeatureFlippingServices.getFeatureFlipping(
            FeatureEnum.register.name);

        if (!registerFeature.enabled) {
          emit(RegisterFeatureDisabled(
            email: state.email,
            password: state.password,
            name: state.name,
          ));
        }
      } catch (error) {
        emit(RegisterError(
          errorMessage:
              error is ApiException ? error.message : 'Une erreur est survenue',
          email: state.email,
          password: state.password,
          name: state.name,
        ));
      }
    });

    on<RegisterFormSubmitted>((event, emit) async {
      emit(RegisterLoading(
        email: state.email,
        password: state.password,
        name: state.name,
      ));

      try {
        final user = await UserServices.register(
            state.name, state.email, state.password);
        emit(RegisterSuccess(user: user));
      } on FeatureDisabledException {
        emit(RegisterFeatureDisabled(
          email: state.email,
          password: state.password,
          name: state.name,
        ));
      } catch (error) {
        emit(RegisterError(
          errorMessage:
              error is ApiException ? error.message : 'Une erreur est survenue',
          email: state.email,
          password: state.password,
          name: state.name,
        ));
      }
    });
  }
}
