import 'package:flutter/material.dart';
import 'package:front/chat/send_reaction_row.dart';
import 'package:front/chat/view_reactions.dart';
import 'package:front/core/models/message.dart';
import 'package:front/core/partials/avatar.dart';

class MessageBubble extends StatefulWidget {
  final ChatMessage message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  MessageBubbleState createState() => MessageBubbleState();
}

class MessageBubbleState extends State<MessageBubble> {
  late bool _showReactions;

  @override
  void initState() {
    super.initState();
    _showReactions = false;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Avatar(user: widget.message.author),
        const SizedBox(width: 10),
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              GestureDetector(
                onLongPress: () {
                  showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: 200,
                          child: SendReactionRow(
                            reactions: const ["👍", "😂", "👏", "💕"],
                            messageId: widget.message.messageId,
                            onPressed: () {
                              setState(() {
                                Navigator.pop(context);
                              });
                            },
                          ),
                        );
                      });
                  setState(() {
                    _showReactions = !_showReactions;
                  });
                },
                onTap: () {
                  setState(() {
                    _showReactions = false;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Text(
                    widget.message.content,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Positioned(
                bottom: -16,
                left: 0,
                child: ViewReactionRow(
                  reactions: widget.message.reactions,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
