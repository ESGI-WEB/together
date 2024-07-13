import 'dart:convert';

import 'package:front/core/models/attend.dart';
import 'package:front/core/models/event.dart';
import 'package:front/core/models/filter.dart';
import 'package:front/core/models/paginated.dart';
import 'package:intl/intl.dart';

import '../exceptions/api_exception.dart';
import 'api_services.dart';

class EventsServices {
  static Future<Event> createEvent(EventCreate event) async {
    final response = await ApiServices.post('/events', event.toJson());
    return Event.fromJson(ApiServices.decodeResponse(response));
  }

  static Future<Event> getEventById(int id) async {
    final response = await ApiServices.get('/events/$id');
    return Event.fromJson(ApiServices.decodeResponse(response));
  }

  static Future<Paginated<Attend>> getEventAttends({
    required int eventId,
    bool? hasAttended,
  }) async {
    String url = '/events/$eventId/attends';
    if (hasAttended != null) {
      url += '?has_attended=${hasAttended.toString()}';
    }

    final response = await ApiServices.get(url);
    return Paginated.fromJson(
      ApiServices.decodeResponse(response),
      Attend.fromJson,
    );
  }

  static Future<Paginated<Event>> getEvents({
    int page = 1,
    String sort = 'id asc',
    List<Filter>? filters,
    int? limit,
  }) async {
    String url = '/events?page=$page&sort=$sort';

    if (limit != null) {
      url += '&limit=$limit';
    }

    if (filters != null) {
      url +=
          '&filters=${jsonEncode(filters.map((filter) => filter.toJson()).toList())}';
    }

    final response = await ApiServices.get(url);
    return Paginated.fromJson(
      ApiServices.decodeResponse(response),
      Event.fromJson,
    );
  }

  static Future<void> duplicateEventsForDate(int eventId, DateTime date) async {
    final url = '/events/$eventId/duplicate';
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    try {
      await ApiServices.post(
        url,
        {'new_date': formattedDate},
      );
    } on ApiException catch (error) {
      throw Exception(error);
    }
  }
}
