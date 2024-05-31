import 'package:flutter/material.dart';
import 'package:front/admin/admin_screen.dart';
import 'package:front/admin/features/features_screen.dart';
import 'package:front/core/partials/CustomAppBar.dart';
import 'package:front/core/services/storage_service.dart';
import 'package:front/event/event_create_screen.dart';
import 'package:front/event/event_screen.dart';
import 'package:front/event/events_screen.dart';
import 'package:front/groups/create_group_screen.dart';
import 'package:front/groups/group_screen.dart';
import 'package:front/groups/groups_screen.dart';
import 'package:front/groups/join_group_screen.dart';
import 'package:front/login/login_screen.dart';
import 'package:front/register/register_screen.dart';
import 'package:go_router/go_router.dart';

final goRouter = GoRouter(
  // TODO error screen
  // errorBuilder: (context, state) => ErrorScreen(state.error),
  debugLogDiagnostics: true,
  initialLocation: '/groups',
  redirect: (BuildContext context, GoRouterState state) async {
    if (await StorageService.isUserLogged()) {
      return null;
    } else {
      return '/login';
    }
  },
  routes: [
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return CustomAppBar(
          canPop: state.uri.toString() != '/groups',
          child: child,
        );
      },
      routes: [
        GoRoute(
          name: 'groups',
          path: '/groups',
          builder: (context, state) => const GroupsScreen(),
          routes: [
            GoRoute(
              name: 'group',
              path: ':id',
              builder: (context, state) {
                return GroupScreen(id: state.pathParameters['id']!);
              },
            ),
            GoRoute(
              name: 'create_group',
              path: 'create',
              builder: (context, state) => const CreateGroupScreen(),
            ),
            GoRoute(
              name: 'join_group',
              path: 'join',
              builder: (context, state) => const JoinGroupScreen(),
            ),
          ],
        ),
        GoRoute(
          name: 'events',
          path: '/events',
          builder: (context, state) => const EventsScreen(),
          routes: [
            GoRoute(
              name: 'event',
              path: ':id',
              builder: (context, state) {
                return EventScreen(id: state.pathParameters['id']!);
              },
            ),
            GoRoute(
              name: 'create_event',
              path: 'create',
              builder: (context, state) {
                return const EventCreateScreen();
              },
            ),
          ],
        ),
        GoRoute(
          name: 'admin',
          path: '/admin',
          builder: (context, state) => const AdminScreen(),
          routes: [
            GoRoute(
              name: 'features',
              path: 'features',
              builder: (context, state) => const FeaturesScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      name: 'register',
      path: '/register',
      builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (context, state) =>
          LoginScreen(defaultEmail: state.uri.queryParameters['defaultEmail']),
    ),
  ],
);
