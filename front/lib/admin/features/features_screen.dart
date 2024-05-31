import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/admin/features/blocs/features_bloc.dart';
import 'package:front/core/partials/admin_layout.dart';
import 'package:front/core/partials/features_tile/features_tile.dart';
import 'package:go_router/go_router.dart';

class FeaturesScreen extends StatelessWidget {
  static const String routeName = '/features';

  static void navigateTo(BuildContext context) {
    context.goNamed(routeName);
  }

  const FeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
        title: 'Fonctionnalités',
        body: BlocProvider(
          create: (context) => FeaturesBloc()..add(FeaturesLoaded()),
          child: BlocBuilder<FeaturesBloc, FeaturesState>(
              builder: (context, state) {
            if (state is FeaturesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is FeaturesDataLoadError) {
              return Center(
                child: Text(state.errorMessage),
              );
            }

            if (state is FeaturesDataLoadSuccess) {
              return ListView.builder(
                itemCount: state.features.length,
                itemBuilder: (context, index) {
                  final feature = state.features[index];
                  return FeaturesTile(feature: feature);
                },
              );
            }

            return const SizedBox();
          }),
        ));
  }
}
