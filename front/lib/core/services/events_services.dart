import 'dart:convert';

import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/exceptions/unauthorized_exception.dart';
import 'package:front/core/models/attend.dart';
import 'package:front/core/models/event.dart';
import 'package:front/core/models/paginated.dart';

import 'api_services.dart';

class EventsServices {
  static Future<Event> createEvent(EventCreate event) async {
    try {
      final response = await ApiServices.post('/events', event.toJson());

      return Event.fromJson(ApiServices.decodeResponse(response));
    } catch (e) {
      if (e is UnauthorizedException) {
        throw UnauthorizedException(message: "Vous n'êtes pas connecté");
      } else if (e is ApiException) {
        rethrow;
      } else {
        rethrow;
      }
    }
  }

  static Future<Event> getEventById(int id) async {
    try {
      final response = await ApiServices.get('/events/$id');
      return Event.fromJson(ApiServices.decodeResponse(response));
    } catch (e) {
      if (e is UnauthorizedException) {
        throw UnauthorizedException(message: "Vous n'êtes pas connecté");
      } else if (e is ApiException) {
        rethrow;
      } else {
        rethrow;
      }
    }
  }

  static Future<Paginated<Attend>> getEventAttends({
    required int eventId,
    bool? hasAttended,
  }) async {
    try {
      String url = '/events/$eventId/attends';
      if (hasAttended != null) {
        url += '?has_attended=${hasAttended.toString()}';
      }

      final response = await ApiServices.get(url);
      return Paginated.fromJson(ApiServices.decodeResponse(response), Attend.fromJson);
    } catch (e) {
      if (e is UnauthorizedException) {
        throw UnauthorizedException(message: "Vous n'êtes pas connecté");
      } else if (e is ApiException) {
        rethrow;
      } else {
        rethrow;
      }
    }
  }
}
