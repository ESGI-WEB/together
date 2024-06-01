abstract class ChatEvent {}

class NewMessageReceivedEvent extends ChatEvent {
  final String message;

  NewMessageReceivedEvent({required this.message});
}

class InitializeWebSocketEvent extends ChatEvent {
  InitializeWebSocketEvent();
}

class SendMessageEvent extends ChatEvent {
  final String message;

  SendMessageEvent({required this.message});
}
