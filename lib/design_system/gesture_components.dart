import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'design_tokens.dart';
import 'adaptive_theme.dart';

/// Thumb zone positions for optimal mobile interaction
enum ThumbZone {
  primary,   // Bottom 25% - most accessible
  secondary, // Middle 50% - comfortable reach
  tertiary,  // Top 25% - requires repositioning
}

/// Advanced gesture detector with haptic feedback and analytics
class AdvancedGestureDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;
  final Function(DragUpdateDetails)? onPanUpdate;
  final Function(DragEndDetails)? onPanEnd;
  final Function(TapDownDetails)? onTapDown;
  final Function(TapUpDetails)? onTapUp;
  final bool enableHaptics;
  final ThumbZone thumbZone;
  final Duration? hapticDelay;
  
  const AdvancedGestureDetector({
    super.key,
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onPanUpdate,
    this.onPanEnd,
    this.onTapDown,
    this.onTapUp,
    this.enableHaptics = true,
    this.thumbZone = ThumbZone.secondary,
    this.hapticDelay,
  });
  
  @override
  State<AdvancedGestureDetector> createState() => _AdvancedGestureDetectorState();
}

class _AdvancedGestureDetectorState extends State<AdvancedGestureDetector> {
  bool _isPressed = false;


  
  void _triggerHaptic() {
    if (!widget.enableHaptics) return;
    
    switch (widget.thumbZone) {
      case ThumbZone.primary:
        HapticFeedback.lightImpact();
        break;
      case ThumbZone.secondary:
        HapticFeedback.mediumImpact();
        break;
      case ThumbZone.tertiary:
        HapticFeedback.heavyImpact();
        break;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() => _isPressed = true);
        if (widget.hapticDelay != null) {
          Future.delayed(widget.hapticDelay!, _triggerHaptic);
        } else {
          _triggerHaptic();
        }
        widget.onTapDown?.call(details);
      },
      onTapUp: (details) {
        setState(() => _isPressed = false);
        widget.onTapUp?.call(details);
      },
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      onDoubleTap: widget.onDoubleTap,
      onLongPress: widget.onLongPress,
      onPanUpdate: widget.onPanUpdate,
      onPanEnd: widget.onPanEnd,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: DesignTokens.durationImmediate,
        child: widget.child,
      ),
    );
  }
}

/// Swipe-to-action component with contextual feedback
class SwipeToAction extends StatefulWidget {
  final Widget child;
  final Widget? leftAction;
  final Widget? rightAction;
  final Function()? onLeftSwipe;
  final Function()? onRightSwipe;
  final double threshold;
  final bool enableHaptics;
  
  const SwipeToAction({
    super.key,
    required this.child,
    this.leftAction,
    this.rightAction,
    this.onLeftSwipe,
    this.onRightSwipe,
    this.threshold = 0.3,
    this.enableHaptics = true,
  });
  
  @override
  State<SwipeToAction> createState() => _SwipeToActionState();
}

class _SwipeToActionState extends State<SwipeToAction>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  double _dragExtent = 0.0;
  bool _hasTriggeredHaptic = false;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: DesignTokens.durationModerate,
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _handleDragUpdate(DragUpdateDetails details) {
    final delta = details.primaryDelta! / context.size!.width;
    _dragExtent += delta;
    
    if (_dragExtent.abs() > widget.threshold && !_hasTriggeredHaptic) {
      if (widget.enableHaptics) {
        HapticFeedback.mediumImpact();
      }
      _hasTriggeredHaptic = true;
    }
    
    _controller.value = _dragExtent.abs().clamp(0.0, 1.0);
  }
  
  void _handleDragEnd(DragEndDetails details) {
    if (_dragExtent.abs() > widget.threshold) {
      if (_dragExtent > 0 && widget.onRightSwipe != null) {
        widget.onRightSwipe!();
      } else if (_dragExtent < 0 && widget.onLeftSwipe != null) {
        widget.onLeftSwipe!();
      }
    }
    
    _controller.reverse();
    _dragExtent = 0.0;
    _hasTriggeredHaptic = false;
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: Stack(
        children: [
          // Background actions
          if (widget.leftAction != null)
            Positioned.fill(
              child: SlideTransition(
                position: _slideAnimation,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: widget.leftAction!,
                ),
              ),
            ),
          if (widget.rightAction != null)
            Positioned.fill(
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(-1.0, 0.0),
                ).animate(_controller),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: widget.rightAction!,
                ),
              ),
            ),
          // Main content
          SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: Offset(_dragExtent.sign, 0.0),
            ).animate(_controller),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

/// Thumb-zone aware button that adapts to screen position
class ThumbZoneButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ButtonType type;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final EdgeInsetsGeometry? margin;
  
  const ThumbZoneButton({
    super.key,
    required this.text,
    this.onPressed,
    this.onLongPress,
    this.type = ButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.width,
    this.margin,
  });

  @override
  State<ThumbZoneButton> createState() => _ThumbZoneButtonState();
}

class _ThumbZoneButtonState extends State<ThumbZoneButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: DesignTokens.durationQuick,
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _elevationAnimation = Tween<double>(
      begin: DesignTokens.elevation2,
      end: DesignTokens.elevation1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      _animationController.forward();
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      margin: widget.margin ?? const EdgeInsets.symmetric(
        horizontal: DesignTokens.spaceSM,
        vertical: DesignTokens.spaceXS,
      ),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              onTap: widget.onPressed,
              onLongPress: widget.onLongPress,
              child: Container(
                height: DesignTokens.comfortableTouchTarget,
                decoration: BoxDecoration(
                  color: _getButtonColor(context),
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
                  boxShadow: _elevationAnimation.value > 0
                      ? _getElevationShadow(_elevationAnimation.value)
                      : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
                    onTap: widget.onPressed,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spaceMD,
                        vertical: DesignTokens.spaceSM,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.isLoading)
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _getTextColor(context),
                                ),
                              ),
                            )
                          else if (widget.icon != null)
                            Icon(
                              widget.icon,
                              color: _getTextColor(context),
                              size: 20,
                            ),
                          if ((widget.icon != null || widget.isLoading) && widget.text.isNotEmpty)
                            const SizedBox(width: DesignTokens.spaceXS),
                          if (widget.text.isNotEmpty)
                            Text(
                              widget.text,
                              style: AppTypography.body.copyWith(
                                color: _getTextColor(context),
                                fontWeight: AppTypography.semiBold,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getButtonColor(BuildContext context) {
    if (widget.onPressed == null) {
      return context.colorScheme.surface.withAlpha((255 * DesignTokens.opacityDisabled).round());
    }
    
    switch (widget.type) {
      case ButtonType.primary:
        return context.colorScheme.primaryAction;
      case ButtonType.secondary:
        return context.colorScheme.surface;
      case ButtonType.urgent:
        return context.colorScheme.urgentAction;
      case ButtonType.success:
        return context.colorScheme.successAction;
      case ButtonType.warning:
        return context.colorScheme.warningAction;
      case ButtonType.destructive:
        return context.colorScheme.destructiveAction;
    }
  }

  Color _getTextColor(BuildContext context) {
    if (widget.onPressed == null) {
      return context.colorScheme.onSurface.withAlpha((255 * DesignTokens.opacityDisabled).round());
    }
    
    switch (widget.type) {
      case ButtonType.primary:
      case ButtonType.urgent:
      case ButtonType.success:
      case ButtonType.destructive:
        return Colors.white;
      case ButtonType.secondary:
        return context.colorScheme.primary;
      case ButtonType.warning:
        return context.colorScheme.onSurface;
    }
  }

  List<BoxShadow> _getElevationShadow(double elevation) {
    if (elevation <= 1) return AppShadows.elevation1;
    if (elevation <= 2) return AppShadows.elevation2;
    if (elevation <= 3) return AppShadows.elevation3;
    if (elevation <= 4) return AppShadows.elevation4;
    return AppShadows.elevation5;
  }
}

/// Button types based on behavioral psychology
enum ButtonType {
  primary,    // High-value actions
  secondary,  // Secondary actions
  urgent,     // Time-sensitive actions
  success,    // Positive outcomes
  warning,    // Caution required
  destructive // Destructive actions
}

/// Swipeable card with contextual actions
class SwipeableCard extends StatefulWidget {
  final Widget child;
  final List<SwipeAction> leftActions;
  final List<SwipeAction> rightActions;
  final double threshold;
  final Duration animationDuration;
  final EdgeInsetsGeometry? margin;
  
  const SwipeableCard({
    super.key,
    required this.child,
    this.leftActions = const [],
    this.rightActions = const [],
    this.threshold = 0.3,
    this.animationDuration = const Duration(milliseconds: 300),
    this.margin,
  });

  @override
  State<SwipeableCard> createState() => _SwipeableCardState();
}

class _SwipeableCardState extends State<SwipeableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  double _dragExtent = 0.0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    setState(() => _isDragging = true);
    HapticFeedback.selectionClick();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final delta = details.primaryDelta! / context.size!.width;
    setState(() => _dragExtent += delta);
  }

  void _handleDragEnd(DragEndDetails details) {
    setState(() => _isDragging = false);
    
    if (_dragExtent.abs() > widget.threshold) {
      _executeAction();
    } else {
      _resetPosition();
    }
  }

  void _executeAction() {
    final actions = _dragExtent > 0 ? widget.leftActions : widget.rightActions;
    if (actions.isNotEmpty) {
      HapticFeedback.mediumImpact();
      actions.first.onPressed();
    }
    _resetPosition();
  }

  void _resetPosition() {
    _animationController.reset();
    _slideAnimation = Tween<Offset>(
      begin: Offset(_dragExtent, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward().then((_) {
      setState(() => _dragExtent = 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: Stack(
        children: [
          // Background actions
          if (_dragExtent != 0) _buildActionBackground(),
          
          // Main card content
          GestureDetector(
            onHorizontalDragStart: _handleDragStart,
            onHorizontalDragUpdate: _handleDragUpdate,
            onHorizontalDragEnd: _handleDragEnd,
            child: AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                final offset = _isDragging 
                    ? Offset(_dragExtent, 0) 
                    : _slideAnimation.value;
                return Transform.translate(
                  offset: offset * context.size!.width,
                  child: widget.child,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBackground() {
    final actions = _dragExtent > 0 ? widget.leftActions : widget.rightActions;
    if (actions.isEmpty) return const SizedBox.shrink();
    
    return Positioned.fill(
      child: Container(
        color: actions.first.backgroundColor,
        child: Row(
          mainAxisAlignment: _dragExtent > 0 
              ? MainAxisAlignment.start 
              : MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spaceMD,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    actions.first.icon,
                    color: actions.first.iconColor,
                    size: 24,
                  ),
                  const SizedBox(height: DesignTokens.microSpacing),
                  Text(
                    actions.first.label,
                    style: AppTypography.caption.copyWith(
                      color: actions.first.iconColor,
                      fontWeight: AppTypography.medium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Swipe action configuration
class SwipeAction {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onPressed;
  
  const SwipeAction({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.onPressed,
  });
}

/// Pull-to-refresh wrapper with custom styling
class CustomRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? color;
  final Color? backgroundColor;
  
  const CustomRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: color ?? context.colorScheme.primary,
      backgroundColor: backgroundColor ?? context.colorScheme.surface,
      strokeWidth: 2.5,
      displacement: 60.0,
      child: child,
    );
  }
}

/// Long-press context menu
class ContextMenuWrapper extends StatelessWidget {
  final Widget child;
  final List<ContextMenuItem> menuItems;
  final Duration longPressDuration;
  
  const ContextMenuWrapper({
    super.key,
    required this.child,
    required this.menuItems,
    this.longPressDuration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showContextMenu(context),
      child: child,
    );
  }

  void _showContextMenu(BuildContext context) {
    HapticFeedback.heavyImpact();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(DesignTokens.radiusLG),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(
                  vertical: DesignTokens.spaceSM,
                ),
                decoration: BoxDecoration(
                  color: context.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Menu items
              ...menuItems.map((item) => ListTile(
                leading: Icon(
                  item.icon,
                  color: item.isDestructive 
                      ? context.colorScheme.error 
                      : context.colorScheme.onSurface,
                ),
                title: Text(
                  item.title,
                  style: AppTypography.body.copyWith(
                    color: item.isDestructive 
                        ? context.colorScheme.error 
                        : context.colorScheme.onSurface,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  item.onPressed();
                },
              )),
              
              const SizedBox(height: DesignTokens.spaceSM),
            ],
          ),
        ),
      ),
    );
  }
}

/// Context menu item configuration
class ContextMenuItem {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isDestructive;
  
  const ContextMenuItem({
    required this.title,
    required this.icon,
    required this.onPressed,
    this.isDestructive = false,
  });
}

/// Haptic feedback utilities
class HapticUtils {
  /// Light impact for button presses
  static void lightImpact() {
    HapticFeedback.lightImpact();
  }
  
  /// Medium impact for significant actions
  static void mediumImpact() {
    HapticFeedback.mediumImpact();
  }
  
  /// Heavy impact for important actions
  static void heavyImpact() {
    HapticFeedback.heavyImpact();
  }
  
  /// Selection click for navigation
  static void selectionClick() {
    HapticFeedback.selectionClick();
  }
}