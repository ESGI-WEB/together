import 'dart:convert';

import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/exceptions/unauthorized_exception.dart';
import 'package:front/core/models/event.dart';

import 'api_services.dart';

class EventsServices {
  static Future<Event> createEvent(EventCreate event) async {
    try {
      final response = await ApiServices.post('/events', event.toJson());

      return Event.fromJson(json.decode(response.body));
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
      return Event.fromJson(json.decode(response.body));
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
