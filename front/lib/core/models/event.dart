import "package:front/core/models/event_type.dart";
import "package:front/core/models/user.dart";

import "address.dart";

enum RecurrenceType {
  eachDays,
  eachWeeks,
  eachMonths,
  eachYears,
}

class Event {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String name;
  final String description;
  final DateTime date;
  final String? time;
  final int typeId;
  final EventType? type;
  final int organizerId;
  final int addressId;
  final Address? address;
  final User? organizer;
  final int groupId;
  final RecurrenceType? recurrenceType;

  Event({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.name,
    required this.description,
    required this.date,
    this.time,
    required this.typeId,
    this.type,
    required this.organizerId,
    required this.addressId,
    this.address,
    this.organizer,
    required this.groupId,
    this.recurrenceType,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['ID'],
      createdAt: DateTime.parse(json['CreatedAt']),
      updatedAt: DateTime.parse(json['UpdatedAt']),
      deletedAt:
          json['DeletedAt'] != null ? DateTime.parse(json['deleted_at']) : null,
      name: json['name'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      typeId: json['type_id'],
      organizerId: json['organizer_id'],
      addressId: json['address_id'],
      address:
          json['address'] != null ? Address.fromJson(json['address']) : null,
      organizer:
          json['organizer'] != null ? User.fromJson(json['organizer']) : null,
      type: json['type'] != null ? EventType.fromJson(json['type']) : null,
      groupId: json['group_id'],
      recurrenceType: json['recurrence_type'] != null
          ? RecurrenceType.values.firstWhere((e) =>
              e.toString() == 'RecurrenceType.' + json['recurrence_type'])
          : null,
    );
  }
}

class EventCreate {
  String name;
  String description;
  String date;
  String time;
  int typeId;
  int groupId;
  AddressCreate address;
  RecurrenceType? recurrenceType;

  EventCreate({
    required this.name,
    required this.description,
    required this.date,
    required this.time,
    required this.typeId,
    required this.groupId,
    required this.address,
    this.recurrenceType,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'date': date,
      'time': time,
      'type_id': typeId,
      'group_id': groupId,
      'address': address.toJson(),
      'recurrence_type': recurrenceType?.toString().split('.').last,
    };
  }
}
