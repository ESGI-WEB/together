import 'package:front/core/models/attend.dart';
import 'package:front/core/models/message.dart';
import 'package:front/core/models/poll.dart';

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

class PollUpdatedState extends WebSocketState {
  final Poll poll;

  PollUpdatedState(this.poll);
}

class PollDeletedState extends WebSocketState {
  final int pollId;

  PollDeletedState(this.pollId);
}

class EventAttendChangedState extends WebSocketState {
  final Attend attend;

  EventAttendChangedState(this.attend);
}

class WebSocketErrorState extends WebSocketState {
  WebSocketErrorState(error);
}
