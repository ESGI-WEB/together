import 'package:flutter/material.dart';
import 'package:front/admin/home/admin_home_screen.dart';
import 'package:front/event/event_detail_screen.dart';
import 'package:front/groups/create_group_screen.dart';
import 'package:front/groups/group_home_screen.dart';
import 'package:front/groups/groups_screen.dart';
import 'package:front/groups/join_group_screen.dart';
import 'package:front/register/register_screen.dart';

import 'admin/features/features_screen.dart';
import 'event/event_create_screen.dart';
import 'login/login_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case GroupsScreen.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return const GroupsScreen();
          },
        );
      case CreateGroupScreen.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return const CreateGroupScreen();
          },
        );
      case GroupHomeScreen.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return GroupHomeScreen(
              groupId: args as int,
              title: 'Groupe $args',
            );
          },
        );
      case JoinGroupScreen.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return const JoinGroupScreen();
          },
        );
      case EventScreen.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return const EventScreen();
          },
        );
      case EventDetailScreen.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return EventDetailScreen(eventId: args as int);
          },
        );
      case RegisterScreen.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return RegisterScreen();
          },
        );
      case AdminHomeScreen.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return const AdminHomeScreen();
          },
        );
      case FeaturesScreen.routeName:
        return MaterialPageRoute(
          builder: (context) {
            return const FeaturesScreen();
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
