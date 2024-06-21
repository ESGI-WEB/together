import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:front/chat/blocs/websocket_event.dart';
import 'package:front/chat/message_bubble.dart';
import 'package:front/core/partials/error_occurred.dart';
import 'package:go_router/go_router.dart';

import 'blocs/websocket_bloc.dart';
import 'blocs/websocket_state.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = 'messaging';
  final int groupId;

  const ChatScreen({super.key, required this.groupId});

  static void navigateTo(BuildContext context, {required int id}) {
    context.goNamed(routeName, pathParameters: {'groupId': id.toString()});
  }

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WebSocketBloc, WebSocketState>(
      builder: (context, state) {
        if (state is MessagesState) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MessageBubble(
                        message: state.messages[index],
                      ),
                    );
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
                          context.read<WebSocketBloc>().add(SendMessageEvent(
                                message: message,
                                groupId: widget.groupId,
                              ));
                          _messageController.clear();
                        }
                      },
                      child: const Icon(Icons.send),
                    ),
                  ],
                ),
              )
            ],
          );
        } else if (state is WebSocketErrorState) {
          return ErrorOccurred(
              image: SvgPicture.asset(
            'assets/images/503.svg',
            height: 200,
          ));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
