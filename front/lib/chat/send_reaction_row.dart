import 'package:flutter/material.dart';
import 'package:front/core/models/message.dart';
import 'package:front/core/services/chat_service.dart';

class SendReactionRow extends StatelessWidget {
  final List<String> reactions;
  final int messageId;
  final Function onPressed;

  const SendReactionRow({
    super.key,
    required this.reactions,
    required this.messageId,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: IntrinsicHeight(
        child: Wrap(
          children: List.generate(
            reactions.length,
            (index) => TextButton(
              child: Text(
                reactions[index],
                style: const TextStyle(fontSize: 24),
              ),
              onPressed: () {
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
    );
  }
}
