import 'package:front/core/models/user.dart';
import 'package:front/core/models/websocket.dart';

class ChatMessage {
  final String content;
  final User author;
  final int groupId;
  final int messageId;

  ChatMessage({
    required this.content,
    required this.author,
    required this.groupId,
    required this.messageId,
  });

  factory ChatMessage.fromServerBoundChatMessage(
      ServerBoundSendChatMessage serverBoundSendChatMessage) {
    return ChatMessage(
      content: serverBoundSendChatMessage.content,
      author: serverBoundSendChatMessage.author,
      groupId: serverBoundSendChatMessage.groupId,
      messageId: serverBoundSendChatMessage.messageId,
    );
  }
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
