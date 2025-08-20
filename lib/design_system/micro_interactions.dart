import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'design_tokens.dart';

/// Animation controller mixin for consistent micro-interactions
mixin MicroInteractionMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  
  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }
  
  void _initializeAnimations() {
    _scaleController = AnimationController(
      duration: DesignTokens.durationQuick,
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: DesignTokens.durationModerate,
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: DesignTokens.durationModerate,
      vsync: this,
    );
    
    scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
    
    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
    
    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
  }
  
  void animateIn() {
    _fadeController.forward();
    _slideController.forward();
  }
  
  void animateOut() {
    _fadeController.reverse();
    _slideController.reverse();
  }
  
  void animatePress() {
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });
  }
  
  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }
}

/// Animated button with micro-interactions
class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double? elevation;
  final bool enableHaptics;
  final Duration? animationDuration;
  
  const AnimatedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.borderRadius,
    this.elevation,
    this.enableHaptics = true,
    this.animationDuration,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with TickerProviderStateMixin, MicroInteractionMixin {
  bool _isPressed = false;
  
  @override
  void initState() {
    super.initState();
    animateIn();
  }
  
  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    animatePress();
    
    if (widget.enableHaptics) {
      HapticFeedback.lightImpact();
    }
  }
  
  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }
  
  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onTap: widget.onPressed,
            child: AnimatedContainer(
              duration: widget.animationDuration ?? DesignTokens.durationQuick,
              curve: Curves.easeInOut,
              padding: widget.padding ?? 
                      const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spaceMD,
                        vertical: DesignTokens.spaceSM,
                      ),
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? Theme.of(context).primaryColor,
                borderRadius: widget.borderRadius ?? 
                            BorderRadius.circular(DesignTokens.radiusMD),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((255 * (_isPressed ? 0.1 : 0.2)).round()),
                    blurRadius: _isPressed ? 2 : 4,
                    offset: Offset(0, _isPressed ? 1 : 2),
                  ),
                ],
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  color: widget.foregroundColor ?? Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Animated card with entrance and hover effects
class AnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Duration? animationDuration;
  final bool enableHover;
  
  const AnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.animationDuration,
    this.enableHover = true,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with TickerProviderStateMixin, MicroInteractionMixin {
  bool _isHovered = false;
  
  @override
  void initState() {
    super.initState();
    // Stagger the entrance animation
    Future.delayed(Duration(milliseconds: (100 * (widget.key?.hashCode ?? 0) % 300).abs()), () {
      if (mounted) animateIn();
    });
  }
  
  void _handleHover(bool isHovered) {
    if (!widget.enableHover) return;
    
    setState(() => _isHovered = isHovered);
    
    if (isHovered) {
      HapticFeedback.selectionClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: MouseRegion(
          onEnter: (_) => _handleHover(true),
          onExit: (_) => _handleHover(false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: widget.animationDuration ?? DesignTokens.durationModerate,
              curve: Curves.easeInOut,
              margin: widget.margin,
              transform: Matrix4.identity()
                ..scale(_isHovered ? 1.02 : 1.0)
                ..translate(0.0, _isHovered ? -2.0 : 0.0),
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? Theme.of(context).cardColor,
                borderRadius: widget.borderRadius ?? 
                            BorderRadius.circular(DesignTokens.radiusLG),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((255 * (_isHovered ? 0.15 : 0.08)).round()),
                    blurRadius: _isHovered ? 12 : 6,
                    offset: Offset(0, _isHovered ? 6 : 3),
                  ),
                ],
              ),
              child: Padding(
                padding: widget.padding ?? 
                        const EdgeInsets.all(DesignTokens.spaceMD),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Animated list item with staggered entrance
class AnimatedListItem extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration? delay;
  final VoidCallback? onTap;
  final bool enableSwipe;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  
  const AnimatedListItem({
    super.key,
    required this.child,
    required this.index,
    this.delay,
    this.onTap,
    this.enableSwipe = false,
    this.onSwipeLeft,
    this.onSwipeRight,
  });

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem>
    with TickerProviderStateMixin, MicroInteractionMixin {
  
  @override
  void initState() {
    super.initState();
    
    // Staggered entrance animation
    final delay = widget.delay ?? Duration(milliseconds: widget.index * 100);
    Future.delayed(delay, () {
      if (mounted) animateIn();
    });
  }
  
  void _handleSwipe(DismissDirection direction) {
    if (!widget.enableSwipe) return;
    
    HapticFeedback.mediumImpact();
    
    if (direction == DismissDirection.startToEnd && widget.onSwipeRight != null) {
      widget.onSwipeRight!();
    } else if (direction == DismissDirection.endToStart && widget.onSwipeLeft != null) {
      widget.onSwipeLeft!();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child = SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: GestureDetector(
          onTap: widget.onTap,
          child: widget.child,
        ),
      ),
    );
    
    if (widget.enableSwipe) {
      child = Dismissible(
        key: ValueKey(widget.index),
        onDismissed: _handleSwipe,
        background: Container(
          color: Colors.green.withAlpha((255 * 0.8).round()),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: DesignTokens.spaceLG),
          child: const Icon(Icons.check, color: Colors.white),
        ),
        secondaryBackground: Container(
          color: Colors.red.withAlpha((255 * 0.8).round()),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: DesignTokens.spaceLG),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        child: child,
      );
    }
    
    return child;
  }
}

/// Animated icon with rotation and scale effects
class AnimatedIcon extends StatefulWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final Duration? animationDuration;
  final bool autoPlay;
  final AnimationType animationType;
  
  const AnimatedIcon({
    super.key,
    required this.icon,
    this.size,
    this.color,
    this.animationDuration,
    this.autoPlay = false,
    this.animationType = AnimationType.scale,
  });

  @override
  State<AnimatedIcon> createState() => _AnimatedIconState();
}

enum AnimationType {
  scale,
  rotation,
  bounce,
  pulse,
}

class _AnimatedIconState extends State<AnimatedIcon>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.animationDuration ?? DesignTokens.durationModerate,
      vsync: this,
    );
    
    _setupAnimation();
    
    if (widget.autoPlay) {
      _controller.repeat(reverse: true);
    }
  }
  
  void _setupAnimation() {
    switch (widget.animationType) {
      case AnimationType.scale:
        _animation = Tween<double>(begin: 1.0, end: 1.2)
            .animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
        break;
      case AnimationType.rotation:
        _animation = Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
        break;
      case AnimationType.bounce:
        _animation = Tween<double>(begin: 1.0, end: 1.3)
            .animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));
        break;
      case AnimationType.pulse:
        _animation = Tween<double>(begin: 0.8, end: 1.0)
            .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
        break;
    }
  }
  
  void playAnimation() {
    _controller.forward().then((_) => _controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.autoPlay) {
          playAnimation();
          HapticFeedback.lightImpact();
        }
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          Widget iconWidget = Icon(
            widget.icon,
            size: widget.size,
            color: widget.color,
          );
          
          switch (widget.animationType) {
            case AnimationType.scale:
            case AnimationType.bounce:
            case AnimationType.pulse:
              return Transform.scale(
                scale: _animation.value,
                child: iconWidget,
              );
            case AnimationType.rotation:
              return Transform.rotate(
                angle: _animation.value * 2 * 3.14159,
                child: iconWidget,
              );
          }
        },
      ),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Animated progress indicator with smooth transitions
class AnimatedProgress extends StatefulWidget {
  final double value;
  final Color? backgroundColor;
  final Color? valueColor;
  final double height;
  final BorderRadius? borderRadius;
  final Duration animationDuration;
  
  const AnimatedProgress({
    super.key,
    required this.value,
    this.backgroundColor,
    this.valueColor,
    this.height = 4.0,
    this.borderRadius,
    this.animationDuration = DesignTokens.durationModerate,
  });

  @override
  State<AnimatedProgress> createState() => _AnimatedProgressState();
}

class _AnimatedProgressState extends State<AnimatedProgress>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.value,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    
    _controller.forward();
  }
  
  @override
  void didUpdateWidget(AnimatedProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.value,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.grey.withAlpha((255 * 0.3).round()),
            borderRadius: widget.borderRadius ?? 
                          BorderRadius.circular(widget.height / 2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _animation.value.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: widget.valueColor ?? Theme.of(context).primaryColor,
                borderRadius: widget.borderRadius ?? 
                              BorderRadius.circular(widget.height / 2),
              ),
            ),
          ),
        );
      },
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Utility class for micro-interaction helpers
class MicroInteractions {
  /// Creates a staggered animation delay based on index
  static Duration staggerDelay(int index, {int baseDelayMs = 100}) {
    return Duration(milliseconds: index * baseDelayMs);
  }
  
  /// Triggers haptic feedback based on interaction type
  static void hapticFeedback(HapticType type) {
    switch (type) {
      case HapticType.light:
        HapticFeedback.lightImpact();
        break;
      case HapticType.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticType.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticType.selection:
        HapticFeedback.selectionClick();
        break;
    }
  }
  
  /// Creates a bounce animation curve
  static Curve get bounceCurve => Curves.elasticOut;
  
  /// Creates a smooth ease curve
  static Curve get smoothCurve => Curves.easeOutCubic;
  
  /// Creates a spring animation curve
  static Curve get springCurve => Curves.bounceOut;
}

enum HapticType {
  light,
  medium,
  heavy,
  selection,
}