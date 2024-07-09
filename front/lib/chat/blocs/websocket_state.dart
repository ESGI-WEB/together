import 'package:front/core/models/message.dart';

abstract class WebSocketState {}

class WebSocketReady extends WebSocketState {
  final int? lastFetchedGroup;

  WebSocketReady({this.lastFetchedGroup});

  WebSocketReady clone(int lastFetchedGroup) {
    return WebSocketReady(
      lastFetchedGroup: lastFetchedGroup,
    );
  }
}

class MessagesState extends WebSocketReady {
  final List<ChatMessage> messages;

  MessagesState({
    required this.messages,
    super.lastFetchedGroup,
  });

  @override
  MessagesState clone(int lastFetchedGroup) {
    return MessagesState(
      messages: [],
      lastFetchedGroup: lastFetchedGroup,
    );
  }
}

class WebSocketErrorState extends WebSocketState {
  WebSocketErrorState(error);
}
