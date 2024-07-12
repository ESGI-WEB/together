import 'package:flutter/material.dart';
import 'package:front/core/models/message.dart';
import 'package:front/core/services/chat_service.dart';

class ReactionRow extends StatelessWidget {
  final List<String> reactions;
  final int messageId;
  final Function onPressed;

  const ReactionRow({
    super.key,
    required this.reactions,
    required this.messageId,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -10,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.blue[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(
              reactions.length,
              (index) => TextButton(
                child: Text(
                  reactions[index],
                  style: const TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  // TODO: Handle reaction press
                  ChatService.createReaction(
                    Reaction(
                      content: reactions[index],
                      messageId: messageId,
                    ),
                  );

                  onPressed();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
