import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'dart:math' as math;

/// Lazy loading widget that loads content when it becomes visible
class LazyLoader extends StatefulWidget {
  final Widget Function() builder;
  final Widget placeholder;
  final double threshold;
  final Duration delay;
  final bool preloadOnInit;
  
  const LazyLoader({
    super.key,
    required this.builder,
    this.placeholder = const SizedBox.shrink(),
    this.threshold = 200.0,
    this.delay = Duration.zero,
    this.preloadOnInit = false,
  });

  @override
  State<LazyLoader> createState() => _LazyLoaderState();
}

class _LazyLoaderState extends State<LazyLoader> {
  bool _isLoaded = false;
  bool _isVisible = false;
  Timer? _loadTimer;
  
  @override
  void initState() {
    super.initState();
    if (widget.preloadOnInit) {
      _scheduleLoad();
    }
  }
  
  void _scheduleLoad() {
    if (_isLoaded) return;
    
    _loadTimer?.cancel();
    _loadTimer = Timer(widget.delay, () {
      if (mounted) {
        setState(() => _isLoaded = true);
      }
    });
  }
  
  void _onVisibilityChanged(VisibilityInfo info) {
    final isVisible = info.visibleFraction > 0;
    
    if (isVisible && !_isVisible) {
      _isVisible = true;
      _scheduleLoad();
    } else if (!isVisible) {
      _isVisible = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: widget.key ?? ValueKey(this),
      onVisibilityChanged: _onVisibilityChanged,
      child: _isLoaded 
          ? widget.builder()
          : widget.placeholder,
    );
  }
  
  @override
  void dispose() {
    _loadTimer?.cancel();
    super.dispose();
  }
}

/// Optimized list view with viewport-based rendering
class OptimizedListView extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final double? itemExtent;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final int cacheExtent;
  
  const OptimizedListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.itemExtent,
    this.controller,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.cacheExtent = 3,
  });

  @override
  State<OptimizedListView> createState() => _OptimizedListViewState();
}

class _OptimizedListViewState extends State<OptimizedListView> {
  final Map<int, Widget> _cachedItems = {};
  late ScrollController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ScrollController();
  }
  
  Widget _buildItem(BuildContext context, int index) {
    // Cache frequently accessed items
    if (_cachedItems.containsKey(index)) {
      return _cachedItems[index]!;
    }
    
    final item = widget.itemBuilder(context, index);
    
    // Cache only if within cache extent
    if (_cachedItems.length < widget.cacheExtent) {
      _cachedItems[index] = item;
    }
    
    return item;
  }
  
  void _cleanupCache() {
    if (_cachedItems.length > widget.cacheExtent * 2) {
      final keysToRemove = _cachedItems.keys.take(_cachedItems.length - widget.cacheExtent).toList();
      for (final key in keysToRemove) {
        _cachedItems.remove(key);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          _cleanupCache();
        }
        return false;
      },
      child: ListView.builder(
        controller: _controller,
        itemCount: widget.itemCount,
        itemExtent: widget.itemExtent,
        padding: widget.padding,
        shrinkWrap: widget.shrinkWrap,
        physics: widget.physics,
        itemBuilder: _buildItem,
        cacheExtent: widget.cacheExtent * 200.0, // Optimize cache extent
      ),
    );
  }
  
  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _cachedItems.clear();
    super.dispose();
  }
}

/// Image optimization widget with progressive loading
class OptimizedImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool enableMemoryCache;
  final bool enableDiskCache;
  final Duration fadeInDuration;
  
  const OptimizedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
    this.enableMemoryCache = true,
    this.enableDiskCache = true,
    this.fadeInDuration = const Duration(milliseconds: 300),
  });

  @override
  State<OptimizedImage> createState() => _OptimizedImageState();
}

class _OptimizedImageState extends State<OptimizedImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isLoaded = false;
  bool _hasError = false;
  
  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: widget.fadeInDuration,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
  }
  
  void _onImageLoaded() {
    if (mounted) {
      setState(() => _isLoaded = true);
      _fadeController.forward();
    }
  }
  
  void _onImageError() {
    if (mounted) {
      setState(() => _hasError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return widget.errorWidget ?? 
             Container(
               width: widget.width,
               height: widget.height,
               color: Colors.grey[300],
               child: const Icon(Icons.error, color: Colors.grey),
             );
    }
    
    return Stack(
      children: [
        // Placeholder
        if (!_isLoaded)
          widget.placeholder ??
          Container(
            width: widget.width,
            height: widget.height,
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        
        // Actual image
        FadeTransition(
          opacity: _fadeAnimation,
          child: Image.network(
            widget.imageUrl,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                _onImageLoaded();
                return child;
              }
              return const SizedBox.shrink();
            },
            errorBuilder: (context, error, stackTrace) {
              _onImageError();
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
  
  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }
}

/// Performance monitoring widget
class PerformanceMonitor extends StatefulWidget {
  final Widget child;
  final bool enableFPSMonitoring;
  final bool enableMemoryMonitoring;
  final Function(PerformanceMetrics)? onMetricsUpdate;
  
  const PerformanceMonitor({
    super.key,
    required this.child,
    this.enableFPSMonitoring = false,
    this.enableMemoryMonitoring = false,
    this.onMetricsUpdate,
  });

  @override
  State<PerformanceMonitor> createState() => _PerformanceMonitorState();
}

class _PerformanceMonitorState extends State<PerformanceMonitor> {
  Timer? _metricsTimer;
  int _frameCount = 0;
  DateTime _lastFrameTime = DateTime.now();
  double _currentFPS = 0.0;
  
  @override
  void initState() {
    super.initState();
    
    if (widget.enableFPSMonitoring || widget.enableMemoryMonitoring) {
      _startMonitoring();
    }
  }
  
  void _startMonitoring() {
    _metricsTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateMetrics();
    });
    
    if (widget.enableFPSMonitoring) {
      WidgetsBinding.instance.addPostFrameCallback(_onFrame);
    }
  }
  
  void _onFrame(Duration timestamp) {
    if (!mounted) return;
    
    _frameCount++;
    final now = DateTime.now();
    final timeDiff = now.difference(_lastFrameTime).inMilliseconds;
    
    if (timeDiff >= 1000) {
      _currentFPS = _frameCount * 1000 / timeDiff;
      _frameCount = 0;
      _lastFrameTime = now;
    }
    
    WidgetsBinding.instance.addPostFrameCallback(_onFrame);
  }
  
  void _updateMetrics() {
    if (!mounted) return;
    
    final metrics = PerformanceMetrics(
      fps: _currentFPS,
      memoryUsage: _getMemoryUsage(),
      timestamp: DateTime.now(),
    );
    
    widget.onMetricsUpdate?.call(metrics);
  }
  
  double _getMemoryUsage() {
    // This is a simplified memory usage calculation
    // In a real app, you might use platform-specific methods
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
  
  @override
  void dispose() {
    _metricsTimer?.cancel();
    super.dispose();
  }
}

/// Performance metrics data class
class PerformanceMetrics {
  final double fps;
  final double memoryUsage;
  final DateTime timestamp;
  
  const PerformanceMetrics({
    required this.fps,
    required this.memoryUsage,
    required this.timestamp,
  });
  
  @override
  String toString() {
    return 'PerformanceMetrics(fps: ${fps.toStringAsFixed(1)}, memory: ${memoryUsage.toStringAsFixed(2)}MB)';
  }
}

/// Optimized grid view with dynamic item sizing
class OptimizedGridView extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;
  final bool enableLazyLoading;
  
  const OptimizedGridView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.crossAxisCount,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.childAspectRatio = 1.0,
    this.padding,
    this.controller,
    this.enableLazyLoading = true,
  });

  @override
  State<OptimizedGridView> createState() => _OptimizedGridViewState();
}

class _OptimizedGridViewState extends State<OptimizedGridView> {
  final Map<int, Widget> _itemCache = {};
  late ScrollController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ScrollController();
  }
  
  Widget _buildItem(BuildContext context, int index) {
    if (widget.enableLazyLoading) {
      return LazyLoader(
        key: ValueKey('grid_item_$index'),
        builder: () => _getCachedItem(context, index),
        placeholder: Container(
          color: Colors.grey[200],
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      );
    }
    
    return _getCachedItem(context, index);
  }
  
  Widget _getCachedItem(BuildContext context, int index) {
    if (!_itemCache.containsKey(index)) {
      _itemCache[index] = widget.itemBuilder(context, index);
    }
    return _itemCache[index]!;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: _controller,
      padding: widget.padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        mainAxisSpacing: widget.mainAxisSpacing,
        crossAxisSpacing: widget.crossAxisSpacing,
        childAspectRatio: widget.childAspectRatio,
      ),
      itemCount: widget.itemCount,
      itemBuilder: _buildItem,
    );
  }
  
  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _itemCache.clear();
    super.dispose();
  }
}

/// Visibility detector for lazy loading
class VisibilityDetector extends StatefulWidget {
  final Widget child;
  final Function(VisibilityInfo) onVisibilityChanged;
  
  const VisibilityDetector({
    super.key,
    required this.child,
    required this.onVisibilityChanged,
  });

  @override
  State<VisibilityDetector> createState() => _VisibilityDetectorState();
}

class _VisibilityDetectorState extends State<VisibilityDetector> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _checkVisibility();
        });
        return false;
      },
      child: widget.child,
    );
  }
  
  void _checkVisibility() {
    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject == null || !renderObject.attached) return;
    
    final RenderAbstractViewport viewport = RenderAbstractViewport.of(renderObject);
    
    final RevealedOffset offsetToRevealTop = viewport.getOffsetToReveal(renderObject, 0.0);
    final RevealedOffset offsetToRevealBottom = viewport.getOffsetToReveal(renderObject, 1.0);
    
    final double topOffset = offsetToRevealTop.offset;
    final double bottomOffset = offsetToRevealBottom.offset;
    final double viewportHeight = viewport.paintBounds.height;
    
    double visibleFraction = 0.0;
    
    if (topOffset < viewportHeight && bottomOffset > 0) {
      final double visibleTop = math.max(0, -topOffset);
      final double visibleBottom = math.min(viewportHeight, viewportHeight - bottomOffset);
      final double visibleHeight = visibleBottom - visibleTop;
      final double totalHeight = bottomOffset - topOffset;
      
      if (totalHeight > 0) {
        visibleFraction = visibleHeight / totalHeight;
      }
    }
    
    widget.onVisibilityChanged(VisibilityInfo(
      visibleFraction: visibleFraction.clamp(0.0, 1.0),
    ));
  }
}

/// Visibility information
class VisibilityInfo {
  final double visibleFraction;
  
  const VisibilityInfo({
    required this.visibleFraction,
  });
}

/// Performance utilities
class PerformanceUtils {
  /// Debounces function calls to improve performance
  static Timer _debounceTimer = Timer(Duration.zero, () {});
  
  static void debounce(Duration delay, VoidCallback callback) {
    if (_debounceTimer.isActive) {
      _debounceTimer.cancel();
    }
    _debounceTimer = Timer(delay, callback);
  }
  
  /// Throttles function calls to limit execution frequency
  static DateTime _lastThrottleTime = DateTime.fromMillisecondsSinceEpoch(0);
  
  static void throttle(Duration interval, VoidCallback callback) {
    final now = DateTime.now();
    
    if (now.difference(_lastThrottleTime) >= interval) {
      _lastThrottleTime = now;
      callback();
    }
  }
  
  /// Measures widget build time
  static Duration measureBuildTime(Widget Function() builder) {
    final stopwatch = Stopwatch()..start();
    builder();
    stopwatch.stop();
    return stopwatch.elapsed;
  }
  
  /// Preloads images for better performance
  static Future<void> preloadImages(BuildContext context, List<String> imageUrls) async {
    final futures = imageUrls.map((url) => precacheImage(NetworkImage(url), context));
    await Future.wait(futures);
  }
  
  /// Clears image cache to free memory
  static void clearImageCache() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }
  
  /// Gets current memory usage (simplified)
  static double getCurrentMemoryUsage() {
    // This would need platform-specific implementation
    return 0.0;
  }
}