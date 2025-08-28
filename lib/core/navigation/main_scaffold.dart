import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Main scaffold with bottom navigation bar
class MainScaffold extends StatelessWidget {
  const MainScaffold({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const MainBottomNavigationBar(),
    );
  }
}

/// Bottom navigation bar with custom styling
class MainBottomNavigationBar extends StatelessWidget {
  const MainBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    final int selectedIndex = _calculateSelectedIndex(location);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (index) => _onItemTapped(context, index),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.outline,
        selectedLabelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.explore_outlined),
            activeIcon: const Icon(Icons.explore),
            label: 'Discover',
            tooltip: 'Discover new people',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite_outline),
            activeIcon: const Icon(Icons.favorite),
            label: 'Matches',
            tooltip: 'Your matches',
          ),
          BottomNavigationBarItem(
            icon: const _ChatIcon(hasUnread: false), // TODO: Connect to real state
            activeIcon: const _ChatIcon(hasUnread: false, isActive: true),
            label: 'Chats',
            tooltip: 'Your conversations',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: 'Profile',
            tooltip: 'Your profile',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(String location) {
    if (location.startsWith(AppRoutes.discovery)) {
      return 0;
    } else if (location.startsWith(AppRoutes.matches)) {
      return 1;
    } else if (location.startsWith(AppRoutes.chatList)) {
      return 2;
    } else if (location.startsWith(AppRoutes.profile)) {
      return 3;
    }
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.discovery);
        break;
      case 1:
        context.go(AppRoutes.matches);
        break;
      case 2:
        context.go(AppRoutes.chatList);
        break;
      case 3:
        context.go(AppRoutes.profile);
        break;
    }
  }
}

/// Custom chat icon with unread indicator
class _ChatIcon extends StatelessWidget {
  const _ChatIcon({
    required this.hasUnread,
    this.isActive = false,
  });

  final bool hasUnread;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          isActive ? Icons.chat : Icons.chat_outlined,
          color: isActive ? AppColors.primary : AppColors.outline,
        ),
        if (hasUnread)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

/// Custom app bar for consistent styling
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation = 0,
    this.bottom,
    this.automaticallyImplyLeading = true,
  });

  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final double elevation;
  final PreferredSizeWidget? bottom;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: titleWidget ?? (title != null ? Text(title!) : null),
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      elevation: elevation,
      bottom: bottom,
      automaticallyImplyLeading: automaticallyImplyLeading,
      titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      iconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
  );
}

/// Floating action button with match styling
class MatchFAB extends StatelessWidget {
  const MatchFAB({
    super.key,
    required this.onPressed,
    this.tooltip,
  });

  final VoidCallback onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 4,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.matchGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.auto_awesome,
          size: AppSpacing.iconLG,
        ),
      ),
    );
  }
}

/// Premium floating action button
class PremiumFAB extends StatelessWidget {
  const PremiumFAB({
    super.key,
    required this.onPressed,
    this.tooltip,
  });

  final VoidCallback onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: AppColors.premium,
      foregroundColor: Colors.white,
      elevation: 4,
      icon: const Icon(Icons.diamond),
      label: const Text(
        'Premium',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
