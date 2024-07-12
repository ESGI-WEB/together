import 'package:front/core/models/monthly_chart_data.dart';
import 'package:front/core/models/pie_chart_count.dart';

import 'api_services.dart';

class StatsServices {
  static Future<List<MonthlyChartData>> getLastYearRegistrationsCount() async {
    final response = await ApiServices.get(
        '/admin/stats/monthly-last-year-registration-count');
    final decodedList = ApiServices.decodeResponse(response) as List<dynamic>?;

    return decodedList == null
        ? []
        : decodedList
            .map<MonthlyChartData>((json) => MonthlyChartData.fromJson(json))
            .toList();
  }

  static Future<List<MonthlyChartData>> getMonthlyMessagesCount() async {
    final response =
        await ApiServices.get('/admin/stats/monthly-messages-count');
    final decodedList = ApiServices.decodeResponse(response) as List<dynamic>?;

    return decodedList == null
        ? []
        : decodedList
            .map<MonthlyChartData>((json) => MonthlyChartData.fromJson(json))
            .toList();
  }

  static Future<List<PieChartCount>> getEventTypesCount() async {
    final response = await ApiServices.get('/admin/stats/event-types-count');
    final decodedList = ApiServices.decodeResponse(response) as List<dynamic>?;

    return decodedList == null
        ? []
        : decodedList
            .map<PieChartCount>((json) => PieChartCount.fromJson(json))
            .toList();
  }
}
