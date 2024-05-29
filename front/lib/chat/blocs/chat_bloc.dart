import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/services/chat_service.dart';
import 'package:front/core/services/storage_service.dart';
import 'package:web_socket_channel/io.dart';

import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  late IOWebSocketChannel _channel;
  String? _token;
  late StreamSubscription _subscription;

  ChatBloc() : super(ChatInitialState()) {
    on<FetchMessagesEvent>((event, emit) async {
      _token ??= await StorageService.readToken();

      if (_token != null) {
        emit(ChatLoadingState());
        _channel = await ChatService.getChannel();
        emit(ChatLoadedState(messages: []));
        _subscription = _channel.stream.listen(
          _handleWebSocketMessage,
          onError: (error) {
            print('WebSocket Error: $error');
            emit(ChatErrorState(error: error.toString()));
          },
          onDone: () {
            print('WebSocket closed');
          },
        );
      }
    });

    on<SendMessageEvent>((event, emit) async {
      _token ??= await StorageService.readToken();

      if (_token != null) {
        Map<String, String> messageObject = {'content': event.message};
        String jsonMessage = json.encode(messageObject);
        _channel.sink.add(jsonMessage);
      }
    });
  }

  void _handleWebSocketMessage(data) {
    String message = json.decode(data)['content'];
    List<String> updatedMessages = List.from(state.messages)..add(message);
    if (!isClosed) {
      emit(ChatLoadedState(messages: updatedMessages));
    }
  }

  @override
  Future<void> close() async {
    _subscription.cancel();
    _channel.sink.close();
    super.close();
  }
}
