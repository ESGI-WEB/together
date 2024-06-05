abstract class WebSocketState {}

class MessagesState extends WebSocketState {
  final List<String> messages;

  MessagesState({required this.messages});
}

class WebSocketErrorState extends WebSocketState {
  WebSocketErrorState(error);
}
