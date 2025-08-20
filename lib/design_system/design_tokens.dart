import 'package:flutter/material.dart';

/// Design Tokens following the mobile-first psychology principles
class DesignTokens {
  // SPACING SYSTEM - 8pt Grid with Fibonacci Scaling
  static const double baseUnit = 8.0;
  static const double microSpacing = 4.0; // Fine details
  
  // Fibonacci-based spacing scale
  static const double spaceXS = 8.0;   // baseUnit * 1
  static const double spaceSM = 16.0;  // baseUnit * 2
  static const double spaceMD = 24.0;  // baseUnit * 3
  static const double spaceLG = 40.0;  // baseUnit * 5
  static const double spaceXL = 64.0;  // baseUnit * 8
  static const double spaceXXL = 104.0; // baseUnit * 13
  static const double macroSpacing = 120.0; // Section separation

  // MOBILE-OPTIMIZED TYPE SCALE
  static const double displaySize = 36.0;    // Headlines, hero content
  static const double h1Size = 30.0;         // Page titles
  static const double h2Size = 26.0;         // Section headers
  static const double h3Size = 22.0;         // Subsection headers
  static const double bodyLargeSize = 18.0;  // Primary reading
  static const double bodySize = 16.0;       // Secondary reading
  static const double captionSize = 14.0;    // Metadata, labels
  static const double microSize = 12.0;      // Legal, fine print

  // Line heights for optimal readability (1.5x font size)
  static const double displayLineHeight = 54.0;
  static const double h1LineHeight = 45.0;
  static const double h2LineHeight = 39.0;
  static const double h3LineHeight = 33.0;
  static const double bodyLargeLineHeight = 27.0;
  static const double bodyLineHeight = 24.0;
  static const double captionLineHeight = 21.0;
  static const double microLineHeight = 18.0;

  // BEHAVIORAL COLOR PSYCHOLOGY SYSTEM
  // Primary Action Colors (High-Value Actions)
  static const Color primaryBlue = Color(0xFF007AFF);     // Trust + Action
  static const Color primaryBlueDark = Color(0xFF0056CC);
  static const Color primaryBlueLight = Color(0xFF4DA3FF);

  // Urgent/Time-Sensitive Actions
  static const Color urgentOrange = Color(0xFFFF9500);    // Urgency without alarm
  static const Color urgentOrangeDark = Color(0xFFCC7700);
  static const Color urgentOrangeLight = Color(0xFFFFB84D);

  // Positive Outcomes
  static const Color successGreen = Color(0xFF34C759);    // Success + Progress
  static const Color successGreenDark = Color(0xFF28A745);
  static const Color successGreenLight = Color(0xFF5ED97C);

  // Error/Destructive Actions
  static const Color errorRed = Color(0xFFFF3B30);
  static const Color errorRedDark = Color(0xFFCC2E26);
  static const Color errorRedLight = Color(0xFFFF6B62);

  // Warning States
  static const Color warningYellow = Color(0xFFFFCC02);
  static const Color warningYellowDark = Color(0xFFCCA302);
  static const Color warningYellowLight = Color(0xFFFFD84D);

  // Neutral Actions (Secondary importance)
  static const Color neutralGray = Color(0xFF8E8E93);
  static const Color neutralGrayDark = Color(0xFF636366);
  static const Color neutralGrayLight = Color(0xFFAEAEB2);

  // CONTEXT-AWARE COLOR SYSTEMS
  // Day Mode Colors
  static const Color dayBackground = Color(0xFFFFFFFF);
  static const Color dayForeground = Color(0xFF000000);
  static const Color daySurface = Color(0xFFF2F2F7);
  static const Color dayBorder = Color(0xFFE5E5EA);

  // Night Mode Colors (Reduced blue light, warm undertones)
  static const Color nightBackground = Color(0xFF1C1C1E);
  static const Color nightForeground = Color(0xFFFFFFFF);
  static const Color nightSurface = Color(0xFF2C2C2E);
  static const Color nightBorder = Color(0xFF38383A);

  // THUMB-ZONE ARCHITECTURE CONSTANTS
  static const double minTouchTarget = 44.0; // iOS minimum
  static const double androidMinTouchTarget = 48.0; // Android minimum
  static const double comfortableTouchTarget = 56.0; // Comfortable size
  
  // Screen zone percentages (based on 6.1" average screen)
  static const double primaryZonePercent = 0.25;   // Bottom 25% - most accessible
  static const double secondaryZonePercent = 0.50; // Middle 50% - comfortable reach
  static const double tertiaryZonePercent = 0.25;  // Top 25% - requires repositioning

  // ELEVATION SYSTEM (Material Design 3 inspired)
  static const double elevation0 = 0.0;
  static const double elevation1 = 1.0;
  static const double elevation2 = 3.0;
  static const double elevation3 = 6.0;
  static const double elevation4 = 8.0;
  static const double elevation5 = 12.0;

  // BORDER RADIUS SYSTEM
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusRound = 999.0; // Fully rounded

  // ANIMATION DURATIONS (Following Material Motion)
  static const Duration durationImmediate = Duration(milliseconds: 100);
  static const Duration durationQuick = Duration(milliseconds: 200);
  static const Duration durationModerate = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);
  static const Duration durationExtended = Duration(milliseconds: 700);

  // OPACITY LEVELS
  static const double opacityDisabled = 0.38;
  static const double opacityMedium = 0.60;
  static const double opacityHigh = 0.87;
  static const double opacityFull = 1.0;
}

/// Responsive breakpoints for adaptive design
class Breakpoints {
  static const double mobile = 320.0;
  static const double tablet = 768.0;
  static const double desktop = 1024.0;
  static const double largeDesktop = 1440.0;
}

/// Grid system configuration
class GridSystem {
  static const int mobileColumns = 4;
  static const int tabletColumns = 8;
  static const int desktopColumns = 12;
  
  static const double gutterWidth = 16.0;
  static const double marginWidth = 16.0;
}

/// Typography system with mobile-first optimization
class AppTypography {
  static const String primaryFontFamily = 'SF Pro Display'; // iOS system font
  static const String secondaryFontFamily = 'Roboto'; // Android system font
  
  // Font weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // Text styles with mobile optimization
  static const TextStyle display = TextStyle(
    fontSize: DesignTokens.displaySize,
    height: DesignTokens.displayLineHeight / DesignTokens.displaySize,
    fontWeight: bold,
    letterSpacing: -0.5,
  );

  static const TextStyle h1 = TextStyle(
    fontSize: DesignTokens.h1Size,
    height: DesignTokens.h1LineHeight / DesignTokens.h1Size,
    fontWeight: bold,
    letterSpacing: -0.3,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: DesignTokens.h2Size,
    height: DesignTokens.h2LineHeight / DesignTokens.h2Size,
    fontWeight: semiBold,
    letterSpacing: -0.2,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: DesignTokens.h3Size,
    height: DesignTokens.h3LineHeight / DesignTokens.h3Size,
    fontWeight: semiBold,
    letterSpacing: -0.1,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: DesignTokens.bodyLargeSize,
    height: DesignTokens.bodyLargeLineHeight / DesignTokens.bodyLargeSize,
    fontWeight: regular,
    letterSpacing: 0.0,
  );

  static const TextStyle body = TextStyle(
    fontSize: DesignTokens.bodySize,
    height: DesignTokens.bodyLineHeight / DesignTokens.bodySize,
    fontWeight: regular,
    letterSpacing: 0.0,
  );

  static const TextStyle caption = TextStyle(
    fontSize: DesignTokens.captionSize,
    height: DesignTokens.captionLineHeight / DesignTokens.captionSize,
    fontWeight: regular,
    letterSpacing: 0.1,
  );

  static const TextStyle micro = TextStyle(
    fontSize: DesignTokens.microSize,
    height: DesignTokens.microLineHeight / DesignTokens.microSize,
    fontWeight: regular,
    letterSpacing: 0.2,
  );
}

/// Shadow system for depth and hierarchy
class AppShadows {
  static const List<BoxShadow> elevation1 = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> elevation2 = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 2),
      blurRadius: 6,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> elevation3 = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> elevation4 = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> elevation5 = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 16),
      blurRadius: 32,
      spreadRadius: 0,
    ),
  ];
}