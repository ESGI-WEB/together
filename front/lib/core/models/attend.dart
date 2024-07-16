import "package:front/core/models/user.dart";

import "event.dart";

class Attend {
  final int userId;
  final User? user;
  final int eventId;
  final Event? event;
  final bool hasAttended;
  final DateTime createdAt;
  final DateTime updatedAt;

  Attend({
    required this.userId,
    this.user,
    required this.eventId,
    this.event,
    required this.hasAttended,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Attend.fromJson(Map<String, dynamic> json) {
    return Attend(
      userId: json['user_id'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      eventId: json['event_id'],
      event: json['event'] != null ? Event.fromJson(json['event']) : null,
      hasAttended: json['has_attended'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
