part of 'features_tile_bloc.dart';

@immutable
sealed class FeaturesTileState {}

final class FeaturesTileInitial extends FeaturesTileState {}

final class FeaturesTileLoading extends FeaturesTileState {}

final class FeaturesTileSuccess extends FeaturesTileState {
  final Feature feature;

  FeaturesTileSuccess({required this.feature});
}

final class FeaturesTileDataLoadError extends FeaturesTileState {
  final String errorMessage;

  FeaturesTileDataLoadError({required this.errorMessage});
}