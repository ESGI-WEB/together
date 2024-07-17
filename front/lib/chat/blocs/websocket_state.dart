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

  MessagesState add(ChatMessage newMessage, int? lastFetchedGroup) {
    List<ChatMessage> newMessages = List.of(messages);

    // Check if the message is already in the state
    final index = newMessages
        .indexWhere((element) => element.messageId == newMessage.messageId);
    if (index == -1) {
      // The message is not in the state, append to the list
      newMessages.add(newMessage);
    } else {
      // The message is in the state, replace id
      newMessages.replaceRange(index, index + 1, [newMessage]);
    }

    // TODO: We should sort all the messages by date

    // Create a new message state with the new messages
    MessagesState clonedState = MessagesState(
      messages: newMessages,
      lastFetchedGroup: lastFetchedGroup,
    );
    return clonedState;
  }

  @override
  MessagesState clone(int lastFetchedGroup) {
    return MessagesState(
      messages: [],
      lastFetchedGroup: lastFetchedGroup,
    );
  }
}

class PollUpdatedState extends WebSocketReady {
  final Poll poll;

  PollUpdatedState(this.poll);
}

class PollDeletedState extends WebSocketReady {
  final int pollId;

  PollDeletedState(this.pollId);
}

class EventAttendChangedState extends WebSocketReady {
  final Attend attend;

  EventAttendChangedState(this.attend);
}

class WebSocketErrorState extends WebSocketState {
  WebSocketErrorState(error);
}
