import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/admin/dashboard/partials/event_types_count/blocs/event_types_count_bloc.dart';
import 'package:front/core/models/pie_chart_count.dart';
import 'package:front/core/partials/pie_chart.dart';

class EventTypesCountChart extends StatelessWidget {
  const EventTypesCountChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Répartition des types d'évènements",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 24),
        BlocProvider(
          create: (context) => EventTypesCountBloc()..add(EventTypesCountLoaded()),
          child: BlocBuilder<EventTypesCountBloc, EventTypesCountState>(
            builder: (BuildContext context, EventTypesCountState state) {
              if (state.status == EventTypesCountStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == EventTypesCountStatus.error) {
                return Center(
                  child: Text(
                    state.errorMessage ??
                        'Une erreur est survenue lors du chargement des données.',
                  ),
                );
              }

              final List<PieChartCount>? stats = state.stats;
              if (stats == null || stats.isEmpty) {
                return const Center(
                  child: Text(
                    'Aucun évènement créé.',
                  ),
                );
              }

              return Container(
                constraints: const BoxConstraints(
                  maxHeight: 350,
                ),
                child: PieChartByName(
                  data: stats,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
