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
          GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
          GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),
          GoRoute(path: '/saved', builder: (context, state) => const SavedScreen()),
          
          // Shared Routes
          GoRoute(path: '/messages', builder: (context, state) => const MessagesScreen()),
          GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
          
          // Owner Routes
          GoRoute(path: '/owner-dashboard', builder: (context, state) => const OwnerDashboardScreen()),
          GoRoute(path: '/my-properties', builder: (context, state) => const MyPropertiesScreen()),
        ],
      ),
    ],
  );
});
