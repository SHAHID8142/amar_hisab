import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amar_hisab/design_system/design_tokens.dart';
import 'package:amar_hisab/design_system/micro_interactions.dart';
import 'package:amar_hisab/screens/dashboard_screen.dart';
import 'package:amar_hisab/screens/client_management_screen.dart';
import 'package:amar_hisab/screens/expense_tracker_screen.dart';
import 'package:amar_hisab/screens/invoicing_screen.dart';
import 'package:amar_hisab/screens/settings_screen.dart';

/// Material 3 Navigation Shell with Android design principles
class NavigationShell extends StatefulWidget {
  const NavigationShell({super.key});

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell>
    with TickerProviderStateMixin, MicroInteractionMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;
  
  final List<NavigationDestination> _destinations = [
    const NavigationDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ),
    const NavigationDestination(
      icon: Icon(Icons.people_outline),
      selectedIcon: Icon(Icons.people),
      label: 'Clients',
    ),
    const NavigationDestination(
      icon: Icon(Icons.account_balance_wallet_outlined),
      selectedIcon: Icon(Icons.account_balance_wallet),
      label: 'Expenses',
    ),
    const NavigationDestination(
      icon: Icon(Icons.receipt_long_outlined),
      selectedIcon: Icon(Icons.receipt_long),
      label: 'Invoice',
    ),
    const NavigationDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  final List<Widget> _screens = [
    const DashboardScreen(),
    const ClientManagementScreen(),
    const ExpenseTrackerScreen(),
    const InvoicingScreen(),
    const SettingsScreen(),
  ];

  final List<String> _titles = [
    'Dashboard',
    'Client Management',
    'Expense Tracker',
    'Invoicing',
    'Settings',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fabScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeOutBack,
    ));
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _onDestinationSelected(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
      
      // Haptic feedback for navigation
      HapticFeedback.lightImpact();
      
      // Animate to new page
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
      
      // Animate FAB
      _fabAnimationController.reset();
      _fabAnimationController.forward();
    }
  }

  FloatingActionButton? _buildFloatingActionButton() {
    switch (_currentIndex) {
      case 0: // Dashboard
        return FloatingActionButton.extended(
          onPressed: () => _showQuickActionSheet(),
          icon: const Icon(Icons.add),
          label: const Text('Quick Add'),
          elevation: 8,
          extendedPadding: const EdgeInsets.symmetric(horizontal: 24),
        );
      case 1: // Clients
        return FloatingActionButton(
          onPressed: () => _showAddClientDialog(),
          child: const Icon(Icons.person_add),
          elevation: 8,
        );
      case 2: // Expenses
        return FloatingActionButton(
          onPressed: () => _showAddExpenseDialog(),
          child: const Icon(Icons.add),
          elevation: 8,
        );
      case 3: // Invoicing
        return FloatingActionButton(
          onPressed: () => _showCreateInvoiceDialog(),
          child: const Icon(Icons.receipt_long),
          elevation: 8,
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _titles[_currentIndex],
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 4,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        actions: [
          // Search action
          if (_currentIndex != 4) // Not on settings
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _showSearchDialog(),
              tooltip: 'Search',
              style: IconButton.styleFrom(
                minimumSize: const Size(48, 48),
                padding: const EdgeInsets.all(12),
              ),
            ),
          // Notifications
          Badge(
            label: const Text('3'),
            child: IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () => _showNotifications(),
              tooltip: 'Notifications',
              style: IconButton.styleFrom(
                minimumSize: const Size(48, 48),
                padding: const EdgeInsets.all(12),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemCount: _screens.length,
        itemBuilder: (context, index) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _screens[index],
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: _destinations,
        elevation: 8,
        height: 80,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        animationDuration: const Duration(milliseconds: 300),
      ),
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) {
          return ScaleTransition(
            scale: animation,
            child: child,
          );
        },
        child: _buildFloatingActionButton(),
      ),
    );
  }

  void _showQuickActionSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => QuickActionSheet(),
    );
  }

  void _showAddClientDialog() {
    // Implementation for add client
    HapticFeedback.mediumImpact();
  }

  void _showAddExpenseDialog() {
    // Implementation for add expense
    HapticFeedback.mediumImpact();
  }

  void _showCreateInvoiceDialog() {
    // Implementation for create invoice
    HapticFeedback.mediumImpact();
  }

  void _showSearchDialog() {
    showSearch(
      context: context,
      delegate: AppSearchDelegate(),
    );
  }

  void _showNotifications() {
    // Implementation for notifications
    HapticFeedback.lightImpact();
  }
}

/// Quick Action Sheet for Dashboard FAB
class QuickActionSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _QuickActionTile(
                icon: Icons.add_shopping_cart,
                label: 'Add Expense',
                color: Colors.red,
                onTap: () => Navigator.pop(context),
              ),
              _QuickActionTile(
                icon: Icons.person_add,
                label: 'Add Client',
                color: Colors.blue,
                onTap: () => Navigator.pop(context),
              ),
              _QuickActionTile(
                icon: Icons.receipt_long,
                label: 'New Invoice',
                color: Colors.green,
                onTap: () => Navigator.pop(context),
              ),
              _QuickActionTile(
                icon: Icons.task_alt,
                label: 'Add Task',
                color: Colors.orange,
                onTap: () => Navigator.pop(context),
              ),
              _QuickActionTile(
                icon: Icons.attach_money,
                label: 'Record Income',
                color: Colors.purple,
                onTap: () => Navigator.pop(context),
              ),
              _QuickActionTile(
                icon: Icons.camera_alt,
                label: 'Scan Receipt',
                color: Colors.teal,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Search delegate for app-wide search
class AppSearchDelegate extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'Search...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Search results for "$query"',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = [
      'Dashboard overview',
      'Client contacts',
      'Monthly expenses',
      'Invoice templates',
      'Settings preferences',
    ];

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          leading: const Icon(Icons.history),
          title: Text(suggestion),
          onTap: () {
            query = suggestion;
            showResults(context);
          },
        );
      },
    );
  }
}