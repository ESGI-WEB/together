import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/message.dart';
import 'package:front/core/models/paginated.dart';

import 'api_services.dart';

class MessageServices {
  static Future<Paginated<Message>> fetchPublicationsByGroup(int groupId, int page, int limit, {String sort = "created_at desc"}) async {
    try {
      final response = await ApiServices.get('/messages/group/$groupId?page=$page&limit=$limit&sort=$sort');
      final jsonData = ApiServices.decodeResponse(response);
      return Paginated.fromJson(jsonData, (json) => Message.fromJson(json));
    } on ApiException catch (e) {
      throw ApiException(
        message: e.message,
        statusCode: e.statusCode,
        response: e.response,
      );
    }
  }

  static Future<Paginated<Message>> fetchPublicationsByEventAndGroup(int groupId, int eventId, int page, int limit, {String sort = "created_at desc"}) async {
    try {
      final response = await ApiServices.get('/messages/group/$groupId/event/$eventId?page=$page&limit=$limit&sort=$sort');
      final jsonData = ApiServices.decodeResponse(response);
      return Paginated.fromJson(jsonData, (json) => Message.fromJson(json));
    } on ApiException catch (e) {
      throw ApiException(
        message: e.message,
        statusCode: e.statusCode,
        response: e.response,
      );
    }
  }

  static Future<Message> createPublication(Map<String, dynamic> newMessage) async {
    try {
      final response = await ApiServices.post('/messages/publication', newMessage);
      return Message.fromJson(ApiServices.decodeResponse(response));
    } on ApiException catch (e) {
      throw ApiException(
        message: e.message,
        statusCode: e.statusCode,
        response: e.response,
      );
    }
  }

  static Future<Message> updateMessage(int id, Map<String, dynamic> updatedMessage) async {
    try {
      final response = await ApiServices.patch('/messages/$id', updatedMessage);
      return Message.fromJson(ApiServices.decodeResponse(response));
    } on ApiException catch (e) {
      throw ApiException(
        message: e.message,
        statusCode: e.statusCode,
        response: e.response,
      );
    }
  }

  static Future<void> deleteMessage(int id) async {
    try {
      await ApiServices.delete('/messages/$id');
    } on ApiException catch (e) {
      throw ApiException(
        message: e.message,
        statusCode: e.statusCode,
        response: e.response,
      );
    }
  }

  static Future<Message> pinMessage(int id, Map<String, dynamic> pinStatus) async {
    try {
      final response = await ApiServices.post('/messages/$id/pin', pinStatus);
      return Message.fromJson(ApiServices.decodeResponse(response));
    } on ApiException catch (e) {
      throw ApiException(
        message: e.message,
        statusCode: e.statusCode,
        response: e.response,
      );
    }
  }
}