import 'package:flutter/material.dart';
import 'package:front/register/register_screen.dart';

import 'groups/group_screen.dart';
import 'groups/groups_list_screen.dart';
import 'login/login_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute (RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case GroupScreen.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return GroupScreen(groupId: args as String);
          },
        );
      case GroupsListScreen.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return const GroupsListScreen();
          },
        );
      case RegisterScreen.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return RegisterScreen();
          },
        );
      default:
        return MaterialPageRoute(
          builder: (context) {
            return LoginScreen(defaultEmail: args as String?);
          },
        );
    }
  }
}