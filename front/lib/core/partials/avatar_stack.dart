import 'dart:math';

import 'package:flutter/material.dart';
import 'package:front/core/models/user.dart';
import 'package:front/core/partials/avatar.dart';
import 'package:front/core/partials/widget_avatar.dart';

class AvatarStack extends StatelessWidget {
  final int displayedAvatars;
  final List<User> users;

  const AvatarStack({super.key, required this.users, this.displayedAvatars = 4});

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const WidgetAvatar(
        child: Text('0'),
      );
    }

    return SizedBox(
      // avatar's height
      height: 40,
      // displayedCirclesInTotal * avatarLeft + (avatarSize - avatarLeft)
      width: (displayedAvatars + 1) * 25 + (40 - 25),
      child: Stack(
        children: [
          for (int index = 0;
              index < min(displayedAvatars, users.length);
              index++)
            Positioned(
              left: index * 25,
              child: Avatar(user: users[index]),
            ),
          if (users.length > displayedAvatars)
            Positioned(
              left: displayedAvatars * 25,
              child: WidgetAvatar(
                child: Text(
                  '+${users.length - displayedAvatars}',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
