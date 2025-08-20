import 'package:flutter/material.dart';
import 'design_tokens.dart';
import 'gesture_components.dart';

/// Screen zones based on thumb reachability studies
class ThumbZoneLayout extends StatelessWidget {
  final Widget? primaryZoneContent;
  final Widget? secondaryZoneContent;
  final Widget? tertiaryZoneContent;
  final EdgeInsets? padding;
  final bool adaptToKeyboard;
  final ScrollController? scrollController;
  
  const ThumbZoneLayout({
    super.key,
    this.primaryZoneContent,
    this.secondaryZoneContent,
    this.tertiaryZoneContent,
    this.padding,
    this.adaptToKeyboard = true,
    this.scrollController,
  });
  
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final availableHeight = screenHeight - keyboardHeight;
    
    // Calculate zone heights based on ergonomic studies
    final primaryZoneHeight = availableHeight * DesignTokens.primaryZonePercent;
    final tertiaryZoneHeight = availableHeight * DesignTokens.tertiaryZonePercent;
    
    return Column(
      children: [
        // Tertiary Zone (Top 25% - requires repositioning)
        if (tertiaryZoneContent != null)
          Container(
            height: tertiaryZoneHeight,
            width: double.infinity,
            padding: padding,
            child: tertiaryZoneContent!,
          ),
        
        // Secondary Zone (Middle 50% - comfortable reach)
        if (secondaryZoneContent != null)
          Expanded(
            child: Container(
              width: double.infinity,
              padding: padding,
              child: secondaryZoneContent!,
            ),
          ),
        
        // Primary Zone (Bottom 25% - most accessible)
        if (primaryZoneContent != null)
          Container(
            height: primaryZoneHeight,
            width: double.infinity,
            padding: padding,
            child: primaryZoneContent!,
          ),
      ],
    );
  }
}

/// Adaptive navigation bar that positions based on thumb zones
class ThumbZoneNavigation extends StatefulWidget {
  final List<ThumbZoneNavItem> items;
  final int currentIndex;
  final Function(int) onTap;
  final bool showLabels;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  
  const ThumbZoneNavigation({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.showLabels = true,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
  });
  
  @override
  State<ThumbZoneNavigation> createState() => _ThumbZoneNavigationState();
}

class _ThumbZoneNavigationState extends State<ThumbZoneNavigation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: DesignTokens.durationQuick,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  void _handleTap(int index) {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    widget.onTap(index);
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: DesignTokens.comfortableTouchTarget + DesignTokens.spaceMD,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? DesignTokens.daySurface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.1).round()),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: widget.items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = index == widget.currentIndex;
            
            return Expanded(
              child: AdvancedGestureDetector(
                onTap: () => _handleTap(index),
                thumbZone: ThumbZone.primary,
                child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: isSelected ? _scaleAnimation.value : 1.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            item.icon,
                            color: isSelected
                                ? (widget.selectedItemColor ?? DesignTokens.primaryBlue)
                                : (widget.unselectedItemColor ?? DesignTokens.neutralGray),
                            size: 24,
                          ),
                          if (widget.showLabels) ...[
                            const SizedBox(height: 4),
                            Text(
                              item.label,
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected
                                    ? (widget.selectedItemColor ?? DesignTokens.primaryBlue)
                                    : (widget.unselectedItemColor ?? DesignTokens.neutralGray),
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Navigation item for thumb-zone navigation
class ThumbZoneNavItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  
  const ThumbZoneNavItem({
    required this.icon,
    required this.label,
    this.onTap,
  });
}

/// Floating action button positioned in optimal thumb zone
class ThumbZoneFAB extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? tooltip;
  final bool mini;
  final ThumbZonePosition position;
  
  const ThumbZoneFAB({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
    this.mini = false,
    this.position = ThumbZonePosition.bottomRight,
  });
  
  @override
  State<ThumbZoneFAB> createState() => _ThumbZoneFABState();
}

class _ThumbZoneFABState extends State<ThumbZoneFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: DesignTokens.durationModerate,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _handlePress() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
    widget.onPressed();
  }
  
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: _getBottomPosition(),
      right: _getRightPosition(),
      left: _getLeftPosition(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: FloatingActionButton(
                onPressed: _handlePress,
                backgroundColor: widget.backgroundColor ?? DesignTokens.primaryBlue,
                foregroundColor: widget.foregroundColor ?? Colors.white,
                tooltip: widget.tooltip,
                mini: widget.mini,
                child: widget.child,
              ),
            ),
          );
        },
      ),
    );
  }
  
  double? _getBottomPosition() {
    switch (widget.position) {
      case ThumbZonePosition.bottomRight:
      case ThumbZonePosition.bottomLeft:
        return DesignTokens.spaceLG;
      case ThumbZonePosition.centerRight:
      case ThumbZonePosition.centerLeft:
        return null;
    }
  }
  
  double? _getRightPosition() {
    switch (widget.position) {
      case ThumbZonePosition.bottomRight:
      case ThumbZonePosition.centerRight:
        return DesignTokens.spaceLG;
      default:
        return null;
    }
  }
  
  double? _getLeftPosition() {
    switch (widget.position) {
      case ThumbZonePosition.bottomLeft:
      case ThumbZonePosition.centerLeft:
        return DesignTokens.spaceLG;
      default:
        return null;
    }
  }
}

/// Positions for thumb-zone optimized FAB
enum ThumbZonePosition {
  bottomRight,
  bottomLeft,
  centerRight,
  centerLeft,
}

/// Adaptive card that responds to thumb interaction patterns
class ThumbZoneCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final ThumbZone thumbZone;
  
  const ThumbZoneCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.thumbZone = ThumbZone.secondary,
  });
  
  @override
  State<ThumbZoneCard> createState() => _ThumbZoneCardState();
}

class _ThumbZoneCardState extends State<ThumbZoneCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _elevationAnimation;
  late Animation<Color?> _colorAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: DesignTokens.durationQuick,
      vsync: this,
    );
    _elevationAnimation = Tween<double>(
      begin: widget.elevation ?? DesignTokens.elevation1,
      end: (widget.elevation ?? DesignTokens.elevation1) + 4,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _colorAnimation = ColorTween(
      begin: widget.backgroundColor ?? DesignTokens.daySurface,
      end: (widget.backgroundColor ?? DesignTokens.daySurface).withAlpha((255 * 0.9).round()),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? EdgeInsets.all(DesignTokens.spaceSM),
      child: AdvancedGestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        thumbZone: widget.thumbZone,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Material(
              elevation: _elevationAnimation.value,
              color: _colorAnimation.value,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(DesignTokens.radiusMD),
              child: Container(
                padding: widget.padding ?? EdgeInsets.all(DesignTokens.spaceMD),
                child: widget.child,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Utility class for thumb-zone calculations
class ThumbZoneUtils {
  /// Calculate if a point is within comfortable thumb reach
  static bool isInThumbZone(Offset point, Size screenSize, {bool isLeftHanded = false}) {
    final thumbReachRadius = screenSize.width * 0.4; // 40% of screen width
    final thumbOrigin = isLeftHanded
        ? Offset(0, screenSize.height * 0.8) // Bottom-left for left-handed
        : Offset(screenSize.width, screenSize.height * 0.8); // Bottom-right for right-handed
    
    final distance = (point - thumbOrigin).distance;
    return distance <= thumbReachRadius;
  }
  
  /// Get optimal position for UI element based on thumb zone
  static Offset getOptimalPosition(Size screenSize, ThumbZone zone, {bool isLeftHanded = false}) {
    switch (zone) {
      case ThumbZone.primary:
        return isLeftHanded
            ? Offset(screenSize.width * 0.2, screenSize.height * 0.85)
            : Offset(screenSize.width * 0.8, screenSize.height * 0.85);
      case ThumbZone.secondary:
        return Offset(screenSize.width * 0.5, screenSize.height * 0.6);
      case ThumbZone.tertiary:
        return Offset(screenSize.width * 0.5, screenSize.height * 0.2);
    }
  }
  
  /// Calculate touch target size based on thumb zone
  static double getTouchTargetSize(ThumbZone zone) {
    switch (zone) {
      case ThumbZone.primary:
        return DesignTokens.comfortableTouchTarget;
      case ThumbZone.secondary:
        return DesignTokens.minTouchTarget;
      case ThumbZone.tertiary:
        return DesignTokens.androidMinTouchTarget;
    }
  }
}