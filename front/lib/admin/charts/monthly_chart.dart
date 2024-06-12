import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:front/core/models/monthly_chart_data.dart';
import 'package:front/local.dart';
import 'package:intl/intl.dart';

class MonthlyChart extends StatelessWidget {
  final List<MonthlyChartData> chartData = [
    MonthlyChartData(month: 5, year: 2023, count: 21),
    MonthlyChartData(month: 9, year: 2023, count: 10),
    MonthlyChartData(month: 1, year: 2024, count: 33),
    MonthlyChartData(month: 4, year: 2024, count: 10),
    MonthlyChartData(month: 6, year: 2024, count: 1),
  ];

  MonthlyChart({super.key});

  List<MonthlyChartData> getPreparedData() {
    List<MonthlyChartData> preparedData = [];
    DateTime now = DateTime.now();
    DateTime start = DateTime(now.year - 1, now.month);

    Map<String, int> dataMap = {
      for (var data in chartData) '${data.year}-${data.month}': data.count
    };

    for (int i = 0; i < 12; i++) {
      DateTime date = DateTime(start.year, start.month + i);
      String key = '${date.year}-${date.month}';
      preparedData.add(MonthlyChartData(
        month: date.month,
        year: date.year,
        count: dataMap[key] ?? 0,
      ));
    }

    return preparedData;
  }

  @override
  Widget build(BuildContext context) {
    List<MonthlyChartData> preparedData = getPreparedData();

    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Registrations')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (spot) =>
                    Theme.of(context).colorScheme.surface,
              ),
            ),
            gridData: const FlGridData(
              verticalInterval: 1,
            ),
            titlesData: FlTitlesData(
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 40,
                  getTitlesWidget: (value, title) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        DateFormat.yMMM(LocaleLanguage.of(context)?.locale)
                            .format(
                          DateTime(preparedData[value.toInt()].year,
                              preparedData[value.toInt()].month),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: preparedData
                    .asMap()
                    .entries
                    .map((entry) => FlSpot(
                          entry.key.toDouble(),
                          entry.value.count.toDouble(),
                        ))
                    .toList(),
                isCurved: true,
                color: Theme.of(context).primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
