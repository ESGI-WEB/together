import 'dart:convert';

import 'package:front/core/exceptions/api_exception.dart';
import 'package:front/core/models/event.dart';
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
        message: 'Échec du chargement des groupes.',
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
        message: 'Échec de création du groupe.',
        statusCode: response.statusCode,
        response: response,
      );
    }
  }

  static Future<Group> joinGroup(Map<String, dynamic> code) async {
    final response = await ApiServices.post('/groups/join', code);
    if (response.statusCode == 201) {
      return Group.fromJson(json.decode(response.body));
    } else {
      throw ApiException(
        message: 'Échec lors de la tentative de rejoindre le groupe.',
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
        message: 'Échec du chargement du groupe.',
        statusCode: response.statusCode,
        response: response,
      );
    }
  }

  static Future<Event> getGroupNextEvent(int groupId) async {
    final response = await ApiServices.get('/groups/$groupId/next-event');
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      return Event.fromJson(json.decode(response.body));
    } else {
      throw ApiException(
        message: "Échec du chargement de l'événement suivant.",
        statusCode: response.statusCode,
        response: response,
      );
    }
  }
}
