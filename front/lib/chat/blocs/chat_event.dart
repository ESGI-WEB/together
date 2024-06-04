abstract class ChatEvent {}

class NewMessageReceivedEvent extends ChatEvent {
  final String message;

  NewMessageReceivedEvent({required this.message});
}

class WebSocketErrorEvent extends ChatEvent {
  WebSocketErrorEvent(error);
}

class InitializeWebSocketEvent extends ChatEvent {
  InitializeWebSocketEvent();
}

class SendMessageEvent extends ChatEvent {
  final String message;

  SendMessageEvent({required this.message});
}
