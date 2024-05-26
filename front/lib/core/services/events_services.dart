import 'dart:convert';

import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/exceptions/unauthorized_exception.dart';
import 'package:front/core/models/event.dart';

import 'api_services.dart';

class EventsServices {
  static Future<Event> createEvent(
    String name,
    String description,
    String date,
    String time,
    int typeId,
    String street,
    String number,
    String city,
    String zip,
  ) async {
    try {
      final response = await ApiServices.post('/events', {
        "name": name,
        "description": description,
        "date": date,
        "time": time,
        "type_id": typeId,
        "address": {
          "street": street,
          "number": number,
          "city": city,
          "zip": zip
        },
      });

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
