import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/exceptions/unauthorized_exception.dart';
import 'package:front/core/models/event.dart';
import 'package:front/core/models/group.dart';

import 'api_services.dart';

class GroupServices {
  static Future<List<Group>> fetchGroups(int page, int limit) async {
    try {
      final response = await ApiServices.get('/groups?page=$page&limit=$limit');
      List<dynamic> jsonData = ApiServices.decodeResponse(response)['rows'];
      return jsonData.map((json) => Group.fromJson(json)).toList();
    } on ApiException catch (e) {
      throw ApiException(
        message: e.message,
        statusCode: e.statusCode,
        response: e.response,
      );
    }
  }

  static Future<Group> createGroup(Map<String, dynamic> newGroup) async {
    try {
      final response = await ApiServices.post('/groups', newGroup);
      return Group.fromJson(ApiServices.decodeResponse(response));
    } on ApiException catch (e) {
      throw ApiException(
        message: e.message,
        statusCode: e.statusCode,
        response: e.response,
      );
    }
  }

  static Future<Group> joinGroup(Map<String, dynamic> code) async {
    try {
      final response = await ApiServices.post('/groups/join', code);
      return Group.fromJson(ApiServices.decodeResponse(response));
    } on ApiException catch (e) {
      throw ApiException(
        message: e.message,
        statusCode: e.statusCode,
        response: e.response,
      );
    }
  }

  static Future<Group> getGroupById(int groupId) async {
    try {
      final response = await ApiServices.get('/groups/$groupId');
      return Group.fromJson(ApiServices.decodeResponse(response));
    } on ApiException catch (e) {
      throw ApiException(
        message: e.message,
        statusCode: e.statusCode,
        response: e.response,
      );
    }
  }

  static Future<Event?> getGroupNextEvent(int groupId) async {
    try {
      final response = await ApiServices.get('/groups/$groupId/next-event');
      return Event.fromJson(ApiServices.decodeResponse(response));
    } on ApiException catch (e) {
      throw ApiException(
        message: e.message,
        statusCode: e.statusCode,
        response: e.response,
      );
    }
  }
}
