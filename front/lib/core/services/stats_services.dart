import 'dart:convert';

import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/exceptions/conflit_exception.dart';
import 'package:front/core/exceptions/unauthorized_exception.dart';
import 'package:front/core/models/event.dart';
import 'package:front/core/models/group.dart';
import 'package:front/core/models/jwt.dart';
import 'package:front/core/models/monthly_chart_data.dart';
import 'package:front/core/models/paginated.dart';
import 'package:front/core/models/pie_chart_count.dart';
import 'package:front/core/models/user.dart';

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
