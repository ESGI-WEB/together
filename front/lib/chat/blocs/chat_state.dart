abstract class ChatState {
  Iterable get messages => [];
}

class ChatInitialState extends ChatState {}

class ChatLoadingState extends ChatState {}

class ChatLoadedState extends ChatState {
  @override
  final List<String> messages;

  ChatLoadedState({required this.messages});
}

class ChatErrorState extends ChatState {
  final String error;

  ChatErrorState({required this.error});
}
