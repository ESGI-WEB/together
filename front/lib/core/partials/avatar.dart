import 'package:flutter/material.dart';
import 'package:front/core/models/user.dart';

class Avatar extends StatelessWidget {
  final User user;

  const Avatar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: user.colorHex,
      foregroundColor: user.textColorHex,
      child: Text(
        user.name[0].toUpperCase(),
      ),
    );
  }
}
