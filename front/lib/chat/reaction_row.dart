import 'package:flutter/material.dart';

class ReactionRow extends StatelessWidget {
  final List<String> reactions;

  const ReactionRow({super.key, required this.reactions});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -50,
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
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
