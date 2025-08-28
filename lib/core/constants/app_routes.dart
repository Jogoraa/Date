/// App route paths and names
class AppRoutes {
  AppRoutes._();

  // Authentication routes
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String phoneVerification = '/phone-verification';
  static const String onboarding = '/onboarding';

  // Main navigation routes
  static const String discovery = '/discovery';
  static const String matches = '/matches';
  static const String chatList = '/chats';
  static const String profile = '/profile';

  // Detail routes
  static const String chat = '/chat';
  static const String profileDetails = '/profile-details';
  static const String editProfile = '/edit-profile';

  // Feature routes
  static const String subscription = '/subscription';
  static const String settings = '/settings';
  static const String preferences = '/preferences';
  static const String privacy = '/privacy';
  static const String safety = '/safety';
  static const String help = '/help';

  // Onboarding steps
  static const String onboardingPhotos = '/onboarding/photos';
  static const String onboardingPreferences = '/onboarding/preferences';
  static const String onboardingCulture = '/onboarding/culture';
  static const String onboardingComplete = '/onboarding/complete';

  // Discovery filters
  static const String discoveryFilters = '/discovery/filters';
  static const String discoveryTopPicks = '/discovery/top-picks';

  // Profile routes
  static const String profilePhotos = '/profile/photos';
  static const String profilePrompts = '/profile/prompts';
  static const String profileVerification = '/profile/verification';

  // Match routes
  static const String matchDetail = '/match';
  static const String matchConversationStarters = '/match/starters';

  // Premium routes
  static const String premiumFeatures = '/premium';
  static const String premiumPayment = '/premium/payment';
  static const String premiumSuccess = '/premium/success';

  // Safety routes
  static const String reportUser = '/report';
  static const String blockUser = '/block';
  static const String safetyCenter = '/safety-center';

  // Support routes
  static const String contactSupport = '/support';
  static const String faq = '/faq';
  static const String termsOfService = '/terms';
  static const String privacyPolicy = '/privacy-policy';

  // Deep link routes
  static const String verifyEmail = '/verify-email';
  static const String resetPassword = '/reset-password';
  static const String shareProfile = '/share';

  /// Get route with parameters
  static String chatWithId(String chatId) => '$chat/$chatId';
  static String profileWithId(String userId) => '$profileDetails/$userId';
  static String matchWithId(String matchId) => '$matchDetail/$matchId';
  static String reportUserWithId(String userId) => '$reportUser/$userId';
  static String blockUserWithId(String userId) => '$blockUser/$userId';

  /// Check if route requires authentication
  static bool requiresAuth(String route) {
    const unauthenticatedRoutes = [
      splash,
      login,
      signup,
      phoneVerification,
      verifyEmail,
      resetPassword,
      termsOfService,
      privacyPolicy,
    ];
    return !unauthenticatedRoutes.contains(route);
  }

  /// Check if route is part of main navigation
  static bool isMainNavigationRoute(String route) {
    const mainRoutes = [
      discovery,
      matches,
      chatList,
      profile,
    ];
    return mainRoutes.contains(route);
  }

  /// Get main navigation index for route
  static int getMainNavigationIndex(String route) {
    switch (route) {
      case discovery:
        return 0;
      case matches:
        return 1;
      case chatList:
        return 2;
      case profile:
        return 3;
      default:
        return 0;
    }
  }

  /// Get route for main navigation index
  static String getRouteForNavigationIndex(int index) {
    switch (index) {
      case 0:
        return discovery;
      case 1:
        return matches;
      case 2:
        return chatList;
      case 3:
        return profile;
      default:
        return discovery;
    }
  }
}
