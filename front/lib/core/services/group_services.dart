import 'dart:convert';

import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/group.dart';

import 'api_services.dart';

class GroupServices {
  static Future<List<Group>> fetchGroups() async {
    final response = await ApiServices.get('/groups');
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Group.fromJson(json)).toList();
    } else {
      throw ApiException(
        message: 'Failed to load groups',
        statusCode: response.statusCode,
        response: response,
      );
    }
  }

  static Future<Group> createGroup(Map<String, dynamic> newGroup) async {
    final response = await ApiServices.post('/groups', newGroup);
    if (response.statusCode == 201) {
      return Group.fromJson(json.decode(response.body));
    } else {
      throw ApiException(
        message: 'Failed to create group',
        statusCode: response.statusCode,
        response: response,
      );
    }
  }

  static Future<void> joinGroup(Map<String, dynamic> code) async {
    final response = await ApiServices.post('/groups/join', code);
    if (response.statusCode != 200) {
      throw ApiException(
        message: 'Failed to join group',
        statusCode: response.statusCode,
        response: response,
      );
    }
  }

  static Future<Group> getGroupById(int groupId) async {
    final response = await ApiServices.get('/groups/$groupId');
    if (response.statusCode == 200) {
      return Group.fromJson(json.decode(response.body));
    } else {
      throw ApiException(
        message: 'Failed to load group',
        statusCode: response.statusCode,
        response: response,
      );
    }
  }
}
