import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/account_provider.dart';
import '../providers/expense_provider.dart';
import '../providers/invoice_provider.dart';
import '../models/account.dart';
import '../models/expense.dart';
import '../models/invoice.dart';
import '../design_system/design_tokens.dart';
import '../design_system/responsive_layout.dart';
import '../design_system/gesture_components.dart';
import '../design_system/micro_interactions.dart';
import '../design_system/accessibility_system.dart';
import '../design_system/engagement_system.dart' as engagement;
import '../design_system/typography_system.dart';
import '../design_system/thumb_zone_layout.dart' as thumb;
import '../design_system/performance_system.dart' as perf;
import 'account_management_screen.dart';
import 'client_management_screen.dart';
import 'expense_tracker_screen.dart';
import 'invoicing_screen.dart';
import 'loan_management_screen.dart';
import 'receipt_generation_screen.dart';
import 'task_management_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin, MicroInteractionMixin {
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
    _preloadCriticalAssets();
  }

  Future<void> _preloadCriticalAssets() async {
     await perf.CriticalPathOptimizer.preloadCriticalAssets(context);
   }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    // Simulate data loading
    await Future.delayed(DesignTokens.durationModerate);
    setState(() => _isLoading = false);
  }

  Future<void> _onRefresh() async {
    await _loadDashboardData();
  }

  Widget _buildEngagementSection() {
    return Column(
      children: [
        _buildProgressIndicator(),
        const SizedBox(height: 16),
        _buildAchievementsBadges(),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade100, Colors.blue.shade100],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Daily Progress',
            style: MobileTypography.h3,
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.7,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
          ),
          const SizedBox(height: 8),
          Text('7/10 tasks completed today'),
        ],
      ),
    );
  }

  Widget _buildAchievementsBadges() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildAchievementBadge('First Invoice', Icons.star, Colors.amber),
        _buildAchievementBadge('Week Streak', Icons.local_fire_department, Colors.orange),
        _buildAchievementBadge('Big Spender', Icons.shopping_bag, Colors.green),
      ],
    );
  }

  Widget _buildAchievementBadge(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha((255 * 0.1).round()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha((255 * 0.3).round())),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Dummy data for providers
    final accountProvider = AccountProvider()..addAccounts(dummyAccounts);
    final expenseProvider = ExpenseProvider()..addExpenses(dummyExpenses);
    final invoiceProvider = InvoiceProvider()..addInvoices(dummyInvoices);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: accountProvider),
        ChangeNotifierProvider.value(value: expenseProvider),
        ChangeNotifierProvider.value(value: invoiceProvider),
      ],
      child: perf.PerformanceOverlay(
        child: thumb.ThumbZoneLayout(
        tertiaryZoneContent: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                DesignTokens.primaryBlue,
                DesignTokens.primaryBlue.withAlpha((255 * 0.8).round()),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(DesignTokens.spaceMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeTransition(
                    opacity: fadeAnimation,
                    child: SlideTransition(
                      position: slideAnimation,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TypographyText(
                                    'Good Morning!',
                                    style: MobileTypography.h2.copyWith(
                                      color: Colors.white70,
                                    ),
                                    adaptive: true,
                                  ),
                                  TypographyText(
                                    'John Doe',
                                    style: MobileTypography.h1.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        const Shadow(
                                          offset: Offset(0, 2),
                                          blurRadius: 4,
                                          color: Colors.black26,
                                        ),
                                      ],
                                    ),
                                    adaptive: true,
                                    mobileScale: 0.9,
                                    tabletScale: 1.0,
                                    desktopScale: 1.1,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  engagement.StreakCounter(streakDays: engagement.EngagementSystem.instance.streakDays),
                                  const SizedBox(width: 8),
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.white.withAlpha((255 * 0.2).round()),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          engagement.ProgressIndicator(
                              currentXP: engagement.EngagementSystem.instance.experiencePoints,
                              currentLevel: engagement.EngagementSystem.instance.userLevel,
                              primaryColor: Colors.white,
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeTransition(
                    opacity: fadeAnimation,
                    child: TypographyText(
                      'Manage your business with ease',
                      style: MobileTypography.body2.copyWith(
                        color: Colors.white70,
                      ),
                      adaptive: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        secondaryZoneContent: ResponsiveLayout(
           builder: (context, screenSize) => Scaffold(
             backgroundColor: Theme.of(context).colorScheme.surface,
             floatingActionButton: thumb.ThumbZoneFAB(
                onPressed: () {
                  // Quick action - Add new transaction
                  engagement.EngagementActions.trackAction(engagement.EngagementActions.expenseAdded);
                  Navigator.pushNamed(context, '/add-transaction');
                },
                tooltip: 'Add Transaction',
                backgroundColor: DesignTokens.primaryBlue,
                child: const Icon(Icons.add, semanticLabel: 'Add new transaction'),
              ),
             body: CustomRefreshIndicator(
              key: _refreshKey,
              onRefresh: _onRefresh,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildEngagementSection(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: engagement.MotivationalQuote(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildFinancialSummaryCard(),
                ),
              ),
              _buildNavigationGrid(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildRecentActivityCard(),
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
  }

  Widget _buildFinancialSummaryCard() {
    return Consumer3<AccountProvider, ExpenseProvider, InvoiceProvider>(
      builder: (context, accountProvider, expenseProvider, invoiceProvider,
          child) {
        final totalBalance = accountProvider.totalBalance;
        final totalExpense = expenseProvider.totalExpense;
        final totalIncome = invoiceProvider.totalIncome;
        final netProfit = totalIncome - totalExpense;
        final profitMargin = totalIncome > 0 ? (netProfit / totalIncome) * 100 : 0;

        return perf.PerformanceWidget(
          name: 'financial_summary',
          child: SlideTransition(
            position: slideAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusLG),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      DesignTokens.primaryBlue.withAlpha((255 * 0.05).round()),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: DesignTokens.primaryBlue.withAlpha((255 * 0.1).round()),
                      blurRadius: DesignTokens.elevation5,
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Colors.white.withAlpha((255 * 0.9).round()),
                      blurRadius: DesignTokens.elevation3,
                      offset: const Offset(0, -4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(DesignTokens.spaceLG),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(DesignTokens.spaceMD),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [DesignTokens.primaryBlue, DesignTokens.primaryBlue.withAlpha((255 * 0.7).round())],
                                  ),
                                  borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
                                  boxShadow: [
                                    BoxShadow(
                                      color: DesignTokens.primaryBlue.withAlpha((255 * 0.3).round()),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.analytics_outlined,
                                  color: Colors.white,
                                  size: 24,
                                  semanticLabel: 'Financial analytics',
                                ),
                              ),
                              SizedBox(width: DesignTokens.spaceMD),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TypographyText(
                                    'Financial Overview',
                                    style: MobileTypography.h2.copyWith(
                                      color: DesignTokens.dayForeground,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    adaptive: true,
                                  ),
                                  TypographyText(
                                    'Last 30 days',
                                    style: MobileTypography.caption.copyWith(
                                      color: DesignTokens.neutralGray,
                                    ),
                                    adaptive: true,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: DesignTokens.spaceMD,
                              vertical: DesignTokens.spaceXS,
                            ),
                            decoration: BoxDecoration(
                              color: netProfit >= 0 ? DesignTokens.successGreen.withAlpha((255 * 0.1).round()) : DesignTokens.errorRed.withAlpha((255 * 0.1).round()),
                              borderRadius: BorderRadius.circular(DesignTokens.radiusXS),
                              border: Border.all(
                                color: netProfit >= 0 ? DesignTokens.successGreen.withAlpha((255 * 0.3).round()) : DesignTokens.errorRed.withAlpha((255 * 0.3).round()),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  netProfit >= 0 ? Icons.trending_up : Icons.trending_down,
                                  size: 16,
                                  color: netProfit >= 0 ? DesignTokens.successGreen : DesignTokens.errorRed,
                                ),
                                SizedBox(width: DesignTokens.spaceXS),
                                TypographyText(
                                  '${profitMargin.toStringAsFixed(1)}%',
                                  style: MobileTypography.caption.copyWith(
                                    color: netProfit >= 0 ? DesignTokens.successGreen : DesignTokens.errorRed,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  adaptive: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: DesignTokens.spaceLG),
                      Row(
                        children: [
                          Expanded(
                            child: _buildFinancialMetric(
                              'Total Balance',
                              '৳${totalBalance.toStringAsFixed(0)}',
                              Icons.account_balance_wallet_outlined,
                              DesignTokens.primaryBlue,
                              showTrend: true,
                              trendValue: 12.5,
                            ),
                          ),
                          SizedBox(width: DesignTokens.spaceMD),
                          Expanded(
                             child: _buildFinancialMetric(
                               'Income',
                               '৳${totalIncome.toStringAsFixed(0)}',
                               Icons.trending_up_outlined,
                               DesignTokens.successGreen,
                               showTrend: true,
                               trendValue: 8.3,
                             ),
                           ),
                           SizedBox(width: DesignTokens.spaceMD),
                           Expanded(
                             child: _buildFinancialMetric(
                               'Expenses',
                               '৳${totalExpense.toStringAsFixed(0)}',
                               Icons.trending_down_outlined,
                               DesignTokens.errorRed,
                               showTrend: true,
                               trendValue: -5.2,
                             ),
                           ),
                         ],
                       ),
                       SizedBox(height: DesignTokens.spaceLG),
                       Row(
                         children: [
                           Expanded(
                             child: _buildFinancialMetric(
                               'Net Profit',
                               '৳${netProfit.toStringAsFixed(0)}',
                               netProfit >= 0 ? Icons.trending_up_outlined : Icons.trending_down_outlined,
                               netProfit >= 0 ? DesignTokens.successGreen : DesignTokens.errorRed,
                               showTrend: true,
                               trendValue: profitMargin.toDouble(),
                               isHighlighted: true,
                             ),
                           ),
                           SizedBox(width: DesignTokens.spaceMD),
                           Expanded(
                             child: _buildQuickActionButton(
                               'Add Transaction',
                               Icons.add_circle_outline,
                               DesignTokens.primaryBlue,
                               () {
                                 engagement.EngagementActions.trackAction(engagement.EngagementActions.expenseAdded);
                                 Navigator.pushNamed(context, '/add-transaction');
                               },
                             ),
                           ),
                         ],
                       ),
                       SizedBox(height: DesignTokens.spaceLG),
                      _buildChart(context, invoiceProvider.invoices, expenseProvider.expenses),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChart(BuildContext context, List<Invoice> invoices, List<Expense> expenses) {
    // TODO: Replace with actual data processing logic
    final spots = [
      const FlSpot(0, 3),
      const FlSpot(1, 1),
      const FlSpot(2, 4),
      const FlSpot(3, 2),
      const FlSpot(4, 5),
      const FlSpot(5, 3),
      const FlSpot(6, 4),
    ];

    return Container(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              gradient: LinearGradient(
                colors: [
                  DesignTokens.primaryBlue,
                  DesignTokens.primaryBlue.withAlpha((255 * 0.5).round()),
                ],
              ),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    DesignTokens.primaryBlue.withAlpha((255 * 0.3).round()),
                    DesignTokens.primaryBlue.withAlpha((255 * 0.0).round()),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
        duration: DesignTokens.durationSlow,
        curve: Curves.easeInOut,
      ),
    );
  }

  Widget _buildFinancialMetric(
    String title, 
    String value, 
    IconData icon, 
    Color color, {
    bool showTrend = false,
    double? trendValue,
    bool isHighlighted = false,
  }) {
    return Semantics(
      label: '$title: $value${showTrend && trendValue != null ? ', trend: ${trendValue > 0 ? '+' : ''}${trendValue.toStringAsFixed(1)}%' : ''}',
      child: Container(
        padding: EdgeInsets.all(DesignTokens.spaceMD),
        decoration: BoxDecoration(
          color: isHighlighted 
              ? color.withAlpha((255 * 0.05).round())
              : Colors.white.withAlpha((255 * 0.9).round()),
          borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
          border: Border.all(
            color: color.withAlpha((255 * (isHighlighted ? 0.3 : 0.15)).round()),
            width: isHighlighted ? 2 : 1,
          ),
          boxShadow: isHighlighted ? [
            BoxShadow(
              color: color.withAlpha((255 * 0.1).round()),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(DesignTokens.spaceXS),
                      decoration: BoxDecoration(
                        color: color.withAlpha((255 * 0.1).round()),
                        borderRadius: BorderRadius.circular(DesignTokens.radiusXS),
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: 16,
                        semanticLabel: '$title icon',
                      ),
                    ),
                    SizedBox(width: DesignTokens.spaceXS),
                    TypographyText(
                      title,
                      style: MobileTypography.caption.copyWith(
                        color: DesignTokens.neutralGray,
                        fontWeight: FontWeight.w500,
                      ),
                      adaptive: true,
                    ),
                  ],
                ),
                if (showTrend && trendValue != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: DesignTokens.spaceXS,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: trendValue >= 0 
                          ? DesignTokens.successGreen.withAlpha((255 * 0.1).round())
                          : DesignTokens.errorRed.withAlpha((255 * 0.1).round()),
                      borderRadius: BorderRadius.circular(DesignTokens.radiusXS),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          trendValue >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                          size: 12,
                          color: trendValue >= 0 
                              ? DesignTokens.successGreen 
                              : DesignTokens.errorRed,
                        ),
                        const SizedBox(width: 2),
                        TypographyText(
                          '${trendValue.abs().toStringAsFixed(1)}%',
                          style: MobileTypography.caption.copyWith(
                            color: trendValue >= 0 
                                ? DesignTokens.successGreen 
                                : DesignTokens.errorRed,
                            fontWeight: FontWeight.w600,
                          ),
                          adaptive: true,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: DesignTokens.spaceSM),
            TypographyText(
              value,
              style: MobileTypography.h3.copyWith(
                color: color,
                fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w600,
              ),
              adaptive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationGrid(BuildContext context) {
    final List<Map<String, dynamic>> navigationItems = [
      {
        'title': 'Accounts',
        'icon': Icons.account_balance,
        'screen': const AccountManagementScreen(),
      },
      {
        'title': 'Clients',
        'icon': Icons.people,
        'screen': const ClientManagementScreen(),
      },
      {
        'title': 'Expenses',
        'icon': Icons.money_off,
        'screen': const ExpenseTrackerScreen(),
      },
      {
        'title': 'Invoices',
        'icon': Icons.receipt,
        'screen': const InvoicingScreen(),
      },
      {
        'title': 'Loans',
        'icon': Icons.attach_money,
        'screen': const LoanManagementScreen(),
      },
      {
        'title': 'Receipts',
        'icon': Icons.receipt_long,
        'screen': const ReceiptGenerationScreen(),
      },
      {
        'title': 'Tasks',
        'icon': Icons.task,
        'screen': const TaskManagementScreen(),
      },
      {
        'title': 'Settings',
        'icon': Icons.settings,
        'screen': const SettingsScreen(),
      },
    ];

    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.2,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = navigationItems[index];
            return perf.CriticalPathOptimizer.optimizeForCriticalPath(
              name: 'nav_${item['title']}',
              enableCaching: true,
              child: _buildNavigationCard(
                context,
                item['title'],
                item['icon'],
                item['screen'],
              ),
            );
          },
          childCount: navigationItems.length,
        ),
      ),
    );
  }

  Widget _buildNavigationCard(BuildContext context, String title, IconData icon, Widget screen) {
    return AnimatedBuilder(
      animation: fadeAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (fadeAnimation.value * 0.2),
          child: Opacity(
            opacity: fadeAnimation.value,
            child: AccessibleCard(
               onTap: () {
                 // Track navigation actions for engagement
                 if (title == 'Invoices') {
                   engagement.EngagementActions.trackAction(engagement.EngagementActions.invoiceCreated);
                  } else if (title == 'Clients') {
                    engagement.EngagementActions.trackAction(engagement.EngagementActions.clientAdded);
                  } else if (title == 'Tasks') {
                    engagement.EngagementActions.trackAction(engagement.EngagementActions.taskCompleted);
                 }
                 Navigator.push(
                   context,
                   PageRouteBuilder(
                     pageBuilder: (context, animation, secondaryAnimation) => screen,
                     transitionsBuilder: (context, animation, secondaryAnimation, child) {
                       const begin = Offset(1.0, 0.0);
                       const end = Offset.zero;
                       const curve = Curves.easeInOutCubic;
                       var tween = Tween(begin: begin, end: end).chain(
                         CurveTween(curve: curve),
                       );
                       return SlideTransition(
                         position: animation.drive(tween),
                         child: FadeTransition(
                           opacity: animation,
                           child: child,
                         ),
                       );
                     },
                     transitionDuration: const Duration(milliseconds: 500),
                   ),
                 );
               },
               semanticLabel: 'Navigate to $title',
               child: thumb.ThumbZoneCard(
                 child: Container(
                   padding: const EdgeInsets.all(20),
                   decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(16),
                     boxShadow: [
                       BoxShadow(
                         color: Colors.grey.withAlpha((255 * 0.1).round()),
                         spreadRadius: 2,
                         blurRadius: 8,
                         offset: const Offset(0, 2),
                       ),
                     ],
                   ),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Icon(
                         icon,
                         size: 40,
                         color: Colors.blue.shade600,
                         semanticLabel: '$title icon',
                       ),
                       const SizedBox(height: 12),
                       TypographyText(
                         title,
                         style: MobileTypography.body1.copyWith(
                           fontWeight: FontWeight.w600,
                           color: DesignTokens.dayForeground,
                         ),
                         adaptive: true,
                         textAlign: TextAlign.center,
                       ),
                     ],
                   ),
                 ),
               ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentActivityCard() {
    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.blue.shade50,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade100.withAlpha((255 * 0.3).round()),
                blurRadius: 15,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.white.withAlpha((255 * 0.8).round()),
                blurRadius: 15,
                offset: const Offset(0, -4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade500, Colors.blue.shade300],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.history,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Recent Activity',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SiyamRupali',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildActivityItem(
                  'New Invoice Created',
                  'Invoice #001 - ৳5,000',
                  Icons.receipt_long,
                  Colors.green,
                ),
                _buildActivityItem(
                  'Expense Added',
                  'Office Supplies - ৳1,200',
                  Icons.shopping_cart,
                  Colors.orange,
                ),
                _buildActivityItem(
                  'Payment Received',
                  'Client ABC - ৳3,500',
                  Icons.payment,
                  Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Semantics(
      label: title,
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
          child: Container(
            padding: EdgeInsets.all(DesignTokens.spaceMD),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withAlpha((255 * 0.1).round()),
                  color.withAlpha((255 * 0.05).round()),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(DesignTokens.radiusMD),
              border: Border.all(
                color: color.withAlpha((255 * 0.2).round()),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(DesignTokens.spaceSM),
                  decoration: BoxDecoration(
                    color: color.withAlpha((255 * 0.15).round()),
                    borderRadius: BorderRadius.circular(DesignTokens.radiusSM),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                    semanticLabel: '$title icon',
                  ),
                ),
                SizedBox(height: DesignTokens.spaceXS),
                TypographyText(
                  title,
                  style: MobileTypography.caption.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                  adaptive: true,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String subtitle, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((255 * 0.7).round()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withAlpha((255 * 0.2).round()),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha((255 * 0.1).round()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _NavigationCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_NavigationCard> createState() => _NavigationCardState();
}

class _NavigationCardState extends State<_NavigationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
    _elevationAnimation = Tween<double>(begin: 8.0, end: 16.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: _isHovered
                      ? [
                          Colors.blue.shade50,
                          Colors.blue.shade100,
                        ]
                      : [
                          Colors.white,
                          Colors.grey.shade50,
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered
                        ? Colors.blue.shade200.withAlpha((255 * 0.4).round())
                        : Colors.grey.shade200.withAlpha((255 * 0.3).round()),
                    blurRadius: _elevationAnimation.value,
                    offset: Offset(0, _elevationAnimation.value / 2),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.white.withAlpha((255 * 0.8).round()),
                    blurRadius: _elevationAnimation.value,
                    offset: const Offset(0, -2),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: widget.onTap,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _isHovered
                                  ? [
                                      Colors.blue.shade600,
                                      Colors.blue.shade400,
                                    ]
                                  : [
                                      Colors.blue.shade500,
                                      Colors.blue.shade300,
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade200.withAlpha((255 * 0.5).round()),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.icon,
                            size: 32.0,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SiyamRupali',
                            color: _isHovered ? Colors.blue.shade700 : Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
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
}

// Dummy data
final List<Account> dummyAccounts = [
  Account(id: '1', accountName: 'Main Account', accountNumber: 'ACC001', balance: 50000.0),
  Account(id: '2', accountName: 'Savings Account', accountNumber: 'ACC002', balance: 25000.0),
];

final List<Expense> dummyExpenses = [
  Expense(id: '1', category: 'Office', description: 'Office Rent', amount: 15000.0, date: DateTime.now()),
  Expense(id: '2', category: 'Utilities', description: 'Electricity Bill', amount: 3000.0, date: DateTime.now()),
];

final List<Invoice> dummyInvoices = [
  Invoice(id: '1', clientName: 'John Doe', amount: 25000.0, date: DateTime.now(), isPaid: true),
  Invoice(id: '2', clientName: 'Jane Smith', amount: 18000.0, date: DateTime.now(), isPaid: false),
];