import 'package:flutter/material.dart';
import 'package:front/core/models/websocket_message.dart';
import 'package:front/core/partials/avatar.dart';

class MessageBubble extends StatelessWidget {
  final ServerBoundSendChatMessage message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Avatar(user: message.author),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            message.content,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
