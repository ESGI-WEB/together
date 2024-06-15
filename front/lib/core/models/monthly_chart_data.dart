class MonthlyChartData {
  final int month;
  final int year;
  final int count;

  MonthlyChartData({
    required this.month,
    required this.year,
    required this.count,
  });

  factory MonthlyChartData.fromJson(Map<String, dynamic> json) {
    return MonthlyChartData(
      month: json['month'],
      year: json['year'],
      count: json['count'],
    );
  }
}
