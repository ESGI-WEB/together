import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/chat/blocs/chat_event.dart';

import 'blocs/chat_bloc.dart';
import 'blocs/chat_state.dart';

class ChatList extends StatefulWidget {
  final int groupId;

  const ChatList({super.key, required this.groupId});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state is MessagesState) {
                return ListView.builder(
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    return Text(state.messages[index]);
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Écrire un message',
                  ),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  String message = _messageController.text.trim();
                  if (message.isNotEmpty) {
                    context
                        .read<ChatBloc>()
                        .add(SendMessageEvent(message: message));
                    _messageController.clear();
                  }
                },
                child: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
