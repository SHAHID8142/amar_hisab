import 'package:flutter/material.dart';
import 'design_tokens.dart';

/// Advanced typography system with micro-typography principles
class TypographySystem {
  // Font loading states
  static bool _fontsLoaded = false;
  static final Map<String, bool> _fontLoadingStates = {};
  
  /// Initialize typography system with dynamic font loading
  static Future<void> initialize() async {
    if (_fontsLoaded) return;
    
    try {
      // Preload critical fonts
      await _preloadCriticalFonts();
      _fontsLoaded = true;
    } catch (e) {
      debugPrint('Typography initialization failed: $e');
    }
  }
  
  /// Preload critical fonts for performance
  static Future<void> _preloadCriticalFonts() async {
    final criticalFonts = ['Inter', 'SiyamRupali', 'Roboto'];
    
    for (final font in criticalFonts) {
      try {
        await _loadFont(font);
        _fontLoadingStates[font] = true;
      } catch (e) {
        _fontLoadingStates[font] = false;
        debugPrint('Failed to load font $font: $e');
      }
    }
  }
  
  /// Load individual font with fallback
  static Future<void> _loadFont(String fontFamily) async {
    // Simulate font loading - in real app, this would load from assets
    await Future.delayed(const Duration(milliseconds: 100));
  }
  
  /// Check if font is loaded
  static bool isFontLoaded(String fontFamily) {
    return _fontLoadingStates[fontFamily] ?? false;
  }
}

/// Mobile-optimized typography scale with behavioral psychology
class MobileTypography {
  // Primary font families with fallbacks
  static const String primaryFont = 'Inter';
  static const String displayFont = 'SiyamRupali';
  static const String monoFont = 'RobotoMono';
  
  // Font fallback chains
  static const List<String> primaryFallback = [primaryFont, 'Roboto', 'Arial', 'sans-serif'];
  static const List<String> displayFallback = [displayFont, primaryFont, 'serif'];
  static const List<String> monoFallback = [monoFont, 'Courier', 'monospace'];
  
  // Micro-typography constants
  static const double optimalLineHeight = 1.5;
  static const double tightLineHeight = 1.3;
  static const double looseLineHeight = 1.7;
  static const double optimalLetterSpacing = 0.0;
  static const double tightLetterSpacing = -0.5;
  static const double looseLetterSpacing = 0.5;
  
  // Mobile-optimized type scale (based on major third - 1.25)
  static const double scaleRatio = 1.25;
  static const double baseSize = 16.0;
  
  // Calculated sizes
  static const double xs = baseSize * 0.64;   // 10.24px
  static const double sm = baseSize * 0.8;    // 12.8px
  static const double base = baseSize;        // 16px
  static const double lg = baseSize * scaleRatio;      // 20px
  static const double xl = baseSize * scaleRatio * scaleRatio;  // 25px
  static const double xxl = baseSize * scaleRatio * scaleRatio * scaleRatio; // 31.25px
  static const double xxxl = baseSize * scaleRatio * scaleRatio * scaleRatio * scaleRatio; // 39.06px
  
  // Behavioral typography styles
  
  /// Display text for maximum impact and attention
  static TextStyle get display1 => TextStyle(
    fontFamily: displayFont,
    fontSize: xxxl,
    fontWeight: FontWeight.w800,
    height: tightLineHeight,
    letterSpacing: tightLetterSpacing,
    color: DesignTokens.primaryBlue,
  );
  
  /// Large display for hero sections
  static TextStyle get display2 => TextStyle(
    fontFamily: displayFont,
    fontSize: xxl,
    fontWeight: FontWeight.w700,
    height: tightLineHeight,
    letterSpacing: tightLetterSpacing,
  );
  
  /// Primary heading for sections
  static TextStyle get h1 => TextStyle(
    fontFamily: primaryFont,
    fontSize: xl,
    fontWeight: FontWeight.w700,
    height: tightLineHeight,
    letterSpacing: optimalLetterSpacing,
  );
  
  /// Secondary heading
  static TextStyle get h2 => TextStyle(
    fontFamily: primaryFont,
    fontSize: lg,
    fontWeight: FontWeight.w600,
    height: optimalLineHeight,
    letterSpacing: optimalLetterSpacing,
  );
  
  /// Tertiary heading
  static TextStyle get h3 => TextStyle(
    fontFamily: primaryFont,
    fontSize: base,
    fontWeight: FontWeight.w600,
    height: optimalLineHeight,
    letterSpacing: optimalLetterSpacing,
  );
  
  /// Body text for optimal readability
  static TextStyle get body1 => TextStyle(
    fontFamily: primaryFont,
    fontSize: base,
    fontWeight: FontWeight.w400,
    height: optimalLineHeight,
    letterSpacing: optimalLetterSpacing,
  );
  
  /// Secondary body text
  static TextStyle get body2 => TextStyle(
    fontFamily: primaryFont,
    fontSize: sm,
    fontWeight: FontWeight.w400,
    height: optimalLineHeight,
    letterSpacing: looseLetterSpacing,
  );
  
  /// Caption text for metadata
  static TextStyle get caption => TextStyle(
    fontFamily: primaryFont,
    fontSize: xs,
    fontWeight: FontWeight.w400,
    height: optimalLineHeight,
    letterSpacing: looseLetterSpacing,
    color: DesignTokens.neutralGray,
  );
  
  /// Button text optimized for touch targets
  static TextStyle get button => TextStyle(
    fontFamily: primaryFont,
    fontSize: base,
    fontWeight: FontWeight.w600,
    height: tightLineHeight,
    letterSpacing: looseLetterSpacing,
  );
  
  /// Overline text for labels
  static TextStyle get overline => TextStyle(
    fontFamily: primaryFont,
    fontSize: xs,
    fontWeight: FontWeight.w600,
    height: tightLineHeight,
    letterSpacing: looseLetterSpacing * 2,
  );
  
  /// Monospace text for code and numbers
  static TextStyle get mono => TextStyle(
    fontFamily: monoFont,
    fontSize: base,
    fontWeight: FontWeight.w400,
    height: optimalLineHeight,
    letterSpacing: optimalLetterSpacing,
  );
}

/// Responsive typography that adapts to screen size
class ResponsiveTypography {
  /// Get responsive text style based on screen width
  static TextStyle getResponsiveStyle({
    required BuildContext context,
    required TextStyle baseStyle,
    double? mobileScale,
    double? tabletScale,
    double? desktopScale,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    double scale = 1.0;
    
    if (screenWidth < 768) {
      scale = mobileScale ?? 0.9;
    } else if (screenWidth < 1024) {
      scale = tabletScale ?? 1.0;
    } else {
      scale = desktopScale ?? 1.1;
    }
    
    return baseStyle.copyWith(
      fontSize: (baseStyle.fontSize ?? MobileTypography.base) * scale,
    );
  }
  
  /// Get optimal line height for reading
  static double getOptimalLineHeight(double fontSize) {
    // Smaller text needs more line height for readability
    if (fontSize < 14) return 1.6;
    if (fontSize < 18) return 1.5;
    if (fontSize < 24) return 1.4;
    return 1.3;
  }
  
  /// Get optimal letter spacing
  static double getOptimalLetterSpacing(double fontSize) {
    // Larger text can have tighter letter spacing
    if (fontSize > 24) return -0.5;
    if (fontSize > 18) return 0.0;
    return 0.25;
  }
}

/// Typography utilities for behavioral design
class TypographyUtils {
  /// Create emphasis through typography hierarchy
  static TextStyle emphasize(TextStyle baseStyle, {int level = 1}) {
    switch (level) {
      case 1:
        return baseStyle.copyWith(fontWeight: FontWeight.w600);
      case 2:
        return baseStyle.copyWith(
          fontWeight: FontWeight.w700,
          fontSize: (baseStyle.fontSize ?? MobileTypography.base) * 1.1,
        );
      case 3:
        return baseStyle.copyWith(
          fontWeight: FontWeight.w800,
          fontSize: (baseStyle.fontSize ?? MobileTypography.base) * 1.2,
          color: DesignTokens.primaryBlue,
        );
      default:
        return baseStyle;
    }
  }
  
  /// Create de-emphasis for secondary information
  static TextStyle deemphasize(TextStyle baseStyle) {
    return baseStyle.copyWith(
      fontWeight: FontWeight.w300,
      color: DesignTokens.neutralGray,
    );
  }
  
  /// Apply success styling
  static TextStyle success(TextStyle baseStyle) {
    return baseStyle.copyWith(
      color: DesignTokens.successGreen,
      fontWeight: FontWeight.w600,
    );
  }
  
  /// Apply warning styling
  static TextStyle warning(TextStyle baseStyle) {
    return baseStyle.copyWith(
      color: DesignTokens.urgentOrange,
      fontWeight: FontWeight.w600,
    );
  }
  
  /// Apply error styling
  static TextStyle error(TextStyle baseStyle) {
    return baseStyle.copyWith(
      color: DesignTokens.errorRed,
      fontWeight: FontWeight.w600,
    );
  }
  
  /// Calculate reading time based on text length
  static Duration calculateReadingTime(String text) {
    const wordsPerMinute = 200; // Average reading speed
    final wordCount = text.split(' ').length;
    final minutes = wordCount / wordsPerMinute;
    return Duration(milliseconds: (minutes * 60 * 1000).round());
  }
  
  /// Check if text is readable (contrast ratio)
  static bool isReadable(Color textColor, Color backgroundColor) {
    final textLuminance = textColor.computeLuminance();
    final bgLuminance = backgroundColor.computeLuminance();
    
    final lighter = textLuminance > bgLuminance ? textLuminance : bgLuminance;
    final darker = textLuminance > bgLuminance ? bgLuminance : textLuminance;
    
    final contrastRatio = (lighter + 0.05) / (darker + 0.05);
    return contrastRatio >= 4.5; // WCAG AA standard
  }
}

/// Dynamic typography loader for performance optimization
class DynamicTypographyLoader {
  static final Map<String, TextStyle> _styleCache = {};
  static final Map<String, Future<TextStyle>> _loadingStyles = {};
  
  /// Load typography style asynchronously
  static Future<TextStyle> loadStyle(String styleKey, TextStyle Function() styleBuilder) async {
    // Return cached style if available
    if (_styleCache.containsKey(styleKey)) {
      return _styleCache[styleKey]!;
    }
    
    // Return existing loading future if in progress
    if (_loadingStyles.containsKey(styleKey)) {
      return _loadingStyles[styleKey]!;
    }
    
    // Start loading
    final loadingFuture = _loadStyleAsync(styleKey, styleBuilder);
    _loadingStyles[styleKey] = loadingFuture;
    
    return loadingFuture;
  }
  
  static Future<TextStyle> _loadStyleAsync(String styleKey, TextStyle Function() styleBuilder) async {
    // Simulate font loading delay
    await Future.delayed(const Duration(milliseconds: 50));
    
    final style = styleBuilder();
    _styleCache[styleKey] = style;
    _loadingStyles.remove(styleKey);
    
    return style;
  }
  
  /// Preload critical typography styles
  static Future<void> preloadCriticalStyles() async {
    final criticalStyles = {
      'h1': () => MobileTypography.h1,
      'h2': () => MobileTypography.h2,
      'body1': () => MobileTypography.body1,
      'button': () => MobileTypography.button,
    };
    
    await Future.wait(
      criticalStyles.entries.map(
        (entry) => loadStyle(entry.key, entry.value),
      ),
    );
  }
  
  /// Clear typography cache
  static void clearCache() {
    _styleCache.clear();
    _loadingStyles.clear();
  }
}

/// Typography theme extension for Material Design
extension TypographyTheme on ThemeData {
  /// Get mobile-optimized text theme
  TextTheme get mobileTextTheme => TextTheme(
    displayLarge: MobileTypography.display1,
    displayMedium: MobileTypography.display2,
    headlineLarge: MobileTypography.h1,
    headlineMedium: MobileTypography.h2,
    headlineSmall: MobileTypography.h3,
    bodyLarge: MobileTypography.body1,
    bodyMedium: MobileTypography.body2,
    bodySmall: MobileTypography.caption,
    labelLarge: MobileTypography.button,
    labelMedium: MobileTypography.overline,
    labelSmall: MobileTypography.mono,
  );
}

/// Typography widget for consistent text rendering
class TypographyText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool adaptive;
  final double? mobileScale;
  final double? tabletScale;
  final double? desktopScale;
  
  const TypographyText(
    this.text, {
    super.key,
    required this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.adaptive = false,
    this.mobileScale,
    this.tabletScale,
    this.desktopScale,
  });
  
  @override
  Widget build(BuildContext context) {
    TextStyle finalStyle = style;
    
    if (adaptive) {
      finalStyle = ResponsiveTypography.getResponsiveStyle(
        context: context,
        baseStyle: style,
        mobileScale: mobileScale,
        tabletScale: tabletScale,
        desktopScale: desktopScale,
      );
    }
    
    return Text(
      text,
      style: finalStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}