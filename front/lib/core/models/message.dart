import 'package:front/core/models/group.dart';
import 'package:front/core/models/user.dart';
import 'package:front/core/models/event.dart';

enum MessageType {
  chat,
  publication,
}

class Message {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MessageType type;
  final String content;
  final bool isPinned;
  final int groupId;
  final Group group;
  final int userId;
  final User user;
  final int? eventId;
  final Event? event;

  Message({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
    required this.content,
    required this.isPinned,
    required this.groupId,
    required this.group,
    required this.userId,
    required this.user,
    this.eventId,
    this.event,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['ID'],
      createdAt: DateTime.parse(json['CreatedAt']),
      updatedAt: DateTime.parse(json['UpdatedAt']),
      type: json['type'],
      content: json['content'],
      isPinned: json['is_pinned'],
      groupId: json['group_id'],
      group: Group.fromJson(json['group']),
      userId: json['user_id'],
      user: User.fromJson(json['user']),
      eventId: json['event_id'],
      event: json['event'] != null ? Event.fromJson(json['event']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'CreatedAt': createdAt.toIso8601String(),
      'UpdatedAt': updatedAt.toIso8601String(),
      'type': type.toString().split('.').last,
      'content': content,
      'is_pinned': isPinned,
      'group_id': groupId,
      'group': group,
      'user_id': userId,
      'user': user.toJson(),
      'event_id': eventId,
      'event': event?.toJson(),
    };
  }
}

class MessageCreate {
  final MessageType type;
  final String content;
  final bool isPinned;
  final int groupId;
  final int userId;
  final int? eventId;

  MessageCreate({
    required this.type,
    required this.content,
    required this.isPinned,
    required this.groupId,
    required this.userId,
    this.eventId,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'content': content,
      'is_pinned': isPinned,
      'group_id': groupId,
      'user_id': userId,
      'event_id': eventId,
    };
  }
}

class MessageUpdate {
  final String content;

  MessageUpdate({
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
    };
  }
}

class MessagePinned {
  final bool isPinned;

  MessagePinned({
    required this.isPinned,
  });

  Map<String, dynamic> toJson() {
    return {
      'is_pinned': isPinned,
    };
  }
}