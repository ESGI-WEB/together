import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/services/chat_service.dart';
import 'package:web_socket_channel/io.dart';

import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(MessagesState(messages: [])) {
    on<InitializeWebSocketEvent>((event, emit) async {
      await _initWebSocket();
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

    add(InitializeWebSocketEvent());
  }

  IOWebSocketChannel? _webSocketChannel;

  Future<void> _initWebSocket() async {
    _webSocketChannel = await ChatService.getChannel();

    _webSocketChannel?.stream.listen((dynamic message) {
      add(NewMessageReceivedEvent(message: message));
    }, onDone: () {
      print('WebSocket connection closed');
    }, onError: (error) {
      print('WebSocket error: $error');
    });
  }

  void closeWebSocket() {
    _webSocketChannel?.sink.close();
  }
}
