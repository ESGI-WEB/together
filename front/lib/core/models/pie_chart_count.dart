class PieChartCount {
  final String name;
  final double count;

  PieChartCount({
    required this.name,
    required this.count,
  });

  factory PieChartCount.fromJson(Map<String, dynamic> json) {
    return PieChartCount(
      name: json['name'],
      count: json['count'],
    );
  }
}
