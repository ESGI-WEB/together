import 'package:flutter/material.dart';

class ViewReactionRow extends StatelessWidget {
  final Map<String, int> reactions;

  const ViewReactionRow({
    super.key,
    required this.reactions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: reactions.entries
          .map((entry) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.blue,
                    ),
                    child: Text("${entry.value} ${entry.key}")),
              ))
          .toList(),
    );
  }
}
