import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/phone_verification_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/discovery/presentation/pages/discovery_page.dart';
import '../../features/matching/presentation/pages/matches_page.dart';
import '../../features/chat/presentation/pages/chat_list_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/profile_details_page.dart';
import '../../features/subscription/presentation/pages/subscription_page.dart';
import '../constants/app_routes.dart';
import 'main_scaffold.dart';

/// Global router configuration
final appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  debugLogDiagnostics: true,
  routes: [
    // Splash screen
    GoRoute(
      path: AppRoutes.splash,
      name: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    
    // Authentication routes
    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      name: AppRoutes.signup,
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: AppRoutes.phoneVerification,
      name: AppRoutes.phoneVerification,
      builder: (context, state) {
        final phoneNumber = state.extra as String?;
        return PhoneVerificationPage(phoneNumber: phoneNumber);
      },
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      name: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    
    // Main app with bottom navigation
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        // Discovery (Home)
        GoRoute(
          path: AppRoutes.discovery,
          name: AppRoutes.discovery,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DiscoveryPage(),
          ),
        ),
        
        // Matches
        GoRoute(
          path: AppRoutes.matches,
          name: AppRoutes.matches,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MatchesPage(),
          ),
        ),
        
        // Chat List
        GoRoute(
          path: AppRoutes.chatList,
          name: AppRoutes.chatList,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ChatListPage(),
          ),
        ),
        
        // Profile
        GoRoute(
          path: AppRoutes.profile,
          name: AppRoutes.profile,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfilePage(),
          ),
        ),
      ],
    ),
    
    // Individual chat
    GoRoute(
      path: '${AppRoutes.chat}/:chatId',
      name: AppRoutes.chat,
      builder: (context, state) {
        final chatId = state.pathParameters['chatId']!;
        final matchData = state.extra as Map<String, dynamic>?;
        return ChatPage(
          chatId: chatId,
          matchData: matchData,
        );
      },
    ),
    
    // Profile details (viewing another user's profile)
    GoRoute(
      path: '${AppRoutes.profileDetails}/:userId',
      name: AppRoutes.profileDetails,
      builder: (context, state) {
        final userId = state.pathParameters['userId']!;
        final profileData = state.extra as Map<String, dynamic>?;
        return ProfileDetailsPage(
          userId: userId,
          profileData: profileData,
        );
      },
    ),
    
    // Edit profile
    GoRoute(
      path: AppRoutes.editProfile,
      name: AppRoutes.editProfile,
      builder: (context, state) => const EditProfilePage(),
    ),
    
    // Subscription/Premium
    GoRoute(
      path: AppRoutes.subscription,
      name: AppRoutes.subscription,
      builder: (context, state) => const SubscriptionPage(),
    ),
    
    // Settings routes
    GoRoute(
      path: AppRoutes.settings,
      name: AppRoutes.settings,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: AppRoutes.preferences,
      name: AppRoutes.preferences,
      builder: (context, state) => const PreferencesPage(),
    ),
    GoRoute(
      path: AppRoutes.privacy,
      name: AppRoutes.privacy,
      builder: (context, state) => const PrivacyPage(),
    ),
    GoRoute(
      path: AppRoutes.safety,
      name: AppRoutes.safety,
      builder: (context, state) => const SafetyPage(),
    ),
    GoRoute(
      path: AppRoutes.help,
      name: AppRoutes.help,
      builder: (context, state) => const HelpPage(),
    ),
  ],
  
  // Error page
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64),
          const SizedBox(height: 16),
          Text(
            'Page not found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            state.error?.toString() ?? 'Unknown error',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go(AppRoutes.discovery),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  ),
  
  // Route redirect logic
  redirect: (context, state) {
    // Add authentication check here
    // For now, always allow access
    return null;
  },
);

// Placeholder pages (to be implemented)
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              'Habesha Dating App',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Connecting hearts across cultures',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

// Temporary placeholder pages
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Page')),
    );
  }
}

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preferences')),
      body: const Center(child: Text('Preferences Page')),
    );
  }
}

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy')),
      body: const Center(child: Text('Privacy Page')),
    );
  }
}

class SafetyPage extends StatelessWidget {
  const SafetyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Safety')),
      body: const Center(child: Text('Safety Page')),
    );
  }
}

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help')),
      body: const Center(child: Text('Help Page')),
    );
  }
}
