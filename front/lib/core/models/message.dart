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

  ServerBoundSendChatMessage({
    required this.content,
    required this.author,
    required this.groupId,
  }) : super(type: 'send_chat_message');

  factory ServerBoundSendChatMessage.fromJson(Map<String, dynamic> json) {
    return ServerBoundSendChatMessage(
      content: json['content'],
      author: User.fromJson(json['author']),
      groupId: json['group_id'],
    );
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
