import 'package:flutter/material.dart';
import 'package:front/core/services/api_services.dart';

class EventType {
  final int id;
  final String name;
  final String description;
  final NetworkImage image;

  EventType({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  factory EventType.fromJson(Map<String, dynamic> json) {
    return EventType(
      id: json['ID'],
      name: json['name'],
      description: json['description'],
      image: NetworkImage("${ApiServices.baseUrl}/${json['image_path']}"),
    );
  }

  static List<EventType> listFromJson(List<dynamic> json) {
    return json.map((e) => EventType.fromJson(e)).toList();
  }
}
