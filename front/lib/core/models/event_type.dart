import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:front/core/services/api_services.dart';
import 'package:http/http.dart' as http;

class EventType {
  final int id;
  final String name;
  final String description;
  final NetworkImage image;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventType({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventType.fromJson(Map<String, dynamic> json) {
    return EventType(
      id: json['ID'],
      name: json['name'],
      description: json['description'],
      createdAt: DateTime.parse(json['CreatedAt']),
      updatedAt: DateTime.parse(json['UpdatedAt']),
      image: NetworkImage("${ApiServices.baseUrl}/${json['image_path']}?${json['UpdatedAt']}"),
    );
  }

  static List<EventType> listFromJson(List<dynamic> json) {
    return json.map((e) => EventType.fromJson(e)).toList();
  }
}

class EventTypeCreateOrEdit {
  final int? id;
  final String? name;
  final String? description;
  final PlatformFile? image;

  EventTypeCreateOrEdit({
    this.id,
    this.name,
    this.description,
    this.image,
  });

  Map<String, dynamic> toJson() {
    final PlatformFile? image = this.image;

    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image == null ? null : http.MultipartFile(
        'image',
        image.xFile.readAsBytes().asStream(),
        image.size,
        filename: image.name,
      ),
    };
  }

  copyWith({
    int? id,
    String? name,
    String? description,
    PlatformFile? image,
  }) {
    return EventTypeCreateOrEdit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }
}
