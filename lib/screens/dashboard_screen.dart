import 'package:amar_hisab/design_system/design_tokens.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _preloadCriticalAssets() async {
    // Simulate preloading of critical assets
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    await _preloadCriticalAssets();
    // Simulate data loading
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _onRefresh() async {
    await _loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildFinancialSummary(),
                  const SizedBox(height: 24),
                  _buildQuickActions(),
                  const SizedBox(height: 24),
                  _buildRecentTransactions(),
                ],
              ),
            ),
    );
  }

  Widget _buildFinancialSummary() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Financial Summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: DesignTokens.primaryBlue,
              ),
            ),
            const SizedBox(height: 16),
            _buildAdvancedChart(),
            const SizedBox(height: 16),
            _buildTotalBalance(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem('Total Income', '\$5,250', Colors.green),
                _buildSummaryItem('Total Expenses', '\$1,870', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 20,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.blueGrey,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  rod.toY.round().toString(),
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            touchCallback: (FlTouchEvent event, barTouchResponse) {
              // Handle touch events here
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(
                color: Color(0xff7589a2),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              margin: 16,
              getTitles: (double value) {
                switch (value.toInt()) {
                  case 0:
                    return 'Mn';
                  case 1:
                    return 'Te';
                  case 2:
                    return 'Wd';
                  case 3:
                    return 'Tu';
                  case 4:
                    return 'Fr';
                  case 5:
                    return 'St';
                  case 6:
                    return 'Su';
                  default:
                    return '';
                }
              },
            ),
            leftTitles: SideTitles(showTitles: false),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: 8,
                  color: DesignTokens.primaryBlue,
                  width: 22,
                  borderRadius: BorderRadius.zero,
                )
              ],
              showingTooltipIndicators: [0],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: 10,
                  color: DesignTokens.primaryBlue,
                  width: 22,
                  borderRadius: BorderRadius.zero,
                )
              ],
              showingTooltipIndicators: [0],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  toY: 14,
                  color: DesignTokens.primaryBlue,
                  width: 22,
                  borderRadius: BorderRadius.zero,
                )
              ],
              showingTooltipIndicators: [0],
            ),
            BarChartGroupData(
              x: 3,
              barRods: [
                BarChartRodData(
                  toY: 15,
                  color: DesignTokens.primaryBlue,
                  width: 22,
                  borderRadius: BorderRadius.zero,
                )
              ],
              showingTooltipIndicators: [0],
            ),
            BarChartGroupData(
              x: 4,
              barRods: [
                BarChartRodData(
                  toY: 13,
                  color: DesignTokens.primaryBlue,
                  width: 22,
                  borderRadius: BorderRadius.zero,
                )
              ],
              showingTooltipIndicators: [0],
            ),
            BarChartGroupData(
              x: 5,
              barRods: [
                BarChartRodData(
                  toY: 10,
                  color: DesignTokens.primaryBlue,
                  width: 22,
                  borderRadius: BorderRadius.zero,
                )
              ],
              showingTooltipIndicators: [0],
            ),
            BarChartGroupData(
              x: 6,
              barRods: [
                BarChartRodData(
                  toY: 16,
                  color: DesignTokens.primaryBlue,
                  width: 22,
                  borderRadius: BorderRadius.zero,
                )
              ],
              showingTooltipIndicators: [0],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalBalance() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Total Balance:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          '\$3,380',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: DesignTokens.primaryBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0, 3),
                const FlSpot(1, 1),
                const FlSpot(2, 4),
                const FlSpot(3, 2),
                const FlSpot(4, 5),
                const FlSpot(5, 3),
                const FlSpot(6, 4),
              ],
              isCurved: true,
              color: DesignTokens.primaryBlue,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: DesignTokens.primaryBlue.withAlpha(51),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildActionCard(
          'Add Expense',
          Icons.add,
          DesignTokens.urgentOrange,
          () {},
        ),
        _buildActionCard(
          'Create Invoice',
          Icons.receipt,
          DesignTokens.primaryBlue,
          () {},
        ),
        _buildActionCard(
          'Add Task',
          Icons.playlist_add_check,
          Colors.orange,
          () {},
        ),
        _buildActionCard(
          'Add Client',
          Icons.person_add,
          Colors.teal,
          () {},
        ),
      ],
    );
  }

  Widget _buildActionCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: DesignTokens.primaryBlue,
              ),
            ),
            const SizedBox(height: 16),
            _buildTransactionItem(
              'Salary',
              '+\$5,000',
              'June 1, 2024',
              Icons.arrow_upward,
              Colors.green,
            ),
            const Divider(),
            _buildTransactionItem(
              'Rent',
              '-\$1,500',
              'June 2, 2024',
              Icons.arrow_downward,
              Colors.red,
            ),
            const Divider(),
            _buildTransactionItem(
              'Groceries',
              '-\$250',
              'June 3, 2024',
              Icons.arrow_downward,
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
      String title, String amount, String date, IconData icon, Color color) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withAlpha(25),
        child: Icon(
          icon,
          color: color,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(date),
      trailing: Text(
        amount,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color,
          fontSize: 16,
        ),
      ),
    );
  }
}