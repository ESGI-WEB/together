import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:front/admin/admin_drawer.dart';
import 'package:front/admin/dashboard/dasboard_screen.dart';
import 'package:front/admin/event_types/event_types_screen.dart';
import 'package:front/admin/features/features_screen.dart';
import 'package:front/admin/users/users_screen.dart';
import 'package:front/chat/blocs/websocket_bloc.dart';
import 'package:front/chat/chat_screen.dart';
import 'package:front/core/models/jwt_data.dart';
import 'package:front/core/models/user.dart';
import 'package:front/core/partials/custom_app_bar.dart';
import 'package:front/core/partials/custom_bottom_bar.dart';
import 'package:front/core/partials/error_occurred.dart';
import 'package:front/core/services/storage_service.dart';
import 'package:front/event/create_event_screen/create_event_screen.dart';
import 'package:front/event/event_screen/event_screen.dart';
import 'package:front/event/list_events/list_events_group_screen.dart';
import 'package:front/event/list_events/list_events_user_screen.dart';
import 'package:front/groups/create_group_screen/create_group_screen.dart';
import 'package:front/groups/group_screen/group_screen.dart';
import 'package:front/groups/groups_screen/blocs/groups_bloc.dart';
import 'package:front/groups/groups_screen/groups_screen.dart';
import 'package:front/groups/join_group_screen/join_group_screen.dart';
import 'package:front/info/info_group_screen.dart';
import 'package:front/login/login_screen.dart';
import 'package:front/register/register_screen.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  // remove all transition effects

  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
    transitionDuration: const Duration(milliseconds: 0),
  );
}

final goRouter = GoRouter(
  // TODO error screen
  // errorBuilder: (context, state) => ErrorScreen(state.error),
  debugLogDiagnostics: true,
  initialLocation: !kIsWeb ? '/groups' : '/admin',
  redirect: (BuildContext context, GoRouterState state) async {
    if (state.uri.toString() == '/register') {
      return '/register';
    } else if (await StorageService.isUserLogged()) {
      return null;
    } else {
      return '/login';
    }
  },
  routes: [
    GoRoute(
        path: '/error',
        builder: (context, state) {
          void logout() {
            StorageService.deleteToken()
                .then((value) => LoginScreen.navigateTo(context));
          }

          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  color: Colors.black,
                  onPressed: logout,
                ),
              ],
            ),
            body: Center(
              child: ErrorOccurred(
                onBackButtonPressed: logout,
                onHomeButtonPressed: logout,
                image: SvgPicture.asset(
                  'assets/images/error.svg',
                  height: 200,
                ),
              ),
            ),
          );
        }),
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return BlocProvider(
          create: (context) => WebSocketBloc(),
          child: CustomAppBar(
            canPop: state.uri.toString() != '/groups',
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: child,
              ),
            ),
          ),
        );
      },
      redirect: (BuildContext context, GoRouterState state) async {
        if (kIsWeb) {
          JwtData? jwtData = await StorageService.readJwtDataFromToken();
          if (jwtData!.role == UserRole.admin.name) {
            return '/admin';
          } else {
            return '/error';
          }
        } else {
          return null;
        }
      },
      routes: [
        GoRoute(
          name: GroupsScreen.routeName,
          path: '/groups',
          builder: (context, state) {
            return const GroupsScreen();
          },
          routes: [
            GoRoute(
              path: ListEventsUserScreen.routeName,
              name: ListEventsUserScreen.routeName,
              builder: (context, state) {
                return const ListEventsUserScreen();
              },
            ),
            GoRoute(
              name: CreateGroupScreen.routeName,
              path: 'create',
              builder: (context, state) {
                final groupsBloc = state.extra as GroupsBloc;
                return CreateGroupScreen(groupsBloc: groupsBloc);
              },
            ),
            GoRoute(
              name: JoinGroupScreen.routeName,
              path: 'join',
              builder: (context, state) {
                final groupsBloc = state.extra as GroupsBloc;
                return JoinGroupScreen(groupsBloc: groupsBloc);
              },
            ),
            ShellRoute(
              builder:
                  (BuildContext context, GoRouterState state, Widget child) {
                    int selectedIndex = 0;
                    final location = state.uri.toString();
                    if (location.contains(ListEventsGroupScreen.routeName)) {
                      selectedIndex = 1;
                    } else if (location.contains(ChatScreen.routeName)) {
                      selectedIndex = 2;
                    } else if (location.contains(InfoGroupScreen.routeName)) {
                      selectedIndex = 3;
                    }

                    return CustomBottomBar(
                      groupId: int.parse(state.pathParameters['groupId']!),
                      selectedIndex: selectedIndex,
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
                      name: ListEventsGroupScreen.routeName,
                      path: ListEventsGroupScreen.routeName,
                      builder: (context, state) {
                        return ListEventsGroupScreen(
                          id: int.parse(state.pathParameters['groupId']!),
                        );
                      },
                    ),
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
                      name: InfoGroupScreen.routeName,
                      path: InfoGroupScreen.routeName,
                      builder: (context, state) {
                        return InfoGroupScreen(
                            groupId:
                                int.parse(state.pathParameters['groupId']!));
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
                      path: ChatScreen.routeName,
                      builder: (context, state) {
                        return ChatScreen(
                          groupId: int.parse(state.pathParameters['groupId']!),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return CustomAppBar(
          drawer: const AdminDrawer(),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1600),
              child: child,
            ),
          ),
        );
      },
      redirect: (BuildContext context, GoRouterState state) async {
        JwtData? jwtData = await StorageService.readJwtDataFromToken();
        if (jwtData!.role == UserRole.admin.name) {
          return null;
        } else {
          return '/login';
        }
      },
      routes: [
        GoRoute(
          name: DashboardScreen.routeName,
          path: '/admin',
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const DashboardScreen(),
          ),
          routes: [
            GoRoute(
              name: FeaturesScreen.routeName,
              path: 'features',
              pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const FeaturesScreen(),
              ),
            ),
            GoRoute(
              name: EventTypesScreen.routeName,
              path: 'event-types',
              pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const EventTypesScreen(),
              ),
            ),
            GoRoute(
              name: UsersScreen.routeName,
              path: 'users',
              pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const UsersScreen(),
              ),
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
