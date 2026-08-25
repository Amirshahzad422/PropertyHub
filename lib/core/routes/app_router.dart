import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:propertyhub/presentation/providers/auth_provider.dart';
import 'package:propertyhub/presentation/screens/auth/splash_screen.dart';
import 'package:propertyhub/presentation/screens/auth/auth_screen.dart';
import 'package:propertyhub/presentation/screens/auth/phone_auth_screen.dart';
import 'package:propertyhub/presentation/screens/auth/complete_profile_screen.dart';
import 'package:propertyhub/presentation/screens/buyer/home_screen.dart';
import 'package:propertyhub/presentation/screens/owner/owner_dashboard_screen.dart';
import 'package:propertyhub/presentation/screens/shell/app_shell.dart';
import 'package:propertyhub/presentation/screens/buyer/search_screen.dart';
import 'package:propertyhub/presentation/screens/buyer/saved_screen.dart';
import 'package:propertyhub/presentation/screens/shared/messages_screen.dart';
import 'package:propertyhub/presentation/screens/shared/profile_screen.dart';
import 'package:propertyhub/presentation/screens/owner/my_properties_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class _GoRouterRefreshNotifier extends ChangeNotifier {
  _GoRouterRefreshNotifier(Ref ref) {
    ref.listen(authStateProvider, (previous, next) {
      notifyListeners();
    });
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _GoRouterRefreshNotifier(ref);
  
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      
      final isLoggedIn = authState.value != null;
      final role = authState.value?.role;

      final isGoingToAuthScreen = state.matchedLocation == '/auth' || 
                                  state.matchedLocation == '/phone-auth' || 
                                  state.matchedLocation == '/splash';

      if (!isLoggedIn && !isGoingToAuthScreen) {
        return '/auth';
      }

      if (isLoggedIn && isGoingToAuthScreen) {
        if (role == 2) {
          return '/owner-dashboard';
        } else {
          return '/home';
        }
      }

      if (isLoggedIn && role == 1 && state.matchedLocation == '/owner-dashboard') {
        return '/home';
      }
      if (isLoggedIn && role == 2 && state.matchedLocation == '/home') {
        return '/owner-dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
      GoRoute(path: '/phone-auth', builder: (context, state) => const PhoneAuthScreen()),
      GoRoute(path: '/complete-profile', builder: (context, state) => const CompleteProfileScreen()),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return AppShell(state: state, child: child);
        },
        routes: [
          // Buyer Routes
          GoRoute(path: '/home', pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen())),
          GoRoute(path: '/search', pageBuilder: (context, state) => const NoTransitionPage(child: SearchScreen())),
          GoRoute(path: '/saved', pageBuilder: (context, state) => const NoTransitionPage(child: SavedScreen())),
          
          // Shared Routes
          GoRoute(path: '/messages', pageBuilder: (context, state) => const NoTransitionPage(child: MessagesScreen())),
          GoRoute(path: '/profile', pageBuilder: (context, state) => const NoTransitionPage(child: ProfileScreen())),
          
          // Owner Routes
          GoRoute(path: '/owner-dashboard', pageBuilder: (context, state) => const NoTransitionPage(child: OwnerDashboardScreen())),
          GoRoute(path: '/my-properties', pageBuilder: (context, state) => const NoTransitionPage(child: MyPropertiesScreen())),
        ],
      ),
    ],
  );
});
