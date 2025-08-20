import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'design_tokens.dart';

/// Accessible button with comprehensive semantic support
class AccessibleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final String? semanticLabel;
  final String? tooltip;
  final bool isDestructive;
  final bool isPrimary;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? minWidth;
  final double? minHeight;
  
  const AccessibleButton({
    super.key,
    required this.child,
    this.onPressed,
    this.semanticLabel,
    this.tooltip,
    this.isDestructive = false,
    this.isPrimary = false,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
    this.minWidth,
    this.minHeight,
  });

  @override
  State<AccessibleButton> createState() => _AccessibleButtonState();
}

class _AccessibleButtonState extends State<AccessibleButton> {
  bool _isFocused = false;
  bool _isHovered = false;
  
  Color get _backgroundColor {
    if (widget.backgroundColor != null) return widget.backgroundColor!;
    
    if (widget.isDestructive) {
      return widget.onPressed != null 
          ? DesignTokens.errorRed 
          : DesignTokens.errorRed.withAlpha((255 * DesignTokens.opacityDisabled).round());
    }
    
    if (widget.isPrimary) {
      return widget.onPressed != null 
          ? DesignTokens.primaryBlue 
          : DesignTokens.primaryBlue.withAlpha((255 * DesignTokens.opacityDisabled).round());
    }
    
    return widget.onPressed != null 
        ? DesignTokens.neutralGray 
        : DesignTokens.neutralGray.withAlpha((255 * DesignTokens.opacityDisabled).round());
  }
  
  Color get _foregroundColor {
    if (widget.foregroundColor != null) return widget.foregroundColor!;
    
    return widget.onPressed != null 
        ? Colors.white 
        : Colors.white.withAlpha((255 * DesignTokens.opacityDisabled).round());
  }
  
  void _handleFocusChange(bool hasFocus) {
    setState(() => _isFocused = hasFocus);
  }
  
  void _handleHoverChange(bool isHovered) {
    setState(() => _isHovered = isHovered);
  }

  @override
  Widget build(BuildContext context) {
    final button = Focus(
      onFocusChange: _handleFocusChange,
      child: MouseRegion(
        onEnter: (_) => _handleHoverChange(true),
        onExit: (_) => _handleHoverChange(false),
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Semantics(
            button: true,
            enabled: widget.onPressed != null,
            label: widget.semanticLabel,
            hint: widget.tooltip,
            child: Container(
              constraints: BoxConstraints(
                minWidth: widget.minWidth ?? DesignTokens.minTouchTarget,
                minHeight: widget.minHeight ?? DesignTokens.minTouchTarget,
              ),
              padding: widget.padding ?? const EdgeInsets.symmetric(
                horizontal: DesignTokens.spaceMD,
                vertical: DesignTokens.spaceSM,
              ),
              decoration: BoxDecoration(
                color: _backgroundColor,
                borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
                border: _isFocused 
                    ? Border.all(
                        color: Theme.of(context).focusColor,
                        width: 2.0,
                      )
                    : null,
                boxShadow: _isHovered && widget.onPressed != null
                    ? [
                        BoxShadow(
                          color: Colors.black.withAlpha((255 * 0.15).round()),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  color: _foregroundColor,
                  fontWeight: FontWeight.w600,
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
    
    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: button,
      );
    }
    
    return button;
  }
}

/// Accessible text field with enhanced semantic support
class AccessibleTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final String? semanticLabel;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  
  const AccessibleTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.semanticLabel,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  State<AccessibleTextField> createState() => _AccessibleTextFieldState();
}

class _AccessibleTextFieldState extends State<AccessibleTextField> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      enabled: widget.enabled,
      label: widget.semanticLabel ?? widget.labelText,
      hint: widget.hintText,
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        readOnly: widget.readOnly,
        enabled: widget.enabled,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        style: TextStyle(
          fontSize: DesignTokens.bodySize,
          color: widget.enabled
              ? Theme.of(context).textTheme.bodyLarge?.color
              : Theme.of(context).disabledColor,
        ),
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          helperText: widget.helperText,
          errorText: widget.errorText,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
            borderSide: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
            borderSide: const BorderSide(
              color: DesignTokens.errorRed,
              width: 2.0,
            ),
          ),
          contentPadding: const EdgeInsets.all(DesignTokens.spaceMD),
        ),
      ),
    );
  }
}

/// Accessible card with proper semantic structure
class AccessibleCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final String? tooltip;
  final bool isInteractive;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? elevation;
  
  const AccessibleCard({
    super.key,
    required this.child,
    this.onTap,
    this.semanticLabel,
    this.tooltip,
    this.isInteractive = false,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
  });

  @override
  State<AccessibleCard> createState() => _AccessibleCardState();
}

class _AccessibleCardState extends State<AccessibleCard> {
  bool _isFocused = false;
  bool _isHovered = false;
  
  void _handleFocusChange(bool hasFocus) {
    setState(() => _isFocused = hasFocus);
  }
  
  void _handleHoverChange(bool isHovered) {
    setState(() => _isHovered = isHovered);
  }

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(DesignTokens.radiusLG),
        border: _isFocused 
            ? Border.all(
                color: Theme.of(context).focusColor,
                width: 2.0,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * (_isHovered ? 0.12 : 0.08)).round()),
            blurRadius: _isHovered ? 8 : 4,
            offset: Offset(0, _isHovered ? 4 : 2),
          ),
        ],
      ),
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.all(DesignTokens.spaceMD),
        child: widget.child,
      ),
    );
    
    if (widget.isInteractive || widget.onTap != null) {
      card = Focus(
        onFocusChange: _handleFocusChange,
        child: MouseRegion(
          onEnter: (_) => _handleHoverChange(true),
          onExit: (_) => _handleHoverChange(false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: Semantics(
              button: widget.onTap != null,
              container: true,
              label: widget.semanticLabel,
              hint: widget.tooltip,
              child: card,
            ),
          ),
        ),
      );
    } else {
      card = Semantics(
        container: true,
        label: widget.semanticLabel,
        child: card,
      );
    }
    
    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: card,
      );
    }
    
    return card;
  }
}

/// Accessible list item with proper semantic structure
class AccessibleListItem extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final String? semanticValue;
  final bool isSelected;
  final bool isEnabled;
  final Widget? leading;
  final Widget? trailing;
  
  const AccessibleListItem({
    super.key,
    required this.child,
    this.onTap,
    this.semanticLabel,
    this.semanticValue,
    this.isSelected = false,
    this.isEnabled = true,
    this.leading,
    this.trailing,
  });

  @override
  State<AccessibleListItem> createState() => _AccessibleListItemState();
}

class _AccessibleListItemState extends State<AccessibleListItem> {
  bool _isFocused = false;
  
  void _handleFocusChange(bool hasFocus) {
    setState(() => _isFocused = hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: _handleFocusChange,
      child: GestureDetector(
        onTap: widget.isEnabled ? widget.onTap : null,
        child: Semantics(
          button: widget.onTap != null,
          selected: widget.isSelected,
          enabled: widget.isEnabled,
          label: widget.semanticLabel,
          value: widget.semanticValue,
          child: Container(
            constraints: const BoxConstraints(
              minHeight: DesignTokens.minTouchTarget,
            ),
            decoration: BoxDecoration(
              color: widget.isSelected 
                  ? Theme.of(context).primaryColor.withAlpha((255 * 0.1).round())
                  : null,
              border: _isFocused 
                  ? Border.all(
                      color: Theme.of(context).focusColor,
                      width: 2.0,
                    )
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spaceMD,
                vertical: DesignTokens.spaceSM,
              ),
              child: Row(
                children: [
                  if (widget.leading != null) ...[
                    widget.leading!,
                    const SizedBox(width: DesignTokens.spaceSM),
                  ],
                  Expanded(child: widget.child),
                  if (widget.trailing != null) ...[
                    const SizedBox(width: DesignTokens.spaceSM),
                    widget.trailing!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Accessible icon with semantic support
class AccessibleIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;
  final bool excludeFromSemantics;
  
  const AccessibleIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
    this.excludeFromSemantics = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      excludeSemantics: excludeFromSemantics,
      child: Icon(
        icon,
        size: size,
        color: color,
      ),
    );
  }
}

/// Accessible progress indicator with semantic updates
class AccessibleProgressIndicator extends StatefulWidget {
  final double? value;
  final String? semanticLabel;
  final String? semanticValue;
  final Color? backgroundColor;
  final Color? valueColor;
  final double strokeWidth;
  
  const AccessibleProgressIndicator({
    super.key,
    this.value,
    this.semanticLabel,
    this.semanticValue,
    this.backgroundColor,
    this.valueColor,
    this.strokeWidth = 4.0,
  });

  @override
  State<AccessibleProgressIndicator> createState() => _AccessibleProgressIndicatorState();
}

class _AccessibleProgressIndicatorState extends State<AccessibleProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    final progressValue = widget.value != null 
        ? '${(widget.value! * 100).round()}% complete'
        : 'Loading';
    
    return Semantics(
      label: widget.semanticLabel ?? 'Progress indicator',
      value: widget.semanticValue ?? progressValue,
      child: CircularProgressIndicator(
        value: widget.value,
        backgroundColor: widget.backgroundColor,
        valueColor: widget.valueColor != null 
            ? AlwaysStoppedAnimation(widget.valueColor!)
            : null,
        strokeWidth: widget.strokeWidth,
      ),
    );
  }
}

/// Accessibility utilities and helpers
class AccessibilityUtils {
  /// Announces a message to screen readers
  static void announce(String message, {TextDirection? textDirection}) {
    SemanticsService.announce(
      message,
      textDirection ?? TextDirection.ltr,
    );
  }
  
  /// Checks if high contrast mode is enabled
  static bool isHighContrastEnabled(BuildContext context) {
    return MediaQuery.of(context).highContrast;
  }
  
  /// Checks if animations are disabled
  static bool areAnimationsDisabled(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }
  
  /// Gets the text scale factor
  static double getTextScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaler.scale(1.0);
  }
  
  /// Checks if the device is using a screen reader
  static bool isScreenReaderEnabled(BuildContext context) {
    return MediaQuery.of(context).accessibleNavigation;
  }
  
  /// Calculates contrast ratio between two colors
  static double calculateContrastRatio(Color color1, Color color2) {
    final luminance1 = color1.computeLuminance();
    final luminance2 = color2.computeLuminance();
    
    final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
    final darker = luminance1 > luminance2 ? luminance2 : luminance1;
    
    return (lighter + 0.05) / (darker + 0.05);
  }
  
  /// Checks if color combination meets WCAG AA standards
  static bool meetsWCAGAA(Color foreground, Color background) {
    return calculateContrastRatio(foreground, background) >= 4.5;
  }
  
  /// Checks if color combination meets WCAG AAA standards
  static bool meetsWCAGAAA(Color foreground, Color background) {
    return calculateContrastRatio(foreground, background) >= 7.0;
  }
  
  /// Gets an accessible color that meets contrast requirements
  static Color getAccessibleColor(Color background, {bool preferDark = true}) {
    final darkColor = Colors.black;
    final lightColor = Colors.white;
    
    if (preferDark && meetsWCAGAA(darkColor, background)) {
      return darkColor;
    } else if (meetsWCAGAA(lightColor, background)) {
      return lightColor;
    } else {
      return preferDark ? darkColor : lightColor;
    }
  }
  
  /// Adjusts font size based on accessibility settings
  static double getAccessibleFontSize(BuildContext context, double baseFontSize) {
    final textScaleFactor = getTextScaleFactor(context);
    return baseFontSize * textScaleFactor.clamp(0.8, 2.0);
  }
  
  /// Creates accessible touch targets
  static BoxConstraints getAccessibleConstraints({
    double? minWidth,
    double? minHeight,
  }) {
    return BoxConstraints(
      minWidth: minWidth ?? DesignTokens.minTouchTarget,
      minHeight: minHeight ?? DesignTokens.minTouchTarget,
    );
  }
  
  /// Provides haptic feedback for accessibility
  static void provideAccessibilityFeedback() {
    HapticFeedback.selectionClick();
  }
}

/// Accessibility focus manager
class AccessibilityFocusManager {
  
  /// Requests focus for a specific widget
  static void requestFocus(FocusNode focusNode) {
    focusNode.requestFocus();
  }
  
  /// Moves focus to the next focusable widget
  static void focusNext(BuildContext context) {
    FocusScope.of(context).nextFocus();
  }
  
  /// Moves focus to the previous focusable widget
  static void focusPrevious(BuildContext context) {
    FocusScope.of(context).previousFocus();
  }
  
  /// Unfocuses the current widget
  static void unfocus(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
  
  /// Gets the currently focused widget
  static FocusNode? getCurrentFocus(BuildContext context) {
    return FocusScope.of(context).focusedChild;
  }
}

/// Accessibility theme extensions
class AccessibilityTheme {
  /// Creates a high contrast theme
  static ThemeData createHighContrastTheme({
    required Brightness brightness,
  }) {
    final isDark = brightness == Brightness.dark;
    
    return ThemeData(
      brightness: brightness,
      primaryColor: isDark ? Colors.white : Colors.black,
      scaffoldBackgroundColor: isDark ? Colors.black : Colors.white,
      cardColor: isDark ? Colors.grey[900] : Colors.grey[100],
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: DesignTokens.bodySize,
        ),
        bodyMedium: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: DesignTokens.bodySize,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: isDark ? Colors.black : Colors.white,
          backgroundColor: isDark ? Colors.white : Colors.black,
          minimumSize: const Size(
            DesignTokens.minTouchTarget,
            DesignTokens.minTouchTarget,
          ),
        ),
      ),
    );
  }
  
  /// Creates a theme optimized for large text
  static ThemeData createLargeTextTheme({
    required ThemeData baseTheme,
    double scaleFactor = 1.3,
  }) {
    return baseTheme.copyWith(
      textTheme: baseTheme.textTheme.apply(
        fontSizeFactor: scaleFactor,
      ),
    );
  }
}