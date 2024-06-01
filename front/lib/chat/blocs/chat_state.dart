abstract class ChatState {}

class MessagesState extends ChatState {
  final List<String> messages;

  MessagesState({required this.messages});
}
