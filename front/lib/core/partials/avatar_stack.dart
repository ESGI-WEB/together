import 'dart:math';

import 'package:flutter/material.dart';
import 'package:front/core/models/user.dart';
import 'package:front/core/partials/avatar.dart';
import 'package:front/core/partials/widget_avatar.dart';

class AvatarStack extends StatelessWidget {
  final int displayedAvatars;
  final List<User> users;
  final int? total;

  final double leftSpacing = 25;
  final double avatarSize = 15;

  const AvatarStack({
    super.key,
    required this.users,
    this.displayedAvatars = 4,
    this.total,
  });

  double getStackSize() {
    bool showMoreUsersCircle = _getTotal() > displayedAvatars;
    int usersCirclesToDisplay = min(displayedAvatars, _getTotal());
    int totalCircles = usersCirclesToDisplay + (showMoreUsersCircle ? 1 : 0);

    // displayedCirclesInTotal * avatarLeft + (avatarSize - avatarLeft)
    return totalCircles * leftSpacing + (avatarSize*2 - leftSpacing);
  }

  int _getTotal() {
    return min(99 + displayedAvatars, total ?? users.length); // don't show more than 99
  }

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const WidgetAvatar(
        child: Text('0', style: TextStyle(fontSize: 14)),
      );
    }

    return SizedBox(
      // avatar's height
      height: avatarSize*2,
      width: getStackSize(),
      child: Stack(
        children: [
          for (int index = 0;
              index < min(displayedAvatars, _getTotal());
              index++)
            Positioned(
              left: index * leftSpacing,
              child: Avatar(user: users[index]),
            ),
          if (_getTotal() > displayedAvatars)
            Positioned(
              left: displayedAvatars * leftSpacing,
              child: WidgetAvatar(
                child: Text(
                  '+${_getTotal() - displayedAvatars}',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
