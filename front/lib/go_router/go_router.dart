import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/admin/admin_screen.dart';
import 'package:front/admin/features/features_screen.dart';
import 'package:front/chat/chat_screen.dart';
import 'package:front/core/partials/custom_app_bar.dart';
import 'package:front/core/partials/custom_bottom_bar.dart';
import 'package:front/core/services/storage_service.dart';
import 'package:front/event/create_event_screen.dart';
import 'package:front/event/event_screen/event_screen.dart';
import 'package:front/groups/create_group_screen/create_group_screen.dart';
import 'package:front/groups/group_screen/group_screen.dart';
import 'package:front/groups/groups_screen/blocs/groups_screen_bloc.dart';
import 'package:front/groups/groups_screen/groups_screen.dart';
import 'package:front/groups/join_group_screen/join_group_screen.dart';
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
          name: GroupsScreen.routeName,
          path: '/groups',
          builder: (context, state) {
            return BlocProvider(
                create: (context) => GroupsScreenBloc(),
                child: const GroupsScreen());
          },
          routes: [
            GoRoute(
              name: CreateGroupScreen.routeName,
              path: 'create',
              builder: (context, state)  {
                final groupsScreenBloc = state.extra as GroupsScreenBloc;
                return CreateGroupScreen(groupsScreenBloc: groupsScreenBloc);
              },
            ),
            GoRoute(
              name: JoinGroupScreen.routeName,
              path: 'join',
              builder: (context, state) {
                final groupsScreenBloc = state.extra as GroupsScreenBloc;
                return JoinGroupScreen(groupsScreenBloc: groupsScreenBloc);
              },
            ),
            ShellRoute(
              builder:
                  (BuildContext context, GoRouterState state, Widget child) {
                return CustomBottomBar(
                  groupId: int.parse(state.pathParameters['groupId']!),
                  child: child,
                );
              },
              routes: [
                GoRoute(
                  name: GroupScreen.routeName,
                  path: ':groupId',
                  builder: (context, state) {
                    return GroupScreen(
                      id: int.parse(state.pathParameters['groupId']!),
                    );
                  },
                  routes: [
                    GoRoute(
                      name: EventScreen.routeName,
                      path: 'event/:eventId',
                      builder: (context, state) {
                        return EventScreen(
                          groupId: int.parse(state.pathParameters['groupId']!),
                          eventId: int.parse(state.pathParameters['eventId']!),
                        );
                      },
                    ),
                    GoRoute(
                      name: CreateEventScreen.routeName,
                      path: 'create_event',
                      builder: (context, state) {
                        return CreateEventScreen(
                          groupId: int.parse(state.pathParameters['groupId']!),
                        );
                      },
                    ),
                    GoRoute(
                      name: ChatScreen.routeName,
                      path: 'messaging',
                      builder: (context, state) {
                        return ChatScreen(
                          groupId: int.parse(state.pathParameters['id']!),
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          name: AdminScreen.routeName,
          path: '/admin',
          builder: (context, state) => const AdminScreen(),
          routes: [
            GoRoute(
              name: FeaturesScreen.routeName,
              path: 'features',
              builder: (context, state) => const FeaturesScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      name: RegisterScreen.routeName,
      path: '/register',
      builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(
      name: LoginScreen.routeName,
      path: '/login',
      builder: (context, state) =>
          LoginScreen(defaultEmail: state.uri.queryParameters['defaultEmail']),
    ),
  ],
);
