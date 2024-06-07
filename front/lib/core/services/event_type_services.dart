import 'dart:convert';

import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/exceptions/unauthorized_exception.dart';
import 'package:front/core/models/event_type.dart';
import 'package:front/core/services/api_services.dart';

class EventTypeServices {
  static Future<List<EventType>> getEventTypes() async {
    try {
      final response = await ApiServices.get('/event-types');
      List<dynamic> data = ApiServices.decodeResponse(response);
      return EventType.listFromJson(data);
    } catch (e) {
      if (e is UnauthorizedException) {
        throw UnauthorizedException(message: "Vous n'êtes pas connecté");
      } else {
        rethrow;
      }
    }
  }

  static Future<EventType> addEventType(EventTypeCreateOrEdit type) async {
    final response = await ApiServices.multipartRequest('POST', '/event-types', type.toJson());
    return EventType.fromJson(ApiServices.decodeResponse(response));
  }

  static Future<EventType> editEventType(int id, EventTypeCreateOrEdit type) async {
    final response = await ApiServices.multipartRequest('PUT', '/event-types/$id', type.toJson());
    return EventType.fromJson(ApiServices.decodeResponse(response));
  }

  static Future<void> deleteEventType(int id) async {
    await ApiServices.delete('/event-types/$id');
  }
}
