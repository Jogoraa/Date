class AppConstants {
  AppConstants._();
  
  // App Information
  static const String appName = 'Habesha Dating App';
  static const String appVersion = '1.0.0';
  
  // Supabase Configuration
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'your_supabase_url_here',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY', 
    defaultValue: 'your_supabase_anon_key_here',
  );
  
  // Feature Flags
  static const bool enableAnalytics = bool.fromEnvironment(
    'ENABLE_ANALYTICS',
    defaultValue: true,
  );
  static const bool enableCrashlytics = bool.fromEnvironment(
    'ENABLE_CRASHLYTICS',
    defaultValue: true,
  );
  static const bool enableCalls = bool.fromEnvironment(
    'ENABLE_CALLS',
    defaultValue: false,
  );
  
  // App Limits
  static const int freeSwipesPerDay = 20;
  static const int freeMatchesPerDay = 3;
  static const int premiumSuperLikesPerMonth = 5;
  static const int maxPhotosPerProfile = 9;
  static const int minPhotosPerProfile = 1;
  
  // Rate Limits
  static const int likesPerMinute = 12;
  static const int messagesPerMinuteFree = 10;
  static const int messagesPerMinutePremium = 30;
  
  // Timeouts & Performance
  static const Duration messageDeliveryTimeout = Duration(seconds: 30);
  static const Duration imageLoadTimeout = Duration(seconds: 10);
  static const Duration appLaunchTimeout = Duration(seconds: 3);
  
  // Subscription Tiers
  static const String freeTier = 'free';
  static const String premiumTier = 'premium';
  static const String eliteTier = 'elite';
  
  // Premium Pricing (USD)
  static const double premiumMonthlyPrice = 19.99;
  static const double premiumYearlyPrice = 99.99;
  static const double eliteMonthlyPrice = 39.99;
  
  // Supported Locales
  static const List<String> supportedLocales = ['en', 'am', 'om', 'ti'];
  static const String defaultLocale = 'en';
  
  // Age Restrictions
  static const int minimumAge = 18;
  static const int maximumAge = 100;
  
  // Distance Settings (in kilometers)
  static const int defaultSearchDistance = 50;
  static const int maxSearchDistance = 200;
  static const int minSearchDistance = 5;
  
  // Media Settings
  static const int maxImageSizeMB = 10;
  static const int maxVoiceNoteDurationSeconds = 60;
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];
  static const List<String> allowedAudioFormats = ['mp3', 'aac', 'amr'];
  
  // URLs & Links
  static const String privacyPolicyUrl = 'https://habeshadt.app/privacy';
  static const String termsOfServiceUrl = 'https://habeshadt.app/terms';
  static const String supportUrl = 'https://habeshadt.app/support';
  
  // Social Media
  static const String instagramUrl = 'https://instagram.com/habeshadt';
  static const String twitterUrl = 'https://twitter.com/habeshadt';
  static const String facebookUrl = 'https://facebook.com/habeshadt';
}
