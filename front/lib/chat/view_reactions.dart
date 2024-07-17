import 'package:flutter/material.dart';

class ViewReactionRow extends StatelessWidget {
  final Map<String, int> reactions;
  final bool reverse;

  const ViewReactionRow({
    super.key,
    required this.reactions,
    required this.reverse,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: reverse ? TextDirection.rtl : TextDirection.ltr,
      children: reactions.entries
          .map((entry) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.grey.shade200,
                        border: Border.all(
                          color: Colors.grey.shade700,
                        )),
                    child: Text("${entry.value} ${entry.key}")),
              ))
          .toList(),
    );
  }
}
