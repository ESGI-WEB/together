import 'dart:math';

import 'package:flutter/material.dart';
import 'package:front/core/models/user.dart';
import 'package:front/core/partials/avatar.dart';
import 'package:front/core/partials/widget_avatar.dart';

class AvatarStack extends StatelessWidget {
  final int displayedAvatars;
  final List<User> users;

  final double leftSpacing = 25;

  const AvatarStack({super.key, required this.users, this.displayedAvatars = 4});

  double getStackSize() {
    bool showMoreUsersCircle = this.users.length > this.displayedAvatars;
    int usersCirclesToDisplay = min(displayedAvatars, this.users.length);
    int totalCircles = usersCirclesToDisplay + (showMoreUsersCircle ? 1 : 0);

    // displayedCirclesInTotal * avatarLeft + (avatarSize - avatarLeft)
    return totalCircles * leftSpacing + (40 - leftSpacing);
  }


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
      width: getStackSize(),
      child: Stack(
        children: [
          for (int index = 0;
              index < min(displayedAvatars, users.length);
              index++)
            Positioned(
              left: index * leftSpacing,
              child: Avatar(user: users[index]),
            ),
          if (users.length > displayedAvatars)
            Positioned(
              left: displayedAvatars * leftSpacing,
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
