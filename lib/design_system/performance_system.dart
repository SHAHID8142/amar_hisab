import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Performance monitoring and optimization system
class PerformanceSystem {
  static final PerformanceSystem _instance = PerformanceSystem._internal();
  factory PerformanceSystem() => _instance;
  PerformanceSystem._internal();

  final Map<String, int> _renderTimes = {};
  final Map<String, Widget> _widgetCache = {};
  final Set<String> _preloadedAssets = {};

  /// Initialize performance monitoring
  static void initialize() {
    if (kDebugMode) {
      debugPrint('🚀 Performance System initialized');
    }
  }

  /// Track widget render time
  void trackRenderTime(String widgetName, int milliseconds) {
    _renderTimes[widgetName] = milliseconds;
    if (kDebugMode && milliseconds > 16) {
      debugPrint('⚠️ Slow render: $widgetName took ${milliseconds}ms');
    }
  }

  /// Cache widget for reuse
  void cacheWidget(String key, Widget widget) {
    if (_widgetCache.length < 50) { // Limit cache size
      _widgetCache[key] = widget;
    }
  }

  /// Get cached widget
  Widget? getCachedWidget(String key) {
    return _widgetCache[key];
  }

  /// Clear widget cache
  void clearCache() {
    _widgetCache.clear();
  }

  /// Preload critical assets
  Future<void> preloadAssets(BuildContext context, List<String> assetPaths) async {
    for (final path in assetPaths) {
      if (!_preloadedAssets.contains(path)) {
        try {
          await precacheImage(AssetImage(path), context);
          _preloadedAssets.add(path);
        } catch (e) {
          if (kDebugMode) {
            debugPrint('Failed to preload asset: $path');
          }
        }
      }
    }
  }

  /// Get performance metrics
  Map<String, dynamic> getMetrics() {
    return {
      'averageRenderTime': _renderTimes.values.isEmpty 
          ? 0 
          : _renderTimes.values.reduce((a, b) => a + b) / _renderTimes.length,
      'slowWidgets': _renderTimes.entries
          .where((entry) => entry.value > 16)
          .map((entry) => entry.key)
          .toList(),
      'cacheSize': _widgetCache.length,
      'preloadedAssets': _preloadedAssets.length,
    };
  }
}

/// Performance-optimized widget wrapper
class PerformanceWidget extends StatefulWidget {
  final Widget child;
  final String name;
  final bool enableCaching;
  final bool trackPerformance;

  const PerformanceWidget({
    super.key,
    required this.child,
    required this.name,
    this.enableCaching = false,
    this.trackPerformance = true,
  });

  @override
  State<PerformanceWidget> createState() => _PerformanceWidgetState();
}

class _PerformanceWidgetState extends State<PerformanceWidget> {
  final Stopwatch _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    if (widget.trackPerformance) {
      _stopwatch.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.enableCaching) {
      final cached = PerformanceSystem().getCachedWidget(widget.name);
      if (cached != null) {
        return cached;
      }
    }

    final child = widget.child;

    if (widget.enableCaching) {
      PerformanceSystem().cacheWidget(widget.name, child);
    }

    if (widget.trackPerformance && _stopwatch.isRunning) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _stopwatch.stop();
        PerformanceSystem().trackRenderTime(
          widget.name,
          _stopwatch.elapsedMilliseconds,
        );
      });
    }

    return child;
  }
}

/// Lazy loading list for better performance
class LazyListView extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final ScrollController? controller;
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final int preloadThreshold;

  const LazyListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.preloadThreshold = 5,
  });

  @override
  State<LazyListView> createState() => _LazyListViewState();
}

class _LazyListViewState extends State<LazyListView> {
  final Set<int> _loadedItems = {};
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ScrollController();
    _controller.addListener(_onScroll);
    
    // Preload initial items
    for (int i = 0; i < widget.preloadThreshold && i < widget.itemCount; i++) {
      _loadedItems.add(i);
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    final scrollPosition = _controller.position;
    final viewportHeight = scrollPosition.viewportDimension;
    final scrollOffset = scrollPosition.pixels;
    
    // Calculate visible range with preload buffer
    final startIndex = (scrollOffset / 100).floor() - widget.preloadThreshold;
    final endIndex = ((scrollOffset + viewportHeight) / 100).ceil() + widget.preloadThreshold;
    
    // Load items in visible range
    for (int i = startIndex; i <= endIndex && i < widget.itemCount; i++) {
      if (i >= 0) {
        _loadedItems.add(i);
      }
    }
    
    // Unload items far from viewport to save memory
    _loadedItems.removeWhere((index) => 
        index < startIndex - widget.preloadThreshold * 2 || 
        index > endIndex + widget.preloadThreshold * 2);
    
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _controller,
      itemCount: widget.itemCount,
      padding: widget.padding,
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      itemBuilder: (context, index) {
        if (_loadedItems.contains(index)) {
          return widget.itemBuilder(context, index);
        } else {
          // Return placeholder for unloaded items
          return Container(
            height: 100, // Estimated item height
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          );
        }
      },
    );
  }
}

/// Optimized image widget with caching and lazy loading
class OptimizedImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool enableMemoryCache;

  const OptimizedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.enableMemoryCache = true,
  });

  @override
  State<OptimizedImage> createState() => _OptimizedImageState();
}

class _OptimizedImageState extends State<OptimizedImage> {
  bool _isLoading = true;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: _hasError
          ? widget.errorWidget ?? 
            Container(
              color: Colors.grey.shade300,
              child: const Icon(
                Icons.error_outline,
                color: Colors.grey,
              ),
            )
          : _isLoading
              ? widget.placeholder ??
                Container(
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                )
              : Image.network(
                  widget.imageUrl,
                  width: widget.width,
                  height: widget.height,
                  fit: widget.fit,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      _isLoading = false;
                      return child;
                    }
                    return widget.placeholder ??
                        Container(
                          color: Colors.grey.shade200,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    _hasError = true;
                    return widget.errorWidget ??
                        Container(
                          color: Colors.grey.shade300,
                          child: const Icon(
                            Icons.error_outline,
                            color: Colors.grey,
                          ),
                        );
                  },
                ),
    );
  }
}

/// Performance metrics display widget (debug only)
class PerformanceOverlay extends StatefulWidget {
  final Widget child;
  final bool showMetrics;

  const PerformanceOverlay({
    super.key,
    required this.child,
    this.showMetrics = kDebugMode,
  });

  @override
  State<PerformanceOverlay> createState() => _PerformanceOverlayState();
}

class _PerformanceOverlayState extends State<PerformanceOverlay> {
  Map<String, dynamic> _metrics = {};

  @override
  void initState() {
    super.initState();
    if (widget.showMetrics) {
      _updateMetrics();
    }
  }

  void _updateMetrics() {
    setState(() {
      _metrics = PerformanceSystem().getMetrics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.showMetrics)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha((255 * 0.7).round()),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Performance',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Avg Render: ${_metrics['averageRenderTime']?.toStringAsFixed(1) ?? '0'}ms',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    'Cache: ${_metrics['cacheSize'] ?? 0}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    'Assets: ${_metrics['preloadedAssets'] ?? 0}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    'Slow Widgets: ${(_metrics['slowWidgets'] as List?)?.length ?? 0}',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _updateMetrics,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Refresh',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Critical rendering path optimizer
class CriticalPathOptimizer {
  static const List<String> _criticalAssets = [
    'assets/icons/dashboard.png',
    'assets/icons/account.png',
    'assets/icons/client.png',
    'assets/icons/expense.png',
  ];

  /// Preload critical assets for faster initial render
  static Future<void> preloadCriticalAssets(BuildContext context) async {
    await PerformanceSystem().preloadAssets(context, _criticalAssets);
  }

  /// Optimize widget tree for critical path
  static Widget optimizeForCriticalPath({
    required Widget child,
    required String name,
    bool enableCaching = true,
  }) {
    return PerformanceWidget(
      name: name,
      enableCaching: enableCaching,
      trackPerformance: true,
      child: child,
    );
  }

  /// Create optimized list view
  static Widget createOptimizedList({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    ScrollController? controller,
    EdgeInsets? padding,
  }) {
    return LazyListView(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      controller: controller,
      padding: padding,
      preloadThreshold: 3,
    );
  }
}