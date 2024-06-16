import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:front/core/models/pie_chart_count.dart';
import 'package:front/core/services/color_services.dart';

class PieChartByName extends StatelessWidget {
  final List<PieChartCount> data;

  const PieChartByName({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PieChart(
        PieChartData(
          sections: _buildPieChartSections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final List<Color> colors = _generateColors(data.length);
    return data.asMap().entries.map((entry) {
      final int index = entry.key;
      final PieChartCount data = entry.value;
      return PieChartSectionData(
        color: colors[index],
        value: data.count,
        radius: 80,
        badgeWidget: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: colors[index],
            borderRadius: BorderRadius.circular(4),
          ),
          constraints: const BoxConstraints(
            maxWidth: 150,
          ),
          child: Text(
            data.name,
            style: TextStyle(
              fontSize: 14,
              color: ColorServices.getContrastingTextColor(colors[index]),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }).toList();
  }

  // those methods generate random colors that are distinct from each other to be displayed in the pie chart
  List<Color> _generateColors(int count) {
    final Random random = Random();
    final List<Color> colors = [];
    while (colors.length < count) {
      final Color newColor = Color.fromRGBO(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        1,
      );
      if (ColorServices.isDistinct(newColor, colors)) {
        colors.add(newColor);
      }
    }
    return colors;
  }
}
