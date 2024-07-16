import 'package:flutter/material.dart';
import 'package:front/chat/send_reaction_row.dart';
import 'package:front/chat/view_reactions.dart';
import 'package:front/core/models/message.dart';
import 'package:front/core/partials/avatar.dart';

class MessageBubble extends StatefulWidget {
  final ChatMessage message;
  final bool reverse;

  const MessageBubble({
    super.key,
    required this.message,
    required this.reverse,
  });

  @override
  MessageBubbleState createState() => MessageBubbleState();
}

class MessageBubbleState extends State<MessageBubble> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: widget.reverse ? TextDirection.rtl : TextDirection.ltr,
      children: [
        Avatar(user: widget.message.author),
        const SizedBox(width: 10),
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            alignment:
                widget.reverse ? Alignment.centerRight : Alignment.centerLeft,
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
                right: 0,
                child: ViewReactionRow(
                  reverse: widget.reverse,
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
