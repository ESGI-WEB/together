import 'package:flutter/material.dart';

class WidgetAvatar extends StatelessWidget {
  final Widget child;

  const WidgetAvatar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 15,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      child: child,
    );
  }
}
