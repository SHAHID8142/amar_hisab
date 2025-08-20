import 'package:flutter/material.dart';
import 'design_tokens.dart';

/// Responsive layout builder that adapts to screen size
class ResponsiveLayout extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenSize screenSize) builder;
  final EdgeInsetsGeometry? padding;
  final bool useSafeArea;
  
  const ResponsiveLayout({
    super.key,
    required this.builder,
    this.padding,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSize.fromWidth(MediaQuery.of(context).size.width);
    
    Widget child = builder(context, screenSize);
    
    if (padding != null) {
      child = Padding(padding: padding!, child: child);
    }
    
    if (useSafeArea) {
      child = SafeArea(child: child);
    }
    
    return child;
  }
}

/// Screen size enumeration based on breakpoints
enum ScreenSize {
  mobile,
  tablet,
  desktop,
  largeDesktop;
  
  factory ScreenSize.fromWidth(double width) {
    if (width < Breakpoints.tablet) return ScreenSize.mobile;
    if (width < Breakpoints.desktop) return ScreenSize.tablet;
    if (width < Breakpoints.largeDesktop) return ScreenSize.desktop;
    return ScreenSize.largeDesktop;
  }
  
  /// Gets the number of columns for this screen size
  int get columns {
    switch (this) {
      case ScreenSize.mobile:
        return GridSystem.mobileColumns;
      case ScreenSize.tablet:
        return GridSystem.tabletColumns;
      case ScreenSize.desktop:
      case ScreenSize.largeDesktop:
        return GridSystem.desktopColumns;
    }
  }
  
  /// Gets the maximum content width for this screen size
  double get maxContentWidth {
    switch (this) {
      case ScreenSize.mobile:
        return double.infinity;
      case ScreenSize.tablet:
        return 768.0;
      case ScreenSize.desktop:
        return 1024.0;
      case ScreenSize.largeDesktop:
        return 1440.0;
    }
  }
  
  /// Checks if this is a mobile screen size
  bool get isMobile => this == ScreenSize.mobile;
  
  /// Checks if this is a tablet screen size
  bool get isTablet => this == ScreenSize.tablet;
  
  /// Checks if this is a desktop screen size
  bool get isDesktop => this == ScreenSize.desktop || this == ScreenSize.largeDesktop;
}

/// Dynamic grid system that adapts to screen size
class DynamicGrid extends StatelessWidget {
  final List<Widget> children;
  final int? crossAxisCount;
  final double? childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  
  const DynamicGrid({
    super.key,
    required this.children,
    this.crossAxisCount,
    this.childAspectRatio,
    this.mainAxisSpacing = DesignTokens.spaceSM,
    this.crossAxisSpacing = DesignTokens.spaceSM,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      builder: (context, screenSize) {
        final columns = crossAxisCount ?? _getOptimalColumns(screenSize);
        
        return GridView.builder(
          padding: padding ?? const EdgeInsets.all(DesignTokens.spaceSM),
          physics: physics,
          shrinkWrap: shrinkWrap,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            childAspectRatio: childAspectRatio ?? 1.0,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
  
  int _getOptimalColumns(ScreenSize screenSize) {
    switch (screenSize) {
      case ScreenSize.mobile:
        return 2;
      case ScreenSize.tablet:
        return 3;
      case ScreenSize.desktop:
        return 4;
      case ScreenSize.largeDesktop:
        return 5;
    }
  }
}

/// Thumb-zone aware layout that positions content optimally
class ThumbZoneLayout extends StatelessWidget {
  final Widget? primaryZoneContent;
  final Widget? secondaryZoneContent;
  final Widget? tertiaryZoneContent;
  final bool showZoneIndicators;
  
  const ThumbZoneLayout({
    super.key,
    this.primaryZoneContent,
    this.secondaryZoneContent,
    this.tertiaryZoneContent,
    this.showZoneIndicators = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaHeight = screenHeight - 
        MediaQuery.of(context).padding.top - 
        MediaQuery.of(context).padding.bottom;
    
    final primaryZoneHeight = safeAreaHeight * DesignTokens.primaryZonePercent;
    final secondaryZoneHeight = safeAreaHeight * DesignTokens.secondaryZonePercent;
    final tertiaryZoneHeight = safeAreaHeight * DesignTokens.tertiaryZonePercent;
    
    return Column(
      children: [
        // Tertiary Zone (Top 25% - requires hand repositioning)
        if (tertiaryZoneContent != null)
          Container(
            height: tertiaryZoneHeight,
            width: double.infinity,
            decoration: showZoneIndicators ? BoxDecoration(
              color: Colors.red.withAlpha((255 * 0.1).round()),
              border: Border.all(color: Colors.red.withAlpha((255 * 0.3).round())),
            ) : null,
            child: tertiaryZoneContent,
          ),
        
        // Secondary Zone (Middle 50% - comfortable reach)
        if (secondaryZoneContent != null)
          Container(
            height: secondaryZoneHeight,
            width: double.infinity,
            decoration: showZoneIndicators ? BoxDecoration(
              color: Colors.orange.withAlpha((255 * 0.1).round()),
              border: Border.all(color: Colors.orange.withAlpha((255 * 0.3).round())),
            ) : null,
            child: secondaryZoneContent,
          ),
        
        // Primary Zone (Bottom 25% - most accessible)
        if (primaryZoneContent != null)
          Container(
            height: primaryZoneHeight,
            width: double.infinity,
            decoration: showZoneIndicators ? BoxDecoration(
              color: Colors.green.withAlpha((255 * 0.1).round()),
              border: Border.all(color: Colors.green.withAlpha((255 * 0.3).round())),
            ) : null,
            child: primaryZoneContent,
          ),
      ],
    );
  }
}

/// Adaptive container that responds to screen size
class AdaptiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Decoration? decoration;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;
  final bool centerOnDesktop;
  
  const AdaptiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.decoration,
    this.width,
    this.height,
    this.alignment,
    this.centerOnDesktop = true,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      builder: (context, screenSize) {
        EdgeInsetsGeometry? adaptivePadding = padding;
        EdgeInsetsGeometry? adaptiveMargin = margin;
        double? adaptiveWidth = width;
        
        // Adjust padding based on screen size
        if (adaptivePadding == null) {
          switch (screenSize) {
            case ScreenSize.mobile:
              adaptivePadding = const EdgeInsets.all(DesignTokens.spaceSM);
              break;
            case ScreenSize.tablet:
              adaptivePadding = const EdgeInsets.all(DesignTokens.spaceMD);
              break;
            case ScreenSize.desktop:
            case ScreenSize.largeDesktop:
              adaptivePadding = const EdgeInsets.all(DesignTokens.spaceLG);
              break;
          }
        }
        
        // Limit width on desktop if centering is enabled
        if (centerOnDesktop && screenSize.isDesktop) {
          adaptiveWidth = screenSize.maxContentWidth;
        }
        
        Widget container = Container(
          width: adaptiveWidth,
          height: height,
          padding: adaptivePadding,
          margin: adaptiveMargin,
          alignment: alignment,
          color: color,
          decoration: decoration,
          child: child,
        );
        
        // Center on desktop if enabled
        if (centerOnDesktop && screenSize.isDesktop) {
          container = Center(child: container);
        }
        
        return container;
      },
    );
  }
}

/// Responsive text that scales with screen size
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? scaleFactor;
  
  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.scaleFactor,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      builder: (context, screenSize) {
        double scale = scaleFactor ?? _getScaleFactor(screenSize);
        
        return Text(
          text,
          style: style?.copyWith(
            fontSize: (style?.fontSize ?? DesignTokens.bodySize) * scale,
          ),
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }
  
  double _getScaleFactor(ScreenSize screenSize) {
    switch (screenSize) {
      case ScreenSize.mobile:
        return 1.0;
      case ScreenSize.tablet:
        return 1.1;
      case ScreenSize.desktop:
        return 1.2;
      case ScreenSize.largeDesktop:
        return 1.3;
    }
  }
}

/// Responsive spacing that adapts to screen size
class ResponsiveSpacing extends StatelessWidget {
  final double mobile;
  final double? tablet;
  final double? desktop;
  final Axis axis;
  
  const ResponsiveSpacing({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.axis = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      builder: (context, screenSize) {
        double spacing;
        
        switch (screenSize) {
          case ScreenSize.mobile:
            spacing = mobile;
            break;
          case ScreenSize.tablet:
            spacing = tablet ?? mobile * 1.2;
            break;
          case ScreenSize.desktop:
          case ScreenSize.largeDesktop:
            spacing = desktop ?? mobile * 1.5;
            break;
        }
        
        return SizedBox(
          width: axis == Axis.horizontal ? spacing : null,
          height: axis == Axis.vertical ? spacing : null,
        );
      },
    );
  }
}

/// Layout utilities for responsive design
class LayoutUtils {
  /// Gets the optimal number of columns for a grid based on screen width
  static int getOptimalColumns(BuildContext context, {
    int mobileColumns = 1,
    int tabletColumns = 2,
    int desktopColumns = 3,
  }) {
    final screenSize = ScreenSize.fromWidth(MediaQuery.of(context).size.width);
    
    switch (screenSize) {
      case ScreenSize.mobile:
        return mobileColumns;
      case ScreenSize.tablet:
        return tabletColumns;
      case ScreenSize.desktop:
      case ScreenSize.largeDesktop:
        return desktopColumns;
    }
  }
  
  /// Gets responsive padding based on screen size
  static EdgeInsetsGeometry getResponsivePadding(BuildContext context, {
    EdgeInsetsGeometry? mobile,
    EdgeInsetsGeometry? tablet,
    EdgeInsetsGeometry? desktop,
  }) {
    final screenSize = ScreenSize.fromWidth(MediaQuery.of(context).size.width);
    
    switch (screenSize) {
      case ScreenSize.mobile:
        return mobile ?? const EdgeInsets.all(DesignTokens.spaceSM);
      case ScreenSize.tablet:
        return tablet ?? const EdgeInsets.all(DesignTokens.spaceMD);
      case ScreenSize.desktop:
      case ScreenSize.largeDesktop:
        return desktop ?? const EdgeInsets.all(DesignTokens.spaceLG);
    }
  }
  
  /// Checks if the current screen is in thumb-zone friendly size
  static bool isThumbZoneFriendly(BuildContext context) {
    final screenSize = ScreenSize.fromWidth(MediaQuery.of(context).size.width);
    return screenSize.isMobile;
  }
  
  /// Gets the safe area height for thumb-zone calculations
  static double getSafeAreaHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.height - 
           mediaQuery.padding.top - 
           mediaQuery.padding.bottom;
  }
  
  /// Gets the primary zone height (bottom 25%)
  static double getPrimaryZoneHeight(BuildContext context) {
    return getSafeAreaHeight(context) * DesignTokens.primaryZonePercent;
  }
  
  /// Gets the secondary zone height (middle 50%)
  static double getSecondaryZoneHeight(BuildContext context) {
    return getSafeAreaHeight(context) * DesignTokens.secondaryZonePercent;
  }
  
  /// Gets the tertiary zone height (top 25%)
  static double getTertiaryZoneHeight(BuildContext context) {
    return getSafeAreaHeight(context) * DesignTokens.tertiaryZonePercent;
  }
}

/// Extension methods for responsive design
extension ResponsiveExtensions on BuildContext {
  /// Gets the current screen size
  ScreenSize get screenSize => ScreenSize.fromWidth(MediaQuery.of(this).size.width);
  
  /// Checks if the current screen is mobile
  bool get isMobile => screenSize.isMobile;
  
  /// Checks if the current screen is tablet
  bool get isTablet => screenSize.isTablet;
  
  /// Checks if the current screen is desktop
  bool get isDesktop => screenSize.isDesktop;
  
  /// Gets responsive value based on screen size
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    switch (screenSize) {
      case ScreenSize.mobile:
        return mobile;
      case ScreenSize.tablet:
        return tablet ?? mobile;
      case ScreenSize.desktop:
      case ScreenSize.largeDesktop:
        return desktop ?? tablet ?? mobile;
    }
  }
}