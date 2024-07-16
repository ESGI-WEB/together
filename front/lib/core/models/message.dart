import 'package:front/core/models/user.dart';

class ChatMessage {
  final String content;
  final User author;
  final int groupId;
  final int messageId;
  final bool isOwnMessage;
  final Map<String, int> reactions;

  ChatMessage({
    required this.content,
    required this.author,
    required this.groupId,
    required this.messageId,
    required this.reactions,
    required this.isOwnMessage,
  });
}

class Reaction {
  final String content;
  final int messageId;

  Reaction({
    required this.content,
    required this.messageId,
  });

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      content: json['reaction_content'],
      messageId: json['messageId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reaction_content': content,
    };
  }
}
