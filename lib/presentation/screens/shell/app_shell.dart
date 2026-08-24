import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:propertyhub/presentation/providers/auth_provider.dart';
import 'package:propertyhub/presentation/widgets/glass_app_bar.dart';
import 'package:propertyhub/presentation/widgets/glass_bottom_nav.dart';

class AppShell extends ConsumerStatefulWidget {
  final Widget child;
  final GoRouterState state;

  const AppShell({super.key, required this.child, required this.state});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _getBuyerIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/search')) return 1;
    if (location.startsWith('/saved')) return 2;
    if (location.startsWith('/messages')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  int _getOwnerIndex(String location) {
    if (location.startsWith('/owner-dashboard')) return 0;
    if (location.startsWith('/my-properties')) return 1;
    if (location.startsWith('/messages')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _onBuyerTabTapped(int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/saved');
        break;
      case 3:
        context.go('/messages');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  void _onOwnerTabTapped(int index) {
    switch (index) {
      case 0:
        context.go('/owner-dashboard');
        break;
      case 1:
        context.go('/my-properties');
        break;
      case 2:
        context.go('/messages');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final role = authState.value?.role ?? 1;
    final location = widget.state.matchedLocation;

    final isBuyer = role == 1;

    final currentIndex = isBuyer ? _getBuyerIndex(location) : _getOwnerIndex(location);

    final buyerItems = const [
      BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.search), activeIcon: Icon(Icons.search, size: 28), label: 'Search'),
      BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), activeIcon: Icon(Icons.favorite), label: 'Wishlist'),
      BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Chat'),
      BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
    ];

    final ownerItems = const [
      BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Dashboard'),
      BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), activeIcon: Icon(Icons.list_alt), label: 'Properties'),
      BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Chat'),
      BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
    ];

    return Scaffold(
      extendBody: true, 
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(
        title: 'PropertyHub',
        avatarUrl: authState.value?.profilePhotoUrl,
        onAvatarTapped: () => context.go('/profile'),
        onNotificationTapped: () {
        },
      ),
      body: widget.child,
      bottomNavigationBar: GlassBottomNav(
        currentIndex: currentIndex,
        onTap: isBuyer ? _onBuyerTabTapped : _onOwnerTabTapped,
        items: isBuyer ? buyerItems : ownerItems,
      ),
    );
  }
}
