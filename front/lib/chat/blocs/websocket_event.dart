import 'package:front/core/models/message.dart';
import 'package:front/core/models/poll.dart';

abstract class WebSocketEvent {}

class NewMessageReceivedEvent extends WebSocketEvent {
  final ServerBoundSendChatMessage message;

  NewMessageReceivedEvent._({required this.message});

  factory NewMessageReceivedEvent.fromString(Map<String, dynamic> message) {
    final convertedMessage = ServerBoundSendChatMessage.fromJson(
      message,
    );
    return NewMessageReceivedEvent._(message: convertedMessage);
  }
}

class PollUpdatedEvent extends WebSocketEvent {
  final Poll poll;

  PollUpdatedEvent({
    required this.poll,
  });
}

class PollDeletedEvent extends WebSocketEvent {
  final int pollId;

  PollDeletedEvent({
    required this.pollId,
  });
}

class WebSocketErrorEvent extends WebSocketEvent {
  WebSocketErrorEvent(error);
}

class InitializeWebSocketEvent extends WebSocketEvent {
  InitializeWebSocketEvent();
}

class SendMessageEvent extends WebSocketEvent {
  final ClientBoundSendChatMessage message;

  SendMessageEvent._({
    required this.message,
  });

  factory SendMessageEvent.build({
    required message,
    required groupId,
  }) {
    final sendChatMessage = ClientBoundSendChatMessage(
      content: message,
      groupId: groupId,
    );
    return SendMessageEvent._(message: sendChatMessage);
  }
}

class FetchMessagesEvent extends WebSocketEvent {
  final int groupId;

  FetchMessagesEvent({
    required this.groupId,
  });
}
