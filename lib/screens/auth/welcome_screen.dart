import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/responsive.dart';
import '../../widgets/common/custom_button.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import '../main_navigation.dart';
import '../../admin/screens/admin_login_screen.dart';

/// Welcome screen with onboarding and auth options
/// First screen users see before login/signup
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _onboardingItems = [
    OnboardingItem(
      icon: Iconsax.shop,
      title: 'Discover Products',
      description: 'Explore thousands of products from top brands at amazing prices',
      color: AppColors.primary,
    ),
    OnboardingItem(
      icon: Iconsax.heart,
      title: 'Save Favorites',
      description: 'Create wishlists and save your favorite items for later',
      color: AppColors.secondary,
    ),
    OnboardingItem(
      icon: Iconsax.truck_fast,
      title: 'Fast Delivery',
      description: 'Get your orders delivered quickly with real-time tracking',
      color: AppColors.accent,
    ),
    OnboardingItem(
      icon: Iconsax.shield_tick,
      title: 'Secure Payments',
      description: 'Shop with confidence using our secure payment methods',
      color: AppColors.success,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: isDesktop ? _buildDesktopLayout(context) : _buildMobileLayout(context),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Responsive.maxContentWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 40),
            child: Column(
              children: [
                // Top bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.primaryLight],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Iconsax.shop, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          AppStrings.appName,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AdminLoginScreen(),
                              ),
                            );
                          },
                          icon: Icon(Iconsax.setting_2, size: 18,
                              color: AppColors.textSecondary.withOpacity(0.6)),
                          label: Text('Admin',
                              style: TextStyle(
                                color: AppColors.textSecondary.withOpacity(0.6),
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                        const SizedBox(width: 16),
                        TextButton(
                          onPressed: _navigateToMain,
                          child: const Text('Skip'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 48),

                // Features grid
                Row(
                  children: _onboardingItems.map((item) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [item.color, item.color.withOpacity(0.7)],
                                ),
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: [
                                  BoxShadow(
                                    color: item.color.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Icon(item.icon, size: 44, color: Colors.white),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              item.title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.description,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.5,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 48),

                // Auth buttons centered
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    children: [
                      CustomButton(
                        text: 'Create Account',
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const SignUpScreen()));
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Sign In',
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                        },
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: _navigateToMain,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Continue as Guest',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    )),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward, size: 18,
                                color: AppColors.textSecondary),
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
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        // Top bar with admin link and skip button
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const AdminLoginScreen()));
                },
                icon: Icon(Iconsax.setting_2, size: 18,
                    color: AppColors.textSecondary.withOpacity(0.6)),
                label: Text('Admin',
                    style: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.6),
                      fontWeight: FontWeight.w500, fontSize: 13,
                    )),
              ),
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _navigateToMain();
                },
                child: Text('Skip',
                    style: TextStyle(
                      color: AppColors.textSecondary, fontWeight: FontWeight.w600,
                    )),
              ),
            ],
          ),
        ),

        Expanded(
          flex: 3,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _onboardingItems.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return _buildOnboardingPage(_onboardingItems[index]);
            },
          ),
        ),

        _buildPageIndicator(),
        const SizedBox(height: 40),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              CustomButton(
                text: 'Create Account',
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const SignUpScreen()));
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Sign In',
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const LoginScreen()));
                },
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  _navigateToMain();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Continue as Guest',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            )),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward, size: 18,
                        color: AppColors.textSecondary),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  /// Navigate to main screen
  void _navigateToMain() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigation()),
    );
  }

  /// Build onboarding page
  Widget _buildOnboardingPage(OnboardingItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated icon container
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        item.color,
                        item.color.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: item.color.withOpacity(0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Icon(
                    item.icon,
                    size: 70,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 48),

          // Title
          Text(
            item.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            item.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build page indicator
  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _onboardingItems.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: _currentPage == index
                ? LinearGradient(
                    colors: [
                      _onboardingItems[_currentPage].color,
                      _onboardingItems[_currentPage].color.withOpacity(0.6),
                    ],
                  )
                : null,
            color: _currentPage == index ? null : AppColors.grey300,
          ),
        ),
      ),
    );
  }
}

/// Onboarding item data class
class OnboardingItem {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  OnboardingItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
