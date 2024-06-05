import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
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
      List<String> messages = List.from((state as MessagesState).messages);
      messages.add(event.message);
      emit(MessagesState(messages: messages));
    });

    on<SendMessageEvent>((event, emit) async {
      if (_webSocketChannel != null) {
        Map<String, String> messageObject = {'content': event.message};
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

    _webSocketChannel?.stream.listen((dynamic message) {
      add(NewMessageReceivedEvent(message: message));
    }, onDone: () {
      print('WebSocket connection closed');
    }, onError: (error) {
      add(WebSocketErrorEvent(error));
    });
  }

  void closeWebSocket() {
    _webSocketChannel?.sink.close();
  }
}
