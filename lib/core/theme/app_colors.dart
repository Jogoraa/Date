import 'package:flutter/material.dart';

/// App color palette inspired by Ethiopian and Eritrean cultural colors
/// and optimized for dating app warm, welcoming experience
class AppColors {
  AppColors._();

  // Primary colors - inspired by Ethiopian sunset and warmth
  static const Color primary = Color(0xFFE74C3C); // Warm red/coral
  static const Color onPrimary = Color(0xFFFFFFFF);
  
  // Secondary colors - inspired by Ethiopian coffee and gold
  static const Color secondary = Color(0xFFF39C12); // Golden amber
  static const Color onSecondary = Color(0xFF000000);
  
  // Tertiary colors - inspired by traditional textiles
  static const Color tertiary = Color(0xFF27AE60); // Ethiopian green
  static const Color onTertiary = Color(0xFFFFFFFF);

  // Error colors
  static const Color error = Color(0xFFE74C3C);
  static const Color onError = Color(0xFFFFFFFF);

  // Neutral colors for light theme
  static const Color lightBackground = Color(0xFFFFFBFE);
  static const Color lightOnBackground = Color(0xFF1C1B1F);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightOnSurface = Color(0xFF1C1B1F);

  // Neutral colors for dark theme
  static const Color darkBackground = Color(0xFF1C1B1F);
  static const Color darkOnBackground = Color(0xFFE6E1E5);
  static const Color darkSurface = Color(0xFF2B2930);
  static const Color darkOnSurface = Color(0xFFE6E1E5);

  // Outline and shadow
  static const Color outline = Color(0xFF79747E);
  static const Color shadow = Color(0xFF000000);

  // Semantic colors for dating app features
  static const Color success = Color(0xFF27AE60); // Matches, likes
  static const Color warning = Color(0xFFF39C12); // Alerts, premium features
  static const Color info = Color(0xFF3498DB); // Information, tips
  
  // Feature-specific colors
  static const Color like = Color(0xFF27AE60); // Like button
  static const Color superLike = Color(0xFF3498DB); // Super like button
  static const Color pass = Color(0xFF95A5A6); // Pass button
  static const Color match = Color(0xFFE74C3C); // Match indication
  static const Color online = Color(0xFF27AE60); // Online status
  static const Color offline = Color(0xFF95A5A6); // Offline status
  
  // Premium tier colors
  static const Color premium = Color(0xFFF39C12); // Premium features
  static const Color elite = Color(0xFF9B59B6); // Elite tier
  
  // Cultural colors (can be used for cultural badges, events)
  static const Color ethiopianRed = Color(0xFFDA121A);
  static const Color ethiopianYellow = Color(0xFFFFDE00);
  static const Color ethiopianGreen = Color(0xFF078930);
  static const Color eritreanBlue = Color(0xFF418FDE);
  
  // Message status colors
  static const Color messageSent = Color(0xFF95A5A6);
  static const Color messageDelivered = Color(0xFF3498DB);
  static const Color messageRead = Color(0xFF27AE60);
  
  // Gradient colors for premium UI elements
  static const List<Color> premiumGradient = [
    Color(0xFFF39C12),
    Color(0xFFE67E22),
  ];
  
  static const List<Color> eliteGradient = [
    Color(0xFF9B59B6),
    Color(0xFF8E44AD),
  ];
  
  static const List<Color> matchGradient = [
    Color(0xFFE74C3C),
    Color(0xFFC0392B),
  ];

  // Photo overlay colors
  static const Color photoOverlay = Color(0x66000000);
  static const Color photoOverlayLight = Color(0x33000000);
  
  // Swipe action colors with opacity for overlay effects
  static const Color swipeRight = Color(0x8027AE60); // Like with opacity
  static const Color swipeLeft = Color(0x8095A5A6); // Pass with opacity
  static const Color swipeUp = Color(0x803498DB); // Super like with opacity
  
  // Chat bubble colors
  static const Color chatBubbleOwn = Color(0xFFE74C3C);
  static const Color chatBubbleOther = Color(0xFFF5F5F5);
  static const Color chatBubbleOwnDark = Color(0xFFE74C3C);
  static const Color chatBubbleOtherDark = Color(0xFF2B2930);
  
  // Verification badge colors
  static const Color verified = Color(0xFF3498DB);
  static const Color verifiedBackground = Color(0x1A3498DB);
  
  // Safety and moderation colors
  static const Color block = Color(0xFFE74C3C);
  static const Color report = Color(0xFFF39C12);
  static const Color safe = Color(0xFF27AE60);
}

/// Extension methods for color manipulations
extension AppColorsExtension on Color {
  /// Create a color with opacity
  Color withOpacity(double opacity) {
    return Color.fromRGBO(red, green, blue, opacity);
  }
  
  /// Darken a color by a percentage
  Color darken(double percentage) {
    final hsl = HSLColor.fromColor(this);
    final darkened = hsl.withLightness(
      (hsl.lightness - percentage / 100).clamp(0.0, 1.0),
    );
    return darkened.toColor();
  }
  
  /// Lighten a color by a percentage
  Color lighten(double percentage) {
    final hsl = HSLColor.fromColor(this);
    final lightened = hsl.withLightness(
      (hsl.lightness + percentage / 100).clamp(0.0, 1.0),
    );
    return lightened.toColor();
  }
}
