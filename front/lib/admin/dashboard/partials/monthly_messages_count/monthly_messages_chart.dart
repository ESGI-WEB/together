import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/admin/dashboard/partials/monthly_messages_count/blocs/monthly_messages_bloc.dart';
import 'package:front/core/models/monthly_chart_data.dart';
import 'package:front/core/partials/monthly_chart.dart';

class MonthlyMessagesChart extends StatelessWidget {
  const MonthlyMessagesChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Messages envoyés ces 365 derniers jours',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 24),
        BlocProvider(
          create: (context) => MonthlyMessagesBloc()..add(MonthlyMessagesLoaded()),
          child: BlocBuilder<MonthlyMessagesBloc, MonthlyMessagesState>(
            builder: (BuildContext context, MonthlyMessagesState state) {
              if (state.status == MonthlyMessagesStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == MonthlyMessagesStatus.error) {
                return Center(
                  child: Text(
                    state.errorMessage ??
                        'Une erreur est survenue lors du chargement des données.',
                  ),
                );
              }

              final List<MonthlyChartData>? stats = state.stats;
              if (stats == null || stats.isEmpty) {
                return const Center(
                  child: Text(
                    'Aucun message envoyé ces 365 derniers jours.',
                  ),
                );
              }

              return Container(
                constraints: const BoxConstraints(
                  maxHeight: 350,
                ),
                child: MonthlyChart(
                  chartData: stats,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
