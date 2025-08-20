import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amar_hisab/screens/dashboard_screen.dart';
import 'package:amar_hisab/design_system/design_tokens.dart';
import 'package:amar_hisab/design_system/micro_interactions.dart';
import 'package:amar_hisab/design_system/engagement_system.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin, MicroInteractionMixin {
  late AnimationController _heroController;
  late AnimationController _featuresController;
  late Animation<double> _heroFadeAnimation;
  late Animation<Offset> _heroSlideAnimation;
  late Animation<double> _featuresAnimation;
  
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final List<OnboardingPage> _onboardingPages = [
    OnboardingPage(
      title: 'আমার হিসাব',
      subtitle: 'আপনার ব্যবসার বিশ্বস্ত সঙ্গী',
      description: 'সহজ ও কার্যকর উপায়ে আপনার ব্যবসার সকল হিসাব-নিকাশ পরিচালনা করুন',
      icon: Icons.business_center,
      color: DesignTokens.primaryBlue,
    ),
    OnboardingPage(
      title: 'স্মার্ট ড্যাশবোর্ড',
      subtitle: 'এক নজরে সব তথ্য',
      description: 'আয়-ব্যয়, ক্লায়েন্ট তথ্য, এবং ব্যবসার অগ্রগতি একটি স্ক্রিনেই দেখুন',
      icon: Icons.dashboard,
      color: DesignTokens.successGreen,
    ),
    OnboardingPage(
      title: 'সহজ ইনভয়েসিং',
      subtitle: 'পেশাদার বিল তৈরি করুন',
      description: 'মিনিটেই পেশাদার ইনভয়েস তৈরি করুন এবং পেমেন্ট ট্র্যাক করুন',
      icon: Icons.receipt_long,
      color: DesignTokens.urgentOrange,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    EngagementSystem.instance.initialize();
  }

  void _initializeAnimations() {
    _heroController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _featuresController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _heroFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _heroController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));
    
    _heroSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _heroController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));
    
    _featuresAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _featuresController,
      curve: Curves.easeOutBack,
    ));
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _heroController.forward();
    });
    
    Future.delayed(const Duration(milliseconds: 800), () {
      _featuresController.forward();
    });
  }

  @override
  void dispose() {
    _heroController.dispose();
    _featuresController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _onboardingPages[_currentPage].color.withAlpha((255 * 0.9).round()),
              _onboardingPages[_currentPage].color.withAlpha((255 * 0.6).round()),
              _onboardingPages[_currentPage].color.withAlpha((255 * 0.3).round()),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Padding(
                padding: const EdgeInsets.all(DesignTokens.spaceMD),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 60),
                    // Page indicators
                    Row(
                      children: List.generate(
                        _onboardingPages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Colors.white
                                : Colors.white.withAlpha((255 * 0.4).round()),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _navigateToDashboard,
                      child: const Text(
                        'এড়িয়ে যান',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: DesignTokens.bodySize,
                          fontFamily: 'SiyamRupali',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Onboarding content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                    HapticFeedback.lightImpact();
                  },
                  itemCount: _onboardingPages.length,
                  itemBuilder: (context, index) {
                    return _buildOnboardingPage(_onboardingPages[index]);
                  },
                ),
              ),
              
              // Bottom navigation
              Padding(
                padding: const EdgeInsets.all(DesignTokens.spaceLG),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Previous button
                    AnimatedOpacity(
                      opacity: _currentPage > 0 ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: TextButton.icon(
                        onPressed: _currentPage > 0 ? _previousPage : null,
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        label: const Text(
                          'পূর্ববর্তী',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'SiyamRupali',
                          ),
                        ),
                      ),
                    ),
                    
                    // Next/Get Started button
                    AnimatedButton(
                      onPressed: _currentPage < _onboardingPages.length - 1
                          ? _nextPage
                          : _navigateToDashboard,
                      backgroundColor: Colors.white,
                      foregroundColor: _onboardingPages[_currentPage].color,
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignTokens.spaceLG,
                        vertical: DesignTokens.spaceSM,
                      ),
                      borderRadius: BorderRadius.circular(DesignTokens.spaceLG),
                      elevation: DesignTokens.elevation3,
                      enableHaptics: true,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _currentPage < _onboardingPages.length - 1
                                ? 'পরবর্তী'
                                : 'শুরু করুন',
                            style: const TextStyle(
                              fontSize: DesignTokens.bodyLargeSize,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SiyamRupali',
                            ),
                          ),
                          const SizedBox(width: DesignTokens.spaceXS),
                          const Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(DesignTokens.spaceLG),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hero icon with animation
          SlideTransition(
            position: _heroSlideAnimation,
            child: FadeTransition(
              opacity: _heroFadeAnimation,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha((255 * 0.2).round()),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((255 * 0.1).round()),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  page.icon,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: DesignTokens.spaceXL),
          
          // Title
          SlideTransition(
            position: _heroSlideAnimation,
            child: FadeTransition(
              opacity: _heroFadeAnimation,
              child: Text(
                page.title,
                style: const TextStyle(
                  fontSize: DesignTokens.displaySize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'SiyamRupali',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          
          const SizedBox(height: DesignTokens.spaceSM),
          
          // Subtitle
          SlideTransition(
            position: _heroSlideAnimation,
            child: FadeTransition(
              opacity: _heroFadeAnimation,
              child: Text(
                page.subtitle,
                style: TextStyle(
                  fontSize: DesignTokens.h3Size,
                  color: Colors.white.withAlpha((255 * 0.9).round()),
                  fontFamily: 'SiyamRupali',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          
          const SizedBox(height: DesignTokens.spaceLG),
          
          // Description
          ScaleTransition(
            scale: _featuresAnimation,
            child: FadeTransition(
              opacity: _featuresAnimation,
              child: Container(
                padding: const EdgeInsets.all(DesignTokens.spaceLG),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha((255 * 0.1).round()),
                  borderRadius: BorderRadius.circular(DesignTokens.spaceSM),
                  border: Border.all(
                    color: Colors.white.withAlpha((255 * 0.2).round()),
                    width: 1,
                  ),
                ),
                child: Text(
                  page.description,
                  style: TextStyle(
                    fontSize: DesignTokens.bodyLargeSize,
                    color: Colors.white.withAlpha((255 * 0.8).round()),
                    fontFamily: 'SiyamRupali',
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < _onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _navigateToDashboard() {
    HapticFeedback.mediumImpact();
    EngagementSystem.instance.awardExperience('onboarding_completed', 100);
    
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const DashboardScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
  });
}