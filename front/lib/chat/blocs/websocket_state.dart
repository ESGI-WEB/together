import 'package:front/core/models/websocket_message.dart';

abstract class WebSocketState {}

class MessagesState extends WebSocketState {
  final List<ServerBoundSendChatMessage> messages;

  MessagesState({required this.messages});
}

class WebSocketErrorState extends WebSocketState {
  WebSocketErrorState(error);
}
