part of 'features_tile_bloc.dart';

@immutable
sealed class FeaturesTileEvent {}

class FeaturesTileChanged extends FeaturesTileEvent {
  final Feature feature;

  FeaturesTileChanged({required this.feature});
}
