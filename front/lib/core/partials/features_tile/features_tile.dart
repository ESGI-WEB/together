import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/extensions/string.dart';
import 'package:front/core/models/feature.dart';
import 'package:front/core/partials/features_tile/blocs/features_tile_bloc.dart';

class FeaturesTile extends StatefulWidget {
  final Feature feature;

  const FeaturesTile({super.key, required this.feature});

  @override
  State<FeaturesTile> createState() => _FeaturesTileState();
}

class _FeaturesTileState extends State<FeaturesTile> {
  late Feature feature;

  @override
  void initState() {
    super.initState();
    feature = widget.feature;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeaturesTileBloc(),
      child: BlocListener<FeaturesTileBloc, FeaturesTileState>(
        listener: (BuildContext context, FeaturesTileState state) {
          if (state is FeaturesTileSuccess) {
            setState(() {
              feature = state.feature;
            });
          }
        },
        child: BlocBuilder<FeaturesTileBloc, FeaturesTileState>(
          builder: (BuildContext context, FeaturesTileState state) {
            return ListTile(
              title: Text(feature.slug.capitalize()),
              trailing: Switch(
                value: feature.enabled,
                onChanged: state is FeaturesTileLoading ? null : (bool value) {
                  BlocProvider.of<FeaturesTileBloc>(context).add(
                      FeaturesTileChanged(
                          feature: feature.copyWith(enabled: value)));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
