import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/core/services/chat_service.dart';
import 'package:front/core/services/storage_service.dart';
import 'package:web_socket_channel/io.dart';

import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  IOWebSocketChannel? _channel;
  String? _token;
  StreamSubscription? _subscription;

  ChatBloc() : super(ChatInitialState()) {
    on<FetchMessagesEvent>((event, emit) async {
      await openChannel();
    });

    on<SendMessageEvent>((event, emit) async {
      final channel = await openChannel();
      Map<String, String> messageObject = {'content': event.message};
      String jsonMessage = json.encode(messageObject);
      channel.sink.add(jsonMessage);
    });
  }

  void _handleWebSocketMessage(data) {
    String message = json.decode(data)['content'];
    List<String> updatedMessages = List.from(state.messages)..add(message);
    if (!isClosed) {
      emit(ChatLoadedState(messages: updatedMessages)); // TODO, c'est correct mais mal detecté
    }
  }

  Future<IOWebSocketChannel> openChannel() async {
    final thisChannel = _channel;
    if (thisChannel != null) {
      return thisChannel;
    }

    _token ??= await StorageService.readToken();

    // At this point, the channel is null, thus we should get a new channel
    emit(ChatLoadingState());
    final channel = await ChatService.getChannel();

    _subscription = channel.stream.listen(
      _handleWebSocketMessage,
      onError: (error) {
        emit(ChatErrorState(error: error.toString()));
        _channel = null;
      },
      onDone: () {
        _channel = null;
      },
    );

    _channel = channel;
    return channel;
  }

  @override
  Future<void> close() async {
    _subscription?.cancel();
    _channel?.sink.close();
    super.close();
  }
}
