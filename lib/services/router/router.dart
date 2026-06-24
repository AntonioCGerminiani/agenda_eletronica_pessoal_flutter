import 'package:agenda_eletronica_pessoal/screens/contacts/contact_list_screen.dart';
import 'package:agenda_eletronica_pessoal/screens/events/event_list_screen.dart';
import 'package:agenda_eletronica_pessoal/screens/groups/group_list_screen.dart';
import 'package:agenda_eletronica_pessoal/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Router {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter appRouter = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/contacts',
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder:
            (
              BuildContext context,
              GoRouterState state,
              StatefulNavigationShell navigationShell,
            ) {
              return HomeScreen(navigationShell: navigationShell);
            },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/contacts',
                builder: (BuildContext context, GoRouterState state) {
                  return const ContactListScreen();
                },
              ),
            ],
          ),

          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/groups',
                builder: (BuildContext context, GoRouterState state) {
                  return const GroupListScreen();
                },
              ),
            ],
          ),

          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/events',
                builder: (BuildContext context, GoRouterState state) {
                  return const EventListScreen();
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
