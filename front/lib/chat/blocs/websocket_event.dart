abstract class WebSocketEvent {}

class NewMessageReceivedEvent extends WebSocketEvent {
  final String message;

  NewMessageReceivedEvent({required this.message});
}

class WebSocketErrorEvent extends WebSocketEvent {
  WebSocketErrorEvent(error);
}

class InitializeWebSocketEvent extends WebSocketEvent {
  InitializeWebSocketEvent();
}

class SendMessageEvent extends WebSocketEvent {
  final String message;
  final int groupId;

  SendMessageEvent({
    required this.message,
    required this.groupId,
  });
}
