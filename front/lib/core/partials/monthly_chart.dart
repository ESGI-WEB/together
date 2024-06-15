import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:front/core/models/monthly_chart_data.dart';
import 'package:front/local.dart';
import 'package:intl/intl.dart';

class MonthlyChart extends StatelessWidget {
  final List<MonthlyChartData> chartData;

  const MonthlyChart({
    super.key,
    required this.chartData,
  });

  List<MonthlyChartData> getPreparedData(BuildContext context) {
    List<MonthlyChartData> preparedData = [];
    DateTime now = DateTime.now();
    DateTime start = DateTime(now.year - 1, now.month);

    Map<String, int> dataMap = {
      for (var data in chartData) '${data.year}-${data.month}': data.count
    };

    for (int i = 0; i <= 12; i++) {
      // nice feature, if we have DateTime(2024, 13) it will automatically convert it to DateTime(2025, 1)
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
    List<MonthlyChartData> preparedData = getPreparedData(context);

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (spot) => Theme.of(context).colorScheme.surface,
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
                return SideTitleWidget(
                  axisSide: AxisSide.bottom,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      DateFormat('MM/yy', LocaleLanguage.of(context)?.locale)
                          .format(
                        DateTime(preparedData[value.toInt()].year,
                            preparedData[value.toInt()].month),
                      ),
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
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
