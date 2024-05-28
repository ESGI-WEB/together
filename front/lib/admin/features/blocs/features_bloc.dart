import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/models/feature.dart';
import 'package:front/core/services/feature_flipping_services.dart';
import '../../../core/exceptions/api_exception.dart';

part 'features_event.dart';
part 'features_state.dart';

class FeaturesBloc extends Bloc<FeaturesEvent, FeaturesState> {
  FeaturesBloc() : super(FeaturesInitial()) {
    on<FeaturesLoaded>((event, emit) async {
      emit(FeaturesLoading());

      try {
        emit(FeaturesDataLoadSuccess(features: await FeatureFlippingServices.getFeatureFlippings()));
      } on ApiException {
        emit(FeaturesDataLoadError(errorMessage: 'An error occurred while retrieving data.'));
      }
    });
  }
}