# Flutter GoRouter Declarative Navigation Skill

## Overview
Architectural standards, directory structure, best practices, and implementation guidelines for Flutter applications utilizing declarative navigation with `go_router`.

---

## Directory & Folder Structure

Follow a **Centralized Routing** structure within `core/router`:

```text
lib/
├── core/
│   ├── router/
│   │   ├── app_router.dart          # GoRouter instance & configuration
│   │   ├── route_names.dart         # Path & name constants
│   │   ├── route_guards.dart        # Auth & permission redirects
│   │   └── notifiers/
│   │       └── router_notifier.dart # Listenable for refreshListenable
├── features/
│   ├── auth/
│   │   └── presentation/screens/login_screen.dart
│   ├── home/
│   │   └── presentation/screens/home_screen.dart
│   ├── profile/
│   │   └── presentation/screens/profile_screen.dart
│   └── settings/
│       └── presentation/screens/settings_screen.dart
└── main.dart
```

---

## Core Rules & Principles

### 1. Named Routes & Paths
- Define all routes, names, and path constants in a dedicated `route_names.dart` file.
- Never hardcode raw string paths (e.g. `context.go('/profile')`) directly inside widgets.
- Use `context.goNamed(RouteNames.profile)` or typed route helpers.

### 2. `context.go()` vs `context.push()`
- **`context.go()`**: Replaces the navigation stack declarative history up to the target route. Use for tab changes, authentication transitions, and top-level navigation.
- **`context.push()`**: Pushes a new page on top of the current stack. Use for modal flows, temporary screens, and detail pages where the back button must pop to the exact previous view.

### 3. Reactive Route Guards with `refreshListenable`
- Implement route protection (such as authentication or onboarding completion) inside the `redirect` callback of `GoRouter`.
- Pass a `Listenable` (e.g., `ValueNotifier`, `ChangeNotifier`, or stream listener) to `refreshListenable` so the router re-evaluates the `redirect` callback automatically when the auth state changes.
- Avoid performing heavy asynchronous network calls inside `redirect`; check local cache or pre-fetched auth state instead.

### 4. Bottom Navigation & Nested Routing (`StatefulShellRoute`)
- Use `StatefulShellRoute.indexedStack` for persistent bottom navigation bars to preserve the scroll position and widget state of each branch.
- Avoid rebuilding the entire scaffold or recreation of tabs on tab switch.

### 5. Passing Parameters
- **Path parameters (`:id`)**: Use for required identifiers in hierarchical routing (e.g., `/products/:id`).
- **Query parameters (`?filter=active`)**: Use for optional search, filtering, or sorting flags.
- **`extra` payload**: Use only when passing non-primitive, complex in-memory objects where URL deep linking is not required. Always ensure fallback logic if `extra` is null upon deep link access.

---

## Reference Implementation

### 1. Route Names Constants
```dart
// core/router/route_names.dart
abstract class RouteNames {
  static const String root = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String details = 'details'; // Sub-route
  static const String profile = '/profile';
}
```

### 2. Router Configuration & Auth Redirect
```dart
// core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/details_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  final ValueNotifier<bool> isAuthenticatedListenable;

  AppRouter({required this.isAuthenticatedListenable});

  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.home,
    refreshListenable: isAuthenticatedListenable,
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = isAuthenticatedListenable.value;
      final bool loggingIn = state.matchedLocation == RouteNames.login;

      // If not logged in and not heading to login, redirect to login
      if (!loggedIn && !loggingIn) {
        return RouteNames.login;
      }

      // If already logged in and heading to login, redirect to home
      if (loggedIn && loggingIn) {
        return RouteNames.home;
      }

      return null; // No redirection required
    },
    routes: [
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      // StatefulShellRoute for Bottom Navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.home,
                name: RouteNames.home,
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: '${RouteNames.details}/:id',
                    name: RouteNames.details,
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return DetailsScreen(itemId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.profile,
                name: RouteNames.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
```

### 3. Nested Scaffold Shell
```dart
// core/router/scaffold_with_nested_navigation.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNestedNavigation extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNestedNavigation({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (int index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
```

### 4. Root Application Integration
```dart
// main.dart
import 'package:flutter/material.dart';
import 'core/router/app_router.dart';

void main() {
  final authNotifier = ValueNotifier<bool>(false);
  final appRouter = AppRouter(isAuthenticatedListenable: authNotifier);

  runApp(MyApp(appRouter: appRouter));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter App',
      routerConfig: appRouter.router,
    );
  }
}
```
