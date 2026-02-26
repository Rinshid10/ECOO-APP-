import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../providers/cart_provider.dart';
import 'home/home_screen.dart';
import 'category/category_screen.dart';
import 'cart/cart_screen.dart';
import 'wishlist/wishlist_screen.dart';
import 'profile/profile_screen.dart';

/// Main navigation shell with bottom navigation bar
/// Handles navigation between main app sections
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  // Current selected tab index
  int _currentIndex = 0;

  // Page controller for smooth transitions
  late PageController _pageController;

  // List of main screens
  final List<Widget> _screens = [
    const HomeScreen(),
    const CategoryScreen(),
    const CartScreen(),
    const WishlistScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  /// Build custom bottom navigation bar
  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Iconsax.home_2,
                activeIcon: Iconsax.home5,
                label: AppStrings.home,
              ),
              _buildNavItem(
                index: 1,
                icon: Iconsax.category,
                activeIcon: Iconsax.category5,
                label: AppStrings.categories,
              ),
              _buildCartNavItem(),
              _buildNavItem(
                index: 3,
                icon: Iconsax.heart,
                activeIcon: Iconsax.heart5,
                label: AppStrings.wishlist,
              ),
              _buildNavItem(
                index: 4,
                icon: Iconsax.user,
                activeIcon: Iconsax.user5,
                label: AppStrings.profile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build individual navigation item
  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.primary : AppColors.textLight,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textLight,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build cart navigation item with badge
  Widget _buildCartNavItem() {
    final isSelected = _currentIndex == 2;

    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return GestureDetector(
          onTap: () => _onItemTapped(2),
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                cart.itemCount > 0
                    ? badges.Badge(
                        badgeContent: Text(
                          cart.itemCount.toString(),
                          style: const TextStyle(
                            color: AppColors.textWhite,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        badgeStyle: const badges.BadgeStyle(
                          badgeColor: AppColors.secondary,
                          padding: EdgeInsets.all(5),
                        ),
                        child: Icon(
                          isSelected
                              ? Iconsax.shopping_cart5
                              : Iconsax.shopping_cart,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textLight,
                          size: 24,
                        ),
                      )
                    : Icon(
                        isSelected
                            ? Iconsax.shopping_cart5
                            : Iconsax.shopping_cart,
                        color:
                            isSelected ? AppColors.primary : AppColors.textLight,
                        size: 24,
                      ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.cart,
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.textLight,
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Handle navigation item tap
  void _onItemTapped(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
      _pageController.jumpToPage(index);
    }
  }
}
