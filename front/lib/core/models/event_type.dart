class EventType {
  final int id;
  final String name;
  final String description;

  EventType({
    required this.id,
    required this.name,
    required this.description,
  });

  factory EventType.fromJson(Map<String, dynamic> json) {
    return EventType(
      id: json['ID'],
      name: json['name'],
      description: json['description'],
    );
  }

  static List<EventType> listFromJson(List<dynamic> json) {
    return json.map((e) => EventType.fromJson(e)).toList();
  }
}
