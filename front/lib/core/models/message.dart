class WebSocketMessage {
  final String type;

  WebSocketMessage({
    required this.type,
  });
}

class ServerBoundSendChatMessage extends WebSocketMessage {
  final String content;
  final String author;

  ServerBoundSendChatMessage({
    required this.content,
    required this.author,
  }) : super(type: 'send_chat_message');

  factory ServerBoundSendChatMessage.fromJson(Map<String, dynamic> json) {
    return ServerBoundSendChatMessage(
      content: json['content'],
      author: json['author_name'],
    );
  }
}

class ClientBoundSendChatMessage extends WebSocketMessage {
  final String content;

  ClientBoundSendChatMessage({
    required this.content,
  }) : super(type: 'send_chat_message');

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'content': content,
    };
  }
}
