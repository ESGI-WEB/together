import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/models/attend.dart';
import 'package:front/core/models/message.dart';
import 'package:front/core/models/poll.dart';
import 'package:front/core/models/websocket.dart';
import 'package:front/core/services/storage_service.dart';
import 'package:front/core/services/websocket_service.dart';
import 'package:web_socket_channel/io.dart';

import 'websocket_event.dart';
import 'websocket_state.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  IOWebSocketChannel? _webSocketChannel;

  WebSocketBloc() : super(MessagesState(messages: [])) {
    on<InitializeWebSocketEvent>((event, emit) async {
      await _initWebSocket(emit);
      emit(MessagesState(messages: []));
    });

    on<NewMessageReceivedEvent>((event, emit) async {
      final userData = await StorageService.readJwtDataFromToken();
      emit(_buildMessageState(event.message.toChatMessage(userData?.id)));
    });

    on<PollUpdatedEvent>((event, emit) async {
      emit(PollUpdatedState(event.poll));
    });

    on<PollDeletedEvent>((event, emit) async {
      emit(PollDeletedState(event.pollId));
    });

    on<EventAttendChangedEvent>((event, emit) async {
      emit(EventAttendChangedState(event.attend));
    });

    on<SendMessageEvent>((event, emit) async {
      if (_webSocketChannel != null) {
        _sendWebSocketMessage(event.message.toJson());
      }
    });

    on<WebSocketErrorEvent>((event, emit) async {
      emit(WebSocketErrorState(event));
    });

    on<FetchMessagesEvent>((event, emit) async {
      if (state is WebSocketReady &&
          (state as WebSocketReady).lastFetchedGroup != event.groupId) {
        final messageObject = ClientBoundFetchChatMessageType(
          groupId: event.groupId,
        ).toJson();
        _sendWebSocketMessage(messageObject);

        emit((state as WebSocketReady).clone(event.groupId));
      }
    });

    add(InitializeWebSocketEvent());
  }

  Future<void> _initWebSocket(Emitter<WebSocketState> emit) async {
    _webSocketChannel = await WebSocketService.getChannel();
    if (_webSocketChannel == null) {
      Timer(const Duration(seconds: 2), () => _initWebSocket(emit));
      return;
    }

    _webSocketChannel?.stream.listen((dynamic message) {
      message = json.decode(message);
      switch (message['type']) {
        case 'poll_updated':
          add(PollUpdatedEvent(
            poll: Poll.fromJson(message['content']),
          ));
          break;
        case 'poll_deleted':
          add(PollDeletedEvent(
            pollId: message['content'] as int,
          ));
          break;
        case 'event_attend_changed':
          add(EventAttendChangedEvent(
            attend: Attend.fromJson(message['content']),
          ));
          break;
        case "send_chat_message":
        case "fetch_chat_messages":
          add(NewMessageReceivedEvent.fromString(message));
          break;
        default:
          break;
      }
    }, onDone: () {
      _webSocketChannel = null;
      Timer(const Duration(seconds: 2), () => _initWebSocket(emit));
    }, onError: (error) {
      add(WebSocketErrorEvent(error));
      _webSocketChannel = null;
      Timer(const Duration(seconds: 2), () => _initWebSocket(emit));
    });
  }

  void closeWebSocket() {
    _webSocketChannel?.sink.close();
  }

  MessagesState _buildMessageState(ChatMessage newMessage) {
    final lastFetchedGroup = state is WebSocketReady
        ? (state as WebSocketReady).lastFetchedGroup
        : null;

    if (state is MessagesState) {
      // We must keep the previous messages and append the new one
      return (state as MessagesState).add(newMessage, lastFetchedGroup);
    } else {
      // We don't have to keep the previous messages since it was not a message state
      return MessagesState(
        messages: [newMessage],
        lastFetchedGroup: lastFetchedGroup,
      );
    }
  }

  void _sendWebSocketMessage(Map messageObject) {
    String jsonMessage = json.encode(messageObject);
    _webSocketChannel?.sink.add(jsonMessage);
  }
}
