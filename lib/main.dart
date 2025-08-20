import 'package:amar_hisab/providers/account_provider.dart';
import 'package:amar_hisab/providers/client_provider.dart';
import 'package:amar_hisab/providers/expense_provider.dart';
import 'package:amar_hisab/providers/invoice_provider.dart';
import 'package:amar_hisab/providers/loan_provider.dart';
import 'package:amar_hisab/providers/receipt_provider.dart';
import 'package:amar_hisab/providers/task_provider.dart';
import 'package:amar_hisab/providers/theme_provider.dart';
import 'package:amar_hisab/design_system/adaptive_theme.dart';
import 'package:amar_hisab/design_system/typography_system.dart';
import 'package:amar_hisab/design_system/performance_system.dart';
import 'package:amar_hisab/design_system/engagement_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amar_hisab/screens/landing_page.dart';
import 'package:provider/provider.dart';

import 'package:amar_hisab/widgets/navigation_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize design systems
  await TypographySystem.initialize();
  PerformanceSystem.initialize();
  EngagementSystem.instance.initialize();
  await DynamicTypographyLoader.preloadCriticalStyles();
  
  // Set system UI overlay style for immersive experience
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ClientProvider()),
        ChangeNotifierProvider(create: (_) => LoanProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => InvoiceProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => ReceiptProvider()),
        ChangeNotifierProvider(create: (_) => AccountProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Amar Hisab - Smart Financial Management',
            theme: AdaptiveTheme.lightTheme(),
             darkTheme: AdaptiveTheme.darkTheme(),
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            home: const NavigationShell(),
            builder: (context, child) {
              // Apply responsive scaling and accessibility
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.4)),
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
