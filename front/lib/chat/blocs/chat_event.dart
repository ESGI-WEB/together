abstract class ChatEvent {}

class FetchMessagesEvent extends ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String message;

  SendMessageEvent({required this.message});
}
