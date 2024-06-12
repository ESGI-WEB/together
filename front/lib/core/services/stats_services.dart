import 'dart:convert';

import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/exceptions/conflit_exception.dart';
import 'package:front/core/exceptions/unauthorized_exception.dart';
import 'package:front/core/models/jwt.dart';
import 'package:front/core/models/monthly_chart_data.dart';
import 'package:front/core/models/paginated.dart';
import 'package:front/core/models/user.dart';

import 'api_services.dart';

class StatsServices {

  Future<MonthlyChartData> getLastYearRegistrationsCount() async {
    final response = await ApiServices.get('/stats/last-year-registrations-count');

    return MonthlyChartData.fromJson(ApiServices.decodeResponse(response));
  }
}
