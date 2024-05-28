import "address.dart";

class Event {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String name;
  final String description;
  final String date;
  final String? time;
  final int typeId;
  final int organizerId;
  final int addressId;

  Event(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt,
      required this.name,
      required this.description,
      required this.date,
      this.time,
      required this.typeId,
      required this.organizerId,
      required this.addressId});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        id: json['ID'],
        createdAt: DateTime.parse(json['CreatedAt']),
        updatedAt: DateTime.parse(json['UpdatedAt']),
        deletedAt: json['DeletedAt'] != null
            ? DateTime.parse(json['deleted_at'])
            : null,
        name: json['name'],
        description: json['description'],
        date: json['date'],
        time: json['time'],
        typeId: json['type_id'],
        organizerId: json['organizer_id'],
        addressId: json['address_id']);
  }
}

class EventCreate {
  String name;
  String description;
  String date;
  String time;
  int typeId;
  AddressCreate address;

  EventCreate({
    required this.name,
    required this.description,
    required this.date,
    required this.time,
    required this.typeId,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'date': date,
      'time': time,
      'type_id': typeId,
      'address': address.toJson(),
    };
  }
}
