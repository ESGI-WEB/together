import 'dart:convert';

import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/exceptions/unauthorized_exception.dart';
import 'package:front/core/models/event_type.dart';
import 'package:front/core/services/api_services.dart';

class EventTypeServices {
  static Future<List<EventType>> getEventTypes() async {
    try {
      final response = await ApiServices.get('/event-types');
      List<dynamic> data = json.decode(response.body);
      return EventType.listFromJson(data);
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
