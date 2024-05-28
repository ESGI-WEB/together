import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/admin/features/blocs/features_bloc.dart';
import 'package:front/core/extensions/string.dart';
import 'package:front/core/partials/features_tile/features_tile.dart';
import '../../core/partials/admin-layout.dart';

class FeaturesScreen extends StatelessWidget {
  static const String routeName = '/features';

  static Future<void> navigateTo(BuildContext context,
      {bool removeHistory = false}) {
    return Navigator.of(context)
        .pushNamedAndRemoveUntil(routeName, (route) => !removeHistory);
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
          }
        ),
      )
    );
  }
}
