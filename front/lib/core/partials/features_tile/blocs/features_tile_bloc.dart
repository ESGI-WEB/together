import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/feature.dart';
import 'package:front/core/services/feature_flipping_services.dart';

part 'features_tile_event.dart';

part 'features_tile_state.dart';

class FeaturesTileBloc extends Bloc<FeaturesTileEvent, FeaturesTileState> {
  FeaturesTileBloc() : super(FeaturesTileInitial()) {
    on<FeaturesTileChanged>((event, emit) async {
      emit(FeaturesTileLoading());

      try {
        emit(
          FeaturesTileSuccess(
            feature: await FeatureFlippingServices.updateFeatureFlipping(
              event.feature,
            ),
          ),
        );
      } on ApiException catch (e) {
        emit(
          FeaturesTileDataLoadError(
            errorMessage: e.message,
          ),
        );
      }
    });
  }
}
