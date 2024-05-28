import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/chat_bloc.dart';
import 'blocs/chat_event.dart';
import 'blocs/chat_state.dart';

class ChatList extends StatefulWidget {
  final String groupId;

  const ChatList({super.key, required this.groupId});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  String _message = '';

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(FetchMessagesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatLoadingState) {
          return const CircularProgressIndicator();
        } else if (state is ChatLoadedState) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    return Text(state.messages[index]);
                  },
                ),
              ),
              TextFormField(
                onChanged: (value) {
                  _message = value;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<ChatBloc>()
                      .add(SendMessageEvent(message: _message));
                  _message = '';
                },
                child: const Text('Envoyer'),
              ),
            ],
          );
        } else if (state is ChatErrorState) {
          return const Text("Une erreur est survenue");
        }
        return const Text("Empty");
      },
    );
  }

  @override
  void dispose() {
    context.read<ChatBloc>().close();
    super.dispose();
  }
}
