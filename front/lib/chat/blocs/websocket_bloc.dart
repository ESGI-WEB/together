import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/models/message.dart';
import 'package:front/core/services/chat_service.dart';
import 'package:web_socket_channel/io.dart';

import 'websocket_event.dart';
import 'websocket_state.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  WebSocketBloc() : super(MessagesState(messages: [])) {
    on<InitializeWebSocketEvent>((event, emit) async {
      await _initWebSocket(emit);
    });

    on<NewMessageReceivedEvent>((event, emit) async {
      List<ServerBoundSendChatMessage> messages =
          List.from((state as MessagesState).messages);
      messages
          .add(ServerBoundSendChatMessage.fromJson(jsonDecode(event.message)));
      emit(MessagesState(messages: messages));
    });

    on<SendMessageEvent>((event, emit) async {
      if (_webSocketChannel != null) {
        final messageObject = ClientBoundSendChatMessage(
          content: event.message,
          groupId: event.groupId,
        ).toJson();
        String jsonMessage = json.encode(messageObject);
        _webSocketChannel!.sink.add(jsonMessage);
      }
    });

    on<WebSocketErrorEvent>((event, emit) async {
      emit(WebSocketErrorState(event));
    });

    add(InitializeWebSocketEvent());
  }

  IOWebSocketChannel? _webSocketChannel;

  Future<void> _initWebSocket(Emitter<WebSocketState> emit) async {
    _webSocketChannel = await ChatService.getChannel();
    if (_webSocketChannel == null) {
      Timer(const Duration(seconds: 2), () => _initWebSocket(emit));
      return;
    }

    _webSocketChannel?.stream.listen((dynamic message) {
      add(NewMessageReceivedEvent(message: message));
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
}
