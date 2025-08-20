import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'design_tokens.dart';
import 'typography_system.dart';

/// Adaptive theme that responds to system settings and user preferences
class AdaptiveTheme {
  /// Creates light theme with day mode optimizations
  static ThemeData lightTheme() {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color scheme based on behavioral psychology
      colorScheme: const ColorScheme.light(
        primary: DesignTokens.primaryBlue,
        onPrimary: Colors.white,
        secondary: DesignTokens.neutralGray,
        onSecondary: Colors.white,
        tertiary: DesignTokens.urgentOrange,
        onTertiary: Colors.white,
        error: DesignTokens.errorRed,
        onError: Colors.white,
        surface: DesignTokens.daySurface,
        onSurface: DesignTokens.dayForeground,

        outline: DesignTokens.dayBorder,
      ),
      
      // Typography system
      textTheme: _buildTextTheme(DesignTokens.dayForeground),
      
      // App bar theme with mobile-first design
      appBarTheme: AppBarTheme(
        backgroundColor: DesignTokens.dayBackground,
        foregroundColor: DesignTokens.dayForeground,
        elevation: DesignTokens.elevation0,
        centerTitle: true,
        titleTextStyle: AppTypography.h2.copyWith(
          color: DesignTokens.dayForeground,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      
      // Card theme with proper elevation
      cardTheme: CardThemeData(
        color: DesignTokens.dayBackground,
        elevation: DesignTokens.elevation2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
        ),
        margin: const EdgeInsets.all(DesignTokens.spaceSM),
      ),
      
      // Elevated button theme (Primary actions)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignTokens.primaryBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, DesignTokens.minTouchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spaceMD,
            vertical: DesignTokens.spaceSM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
          ),
          elevation: DesignTokens.elevation2,
          textStyle: AppTypography.body.copyWith(
            fontWeight: AppTypography.semiBold,
          ),
        ),
      ),
      
      // Outlined button theme (Secondary actions)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: DesignTokens.primaryBlue,
          minimumSize: const Size(0, DesignTokens.minTouchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spaceMD,
            vertical: DesignTokens.spaceSM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
          ),
          side: const BorderSide(
            color: DesignTokens.primaryBlue,
            width: 1.5,
          ),
          textStyle: AppTypography.body.copyWith(
            fontWeight: AppTypography.semiBold,
          ),
        ),
      ),
      
      // Text button theme (Tertiary actions)
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: DesignTokens.primaryBlue,
          minimumSize: const Size(0, DesignTokens.minTouchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spaceMD,
            vertical: DesignTokens.spaceSM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
          ),
          textStyle: AppTypography.body.copyWith(
            fontWeight: AppTypography.semiBold,
          ),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DesignTokens.daySurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
          borderSide: const BorderSide(
            color: DesignTokens.dayBorder,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
          borderSide: const BorderSide(
            color: DesignTokens.dayBorder,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
          borderSide: const BorderSide(
            color: DesignTokens.primaryBlue,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
          borderSide: const BorderSide(
            color: DesignTokens.errorRed,
            width: 1.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spaceMD,
          vertical: DesignTokens.spaceSM,
        ),
        labelStyle: AppTypography.body.copyWith(
          color: DesignTokens.neutralGray,
        ),
        hintStyle: AppTypography.body.copyWith(
          color: DesignTokens.neutralGrayLight,
        ),
      ),
      
      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: DesignTokens.dayBackground,
        selectedItemColor: DesignTokens.primaryBlue,
        unselectedItemColor: DesignTokens.neutralGray,
        type: BottomNavigationBarType.fixed,
        elevation: DesignTokens.elevation3,
      ),
      
      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: DesignTokens.primaryBlue,
        foregroundColor: Colors.white,
        elevation: DesignTokens.elevation3,
        shape: CircleBorder(),
      ),
      
      // Divider theme
      dividerTheme: const DividerThemeData(
        color: DesignTokens.dayBorder,
        thickness: 1.0,
        space: DesignTokens.spaceSM,
      ),
    );
    
    return baseTheme.copyWith(
      textTheme: baseTheme.mobileTextTheme,
    );
  }
  
  /// Creates dark theme with night mode optimizations (reduced blue light)
  static ThemeData darkTheme() {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color scheme with warm undertones for night mode
      colorScheme: const ColorScheme.dark(
        primary: DesignTokens.primaryBlueLight,
        onPrimary: DesignTokens.nightBackground,
        secondary: DesignTokens.neutralGrayLight,
        onSecondary: DesignTokens.nightBackground,
        tertiary: DesignTokens.urgentOrangeLight,
        onTertiary: DesignTokens.nightBackground,
        error: DesignTokens.errorRedLight,
        onError: DesignTokens.nightBackground,
        surface: DesignTokens.nightSurface,
        onSurface: DesignTokens.nightForeground,
        outline: DesignTokens.nightBorder,
      ),
      
      // Typography system for dark mode
      textTheme: _buildTextTheme(DesignTokens.nightForeground),
      
      // App bar theme for dark mode
      appBarTheme: AppBarTheme(
        backgroundColor: DesignTokens.nightBackground,
        foregroundColor: DesignTokens.nightForeground,
        elevation: DesignTokens.elevation0,
        centerTitle: true,
        titleTextStyle: AppTypography.h2.copyWith(
          color: DesignTokens.nightForeground,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      
      // Card theme for dark mode
      cardTheme: CardThemeData(
        color: DesignTokens.nightSurface,
        elevation: DesignTokens.elevation2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
        ),
        margin: const EdgeInsets.all(DesignTokens.spaceSM),
      ),
      
      // Elevated button theme for dark mode
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignTokens.primaryBlueLight,
          foregroundColor: DesignTokens.nightBackground,
          minimumSize: const Size(0, DesignTokens.minTouchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spaceMD,
            vertical: DesignTokens.spaceSM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
          ),
          elevation: DesignTokens.elevation2,
          textStyle: AppTypography.body.copyWith(
            fontWeight: AppTypography.semiBold,
          ),
        ),
      ),
      
      // Input decoration theme for dark mode
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DesignTokens.nightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
          borderSide: const BorderSide(
            color: DesignTokens.nightBorder,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
          borderSide: const BorderSide(
            color: DesignTokens.nightBorder,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
          borderSide: const BorderSide(
            color: DesignTokens.primaryBlueLight,
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
          borderSide: const BorderSide(
            color: DesignTokens.errorRedLight,
            width: 1.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spaceMD,
          vertical: DesignTokens.spaceSM,
        ),
        labelStyle: AppTypography.body.copyWith(
          color: DesignTokens.neutralGrayLight,
        ),
        hintStyle: AppTypography.body.copyWith(
          color: DesignTokens.neutralGray,
        ),
      ),
      
      // Bottom navigation bar theme for dark mode
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: DesignTokens.nightSurface,
        selectedItemColor: DesignTokens.primaryBlueLight,
        unselectedItemColor: DesignTokens.neutralGrayLight,
        type: BottomNavigationBarType.fixed,
        elevation: DesignTokens.elevation3,
      ),
      
      // Floating action button theme for dark mode
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: DesignTokens.primaryBlueLight,
        foregroundColor: DesignTokens.nightBackground,
        elevation: DesignTokens.elevation3,
        shape: CircleBorder(),
      ),
      
      // Divider theme for dark mode
      dividerTheme: const DividerThemeData(
        color: DesignTokens.nightBorder,
        thickness: 1.0,
        space: DesignTokens.spaceSM,
      ),
    );
    
    return baseTheme.copyWith(
      textTheme: baseTheme.mobileTextTheme.apply(
        bodyColor: DesignTokens.nightForeground,
        displayColor: DesignTokens.nightForeground,
      ),
    );
  }
  
  /// Builds text theme with consistent typography
  static TextTheme _buildTextTheme(Color textColor) {
    return TextTheme(
      displayLarge: AppTypography.display.copyWith(color: textColor),
      displayMedium: AppTypography.display.copyWith(
        color: textColor,
        fontSize: DesignTokens.h1Size,
      ),
      displaySmall: AppTypography.h1.copyWith(color: textColor),
      headlineLarge: AppTypography.h1.copyWith(color: textColor),
      headlineMedium: AppTypography.h2.copyWith(color: textColor),
      headlineSmall: AppTypography.h3.copyWith(color: textColor),
      titleLarge: AppTypography.h2.copyWith(color: textColor),
      titleMedium: AppTypography.h3.copyWith(color: textColor),
      titleSmall: AppTypography.bodyLarge.copyWith(
        color: textColor,
        fontWeight: AppTypography.semiBold,
      ),
      bodyLarge: AppTypography.bodyLarge.copyWith(color: textColor),
      bodyMedium: AppTypography.body.copyWith(color: textColor),
      bodySmall: AppTypography.caption.copyWith(color: textColor),
      labelLarge: AppTypography.body.copyWith(
        color: textColor,
        fontWeight: AppTypography.semiBold,
      ),
      labelMedium: AppTypography.caption.copyWith(
        color: textColor,
        fontWeight: AppTypography.medium,
      ),
      labelSmall: AppTypography.micro.copyWith(
        color: textColor,
        fontWeight: AppTypography.medium,
      ),
    );
  }
}

/// Extension for context-aware theme access
extension ThemeExtension on BuildContext {
  /// Gets the current theme data
  ThemeData get theme => Theme.of(this);
  
  /// Gets the current color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  
  /// Gets the current text theme
  TextTheme get textTheme => Theme.of(this).textTheme;
  
  /// Checks if the current theme is dark
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  
  /// Gets appropriate color based on current theme
  Color get adaptiveTextColor => isDarkMode 
      ? DesignTokens.nightForeground 
      : DesignTokens.dayForeground;
  
  /// Gets appropriate background color based on current theme
  Color get adaptiveBackgroundColor => isDarkMode 
      ? DesignTokens.nightBackground 
      : DesignTokens.dayBackground;
  
  /// Gets appropriate surface color based on current theme
  Color get adaptiveSurfaceColor => isDarkMode 
      ? DesignTokens.nightSurface 
      : DesignTokens.daySurface;
}

/// Semantic color extensions for behavioral psychology
extension SemanticColors on ColorScheme {
  /// Color for high-value primary actions
  Color get primaryAction => primary;
  
  /// Color for urgent or time-sensitive actions
  Color get urgentAction => const Color(0xFFFF9500);
  
  /// Color for positive outcomes and success states
  Color get successAction => const Color(0xFF34C759);
  
  /// Color for warning states
  Color get warningAction => const Color(0xFFFFCC02);
  
  /// Color for destructive actions
  Color get destructiveAction => error;
  
  /// Color for neutral secondary actions
  Color get neutralAction => secondary;
}