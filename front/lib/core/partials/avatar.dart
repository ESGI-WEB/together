import 'package:flutter/material.dart';
import 'package:front/core/models/user.dart';

class Avatar extends StatelessWidget {
  final User user;

  const Avatar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final firstLetter = user.name.isNotEmpty ? user.name[0].toUpperCase() : "U";
    return CircleAvatar(
      radius: 20,
      backgroundColor: user.color,
      foregroundColor: user.textColor,
      child: Text(firstLetter),
    );
  }
}
