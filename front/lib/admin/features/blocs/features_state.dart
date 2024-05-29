part of 'features_bloc.dart';

@immutable
sealed class FeaturesState {}

final class FeaturesInitial extends FeaturesState {}

final class FeaturesLoading extends FeaturesState {}

final class FeaturesDataLoadSuccess extends FeaturesState {
  final List<Feature> features;

  FeaturesDataLoadSuccess({required this.features});
}

final class FeaturesDataLoadError extends FeaturesState {
  final String errorMessage;

  FeaturesDataLoadError({required this.errorMessage});
}