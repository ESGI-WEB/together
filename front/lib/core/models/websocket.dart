import 'package:front/core/models/message.dart';
import 'package:front/core/models/user.dart';

class WebSocketMessage {
  final String type;

  WebSocketMessage({
    required this.type,
  });
}

class ServerBoundSendChatMessage extends WebSocketMessage {
  final String content;
  final User author;
  final int groupId;
  final int messageId;
  final Map<String, int> reactions;

  ServerBoundSendChatMessage({
    required this.content,
    required this.author,
    required this.groupId,
    required this.messageId,
    required this.reactions,
  }) : super(type: 'send_chat_message');

  factory ServerBoundSendChatMessage.fromJson(Map<String, dynamic> json) {
    return ServerBoundSendChatMessage(
      content: json['content'],
      author: User.fromJson(json['author']),
      groupId: json['group_id'],
      messageId: json['message_id'],
      reactions:
          (json['reactions'] as Map<String, dynamic>).cast<String, int>(),
    );
  }

  ChatMessage toChatMessage() {
    return ChatMessage.fromServerBoundChatMessage(this);
  }
}

class ClientBoundSendChatMessage extends WebSocketMessage {
  final String content;
  final int groupId;

  ClientBoundSendChatMessage({
    required this.content,
    required this.groupId,
  }) : super(type: 'send_chat_message');

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'content': content,
      'group_id': groupId,
    };
  }
}

class ClientBoundFetchChatMessageType extends WebSocketMessage {
  final int groupId;

  ClientBoundFetchChatMessageType({
    required this.groupId,
  }) : super(type: 'fetch_chat_messages');

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'group_id': groupId,
    };
  }
}
