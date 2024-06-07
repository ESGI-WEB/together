import 'package:flutter/material.dart';
import 'package:front/core/models/message.dart';

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
        CircleAvatar(
          child: Text(
            message.author[0].toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
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
