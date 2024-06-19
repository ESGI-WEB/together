import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/admin/dashboard/partials/monthly_last_year_registration/blocs/monthly_last_year_registration_bloc.dart';
import 'package:front/core/models/monthly_chart_data.dart';
import 'package:front/core/partials/monthly_chart.dart';

class MonthlyLastYearRegistrationChart extends StatelessWidget {
  const MonthlyLastYearRegistrationChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Inscriptions des 365 derniers jours',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 24),
        BlocProvider(
          create: (context) => MonthlyLastYearRegistrationBloc()
            ..add(MonthlyLastYearRegistrationLoaded()),
          child: BlocBuilder<MonthlyLastYearRegistrationBloc,
              MonthlyLastYearRegistrationState>(
            builder:
                (BuildContext context, MonthlyLastYearRegistrationState state) {
              if (state.status == MonthlyLastYearRegistrationStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == MonthlyLastYearRegistrationStatus.error) {
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
                    'Aucune inscription effectuée ces 365 derniers jours.',
                  ),
                );
              }

              return Container(
                constraints: const BoxConstraints(
                  maxHeight: 400,
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
