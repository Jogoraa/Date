import 'package:flutter/material.dart';

/// Consistent spacing and dimension system for the app
class AppSpacing {
  AppSpacing._();

  // Base spacing unit (8dp Material Design)
  static const double _baseUnit = 8.0;

  // Spacing values
  static const double xs = _baseUnit * 0.5; // 4
  static const double sm = _baseUnit; // 8
  static const double md = _baseUnit * 2; // 16
  static const double lg = _baseUnit * 3; // 24
  static const double xl = _baseUnit * 4; // 32
  static const double xxl = _baseUnit * 6; // 48
  static const double xxxl = _baseUnit * 8; // 64

  // Padding presets
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);

  // Horizontal padding presets
  static const EdgeInsets paddingHorizontalXS = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets paddingHorizontalSM = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHorizontalMD = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHorizontalLG = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHorizontalXL = EdgeInsets.symmetric(horizontal: xl);

  // Vertical padding presets
  static const EdgeInsets paddingVerticalXS = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets paddingVerticalSM = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalMD = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVerticalLG = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets paddingVerticalXL = EdgeInsets.symmetric(vertical: xl);

  // Screen padding
  static const EdgeInsets screenPadding = EdgeInsets.all(md);
  static const EdgeInsets screenPaddingHorizontal = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets screenPaddingVertical = EdgeInsets.symmetric(vertical: md);

  // Card and container padding
  static const EdgeInsets cardPadding = EdgeInsets.all(md);
  static const EdgeInsets containerPadding = EdgeInsets.all(lg);

  // Border radius values
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusRound = 999.0; // For circular elements

  // Border radius presets
  static const BorderRadius borderRadiusXS = BorderRadius.all(Radius.circular(radiusXS));
  static const BorderRadius borderRadiusSM = BorderRadius.all(Radius.circular(radiusSM));
  static const BorderRadius borderRadiusMD = BorderRadius.all(Radius.circular(radiusMD));
  static const BorderRadius borderRadiusLG = BorderRadius.all(Radius.circular(radiusLG));
  static const BorderRadius borderRadiusXL = BorderRadius.all(Radius.circular(radiusXL));

  // Button dimensions
  static const double buttonHeight = 48.0;
  static const double buttonHeightSM = 36.0;
  static const double buttonHeightLG = 56.0;
  static const double buttonMinWidth = 64.0;

  // Icon sizes
  static const double iconXS = 16.0;
  static const double iconSM = 20.0;
  static const double iconMD = 24.0;
  static const double iconLG = 32.0;
  static const double iconXL = 48.0;
  static const double iconXXL = 64.0;

  // Avatar sizes
  static const double avatarSM = 32.0;
  static const double avatarMD = 48.0;
  static const double avatarLG = 64.0;
  static const double avatarXL = 96.0;
  static const double avatarXXL = 128.0;

  // Dating app specific dimensions
  static const double swipeCardHeight = 600.0;
  static const double swipeCardWidth = 340.0;
  static const double swipeCardRadius = radiusLG;

  static const double profilePhotoAspectRatio = 4.0 / 5.0; // Portrait ratio
  static const double profilePhotoGridSpacing = sm;

  static const double chatBubbleMaxWidth = 280.0;
  static const double chatBubbleRadius = radiusMD;

  static const double bottomNavHeight = 60.0;
  static const double appBarHeight = kToolbarHeight;

  // Match modal dimensions
  static const double matchModalSize = 300.0;

  // Boost and premium feature dimensions
  static const double premiumBadgeSize = 20.0;
  static const double verifiedBadgeSize = 16.0;

  // Animation durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  // Swipe animation durations
  static const Duration swipeAnimationDuration = Duration(milliseconds: 200);
  static const Duration swipeResetDuration = Duration(milliseconds: 300);

  // Chat typing indicator
  static const Duration typingIndicatorDelay = Duration(milliseconds: 500);

  // Auto-dismiss durations
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration toastDuration = Duration(seconds: 2);

  // Responsive breakpoints
  static const double mobileBreakpoint = 480.0;
  static const double tabletBreakpoint = 768.0;
  static const double desktopBreakpoint = 1024.0;

  // Safe area and status bar considerations
  static const double statusBarHeight = 24.0; // Approximate, will be dynamically calculated
  static const double bottomSafeArea = 34.0; // iPhone X+ home indicator
}

/// Extension methods for responsive spacing
extension AppSpacingExtension on BuildContext {
  /// Get responsive spacing based on screen width
  double get responsiveSpacing {
    final width = MediaQuery.of(this).size.width;
    if (width < AppSpacing.mobileBreakpoint) {
      return AppSpacing.sm;
    } else if (width < AppSpacing.tabletBreakpoint) {
      return AppSpacing.md;
    } else {
      return AppSpacing.lg;
    }
  }

  /// Get responsive padding based on screen width
  EdgeInsets get responsivePadding {
    final spacing = responsiveSpacing;
    return EdgeInsets.all(spacing);
  }

  /// Get responsive horizontal padding
  EdgeInsets get responsiveHorizontalPadding {
    final spacing = responsiveSpacing;
    return EdgeInsets.symmetric(horizontal: spacing);
  }

  /// Check if current screen is mobile sized
  bool get isMobile => MediaQuery.of(this).size.width < AppSpacing.mobileBreakpoint;

  /// Check if current screen is tablet sized
  bool get isTablet {
    final width = MediaQuery.of(this).size.width;
    return width >= AppSpacing.mobileBreakpoint && width < AppSpacing.desktopBreakpoint;
  }

  /// Check if current screen is desktop sized
  bool get isDesktop => MediaQuery.of(this).size.width >= AppSpacing.desktopBreakpoint;
}
