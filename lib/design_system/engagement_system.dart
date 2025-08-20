import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

/// Comprehensive engagement system with gamification and motivation-based design
class EngagementSystem {
  static EngagementSystem? _instance;
  static EngagementSystem get instance => _instance ??= EngagementSystem._();
  EngagementSystem._();

  // User engagement metrics
  int _userLevel = 1;
  int _experiencePoints = 0;
  int _streakDays = 0;
  final List<Achievement> _achievements = [];
  final Map<String, int> _actionCounts = {};

  // Getters
  int get userLevel => _userLevel;
  int get experiencePoints => _experiencePoints;
  int get streakDays => _streakDays;
  List<Achievement> get achievements => _achievements;

  /// Initialize engagement system
  void initialize() {
    _loadUserProgress();
  }

  /// Load user progress from storage
  void _loadUserProgress() {
    // In a real app, this would load from persistent storage
    // For now, we'll use default values
  }

  /// Award experience points for user actions
  void awardExperience(String action, int points) {
    _experiencePoints += points;
    _actionCounts[action] = (_actionCounts[action] ?? 0) + 1;
    
    // Check for level up
    int newLevel = _calculateLevel(_experiencePoints);
    if (newLevel > _userLevel) {
      _userLevel = newLevel;
      _triggerLevelUpCelebration();
    }
    
    // Check for achievements
    _checkAchievements(action);
  }

  /// Calculate user level based on experience points
  int _calculateLevel(int xp) {
    return (xp / 100).floor() + 1;
  }

  /// Trigger level up celebration
  void _triggerLevelUpCelebration() {
    HapticFeedback.heavyImpact();
    // Additional celebration logic would go here
  }

  /// Check and award achievements
  void _checkAchievements(String action) {
    // Example achievements
    if (action == 'expense_added' && (_actionCounts['expense_added'] ?? 0) >= 10) {
      _awardAchievement(Achievement(
        id: 'expense_tracker',
        title: 'Expense Tracker',
        description: 'Added 10 expenses',
        icon: Icons.receipt_long,
        points: 50,
      ));
    }
    
    if (action == 'invoice_created' && (_actionCounts['invoice_created'] ?? 0) >= 5) {
      _awardAchievement(Achievement(
        id: 'invoice_master',
        title: 'Invoice Master',
        description: 'Created 5 invoices',
        icon: Icons.description,
        points: 75,
      ));
    }
  }

  /// Award achievement to user
  void _awardAchievement(Achievement achievement) {
    if (!_achievements.any((a) => a.id == achievement.id)) {
      _achievements.add(achievement);
      _experiencePoints += achievement.points;
      HapticFeedback.mediumImpact();
    }
  }

  /// Update streak days
  void updateStreak(bool actionCompleted) {
    if (actionCompleted) {
      _streakDays++;
    } else {
      _streakDays = 0;
    }
  }
}

/// Achievement model
class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final int points;
  final DateTime earnedAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.points,
    DateTime? earnedAt,
  }) : earnedAt = earnedAt ?? DateTime.now();
}

/// Gamified progress indicator
class ProgressIndicator extends StatelessWidget {
  final int currentXP;
  final int currentLevel;
  final Color primaryColor;
  final Color backgroundColor;
  final double height;

  const ProgressIndicator({
    super.key,
    required this.currentXP,
    required this.currentLevel,
    this.primaryColor = Colors.blue,
    this.backgroundColor = Colors.grey,
    this.height = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    int levelStartXP = (currentLevel - 1) * 100;
    int levelEndXP = currentLevel * 100;
    double progress = (currentXP - levelStartXP).toDouble() / (levelEndXP - levelStartXP).toDouble();
    progress = progress.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Level $currentLevel',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            Text(
              '$currentXP XP',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor.withAlpha((255 * 0.3).round()),
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor.withAlpha((255 * 0.7).round())],
                ),
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Achievement badge widget
class AchievementBadge extends StatelessWidget {
  final Achievement achievement;
  final bool isEarned;
  final VoidCallback? onTap;

  const AchievementBadge({
    super.key,
    required this.achievement,
    this.isEarned = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isEarned ? Colors.amber.shade100 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEarned ? Colors.amber : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              achievement.icon,
              size: 32,
              color: isEarned ? Colors.amber.shade700 : Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            Text(
              achievement.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isEarned ? Colors.amber.shade700 : Colors.grey.shade600,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              achievement.description,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            if (isEarned) ...[
              const SizedBox(height: 4),
              Text(
                '+${achievement.points} XP',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade600,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

/// Streak counter widget
class StreakCounter extends StatelessWidget {
  final int streakDays;
  final Color primaryColor;
  final IconData icon;

  const StreakCounter({
    super.key,
    required this.streakDays,
    this.primaryColor = Colors.orange,
    this.icon = Icons.local_fire_department,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor.withAlpha((255 * 0.7).round())],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            '$streakDays',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// Motivational quote widget
class MotivationalQuote extends StatelessWidget {
  final List<String> quotes = [
    "Every penny saved is a penny earned!",
    "Financial discipline today, freedom tomorrow.",
    "Track your expenses, secure your future.",
    "Small steps lead to big financial wins.",
    "Your financial journey starts with one entry.",
    "Consistency in tracking leads to clarity in finances.",
    "Every invoice sent is progress made.",
    "Financial awareness is the first step to wealth.",
  ];

  MotivationalQuote({super.key});

  @override
  Widget build(BuildContext context) {
    final random = math.Random();
    final quote = quotes[random.nextInt(quotes.length)];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.purple.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.format_quote,
            color: Colors.blue.shade600,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              quote,
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.blue.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Celebration animation widget
class CelebrationAnimation extends StatefulWidget {
  final Widget child;
  final bool trigger;
  final Duration duration;

  const CelebrationAnimation({
    super.key,
    required this.child,
    required this.trigger,
    this.duration = const Duration(milliseconds: 1000),
  });

  @override
  State<CelebrationAnimation> createState() => _CelebrationAnimationState();
}

class _CelebrationAnimationState extends State<CelebrationAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
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
  void didUpdateWidget(CelebrationAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) {
      _controller.forward().then((_) {
        _controller.reverse();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Engagement action tracker
class EngagementActions {
  static const String expenseAdded = 'expense_added';
  static const String invoiceCreated = 'invoice_created';
  static const String clientAdded = 'client_added';
  static const String taskCompleted = 'task_completed';
  static const String loanTracked = 'loan_tracked';
  static const String receiptGenerated = 'receipt_generated';
  static const String accountUpdated = 'account_updated';
  static const String dailyLogin = 'daily_login';

  static const Map<String, int> actionPoints = {
    expenseAdded: 10,
    invoiceCreated: 25,
    clientAdded: 15,
    taskCompleted: 20,
    loanTracked: 15,
    receiptGenerated: 20,
    accountUpdated: 5,
    dailyLogin: 5,
  };

  static void trackAction(String action) {
    final points = actionPoints[action] ?? 0;
    EngagementSystem.instance.awardExperience(action, points);
  }
}