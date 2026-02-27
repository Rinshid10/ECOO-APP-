import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/utils/responsive.dart';
import '../providers/cart_provider.dart';
import '../widgets/layout/web_header.dart';
import 'home/home_screen.dart';
import 'category/category_screen.dart';
import 'cart/cart_screen.dart';
import 'wishlist/wishlist_screen.dart';
import 'profile/profile_screen.dart';
import 'search/search_screen.dart';
import 'notifications/notifications_screen.dart';

/// Main navigation shell with responsive layout
/// Desktop: Top header + Sidebar navigation
/// Mobile: Bottom navigation bar
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  late PageController _pageController;

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
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    if (isDesktop) {
      return Scaffold(
        body: Column(
          children: [
            // Web Header
            WebHeader(
              currentIndex: _currentIndex,
              onNavigate: _onItemTapped,
            ),
            // Content
            Expanded(
              child: Row(
                children: [
                  _buildDesktopSidebar(context),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() => _currentIndex = index);
                      },
                      children: _screens,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (isTablet) {
      return Scaffold(
        body: Row(
          children: [
            _buildTabletSidebar(context),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                children: _screens,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  /// Build desktop sidebar navigation
  Widget _buildDesktopSidebar(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          right: BorderSide(
            color: AppColors.grey200,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Section label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'MENU',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textLight,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),

            // Main navigation items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  _buildSidebarItem(
                    context,
                    index: 0,
                    icon: Iconsax.home_2,
                    activeIcon: Iconsax.home5,
                    label: AppStrings.home,
                  ),
                  _buildSidebarItem(
                    context,
                    index: 1,
                    icon: Iconsax.category,
                    activeIcon: Iconsax.category5,
                    label: AppStrings.categories,
                  ),
                  _buildSidebarItem(
                    context,
                    index: 2,
                    icon: Iconsax.shopping_cart,
                    activeIcon: Iconsax.shopping_cart5,
                    label: AppStrings.cart,
                    showCartBadge: true,
                  ),
                  _buildSidebarItem(
                    context,
                    index: 3,
                    icon: Iconsax.heart,
                    activeIcon: Iconsax.heart5,
                    label: AppStrings.wishlist,
                  ),
                  _buildSidebarItem(
                    context,
                    index: 4,
                    icon: Iconsax.user,
                    activeIcon: Iconsax.user5,
                    label: AppStrings.profile,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Divider(height: 1, color: AppColors.grey200),
            const SizedBox(height: 12),

            // Section label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'EXPLORE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textLight,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  _buildSidebarItem(
                    context,
                    icon: Iconsax.discount_shape,
                    label: 'Deals & Offers',
                    onTap: () {},
                  ),
                  _buildSidebarItem(
                    context,
                    icon: Iconsax.flash_1,
                    label: 'Flash Sale',
                    onTap: () {},
                  ),
                  _buildSidebarItem(
                    context,
                    icon: Iconsax.gift,
                    label: 'Gift Cards',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Bottom section
            Divider(height: 1, color: AppColors.grey200),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _buildSidebarItem(
                    context,
                    icon: Iconsax.message_question,
                    label: 'Help & Support',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build tablet sidebar (compact)
  Widget _buildTabletSidebar(BuildContext context) {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          right: BorderSide(
            color: AppColors.grey200,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Logo
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Iconsax.shop,
                color: AppColors.textWhite,
                size: 22,
              ),
            ),
            const SizedBox(height: 24),
            Divider(height: 1, color: AppColors.grey200, indent: 16, endIndent: 16),
            const SizedBox(height: 16),

            // Navigation items
            _buildTabletNavItem(context, 0, Iconsax.home_2, Iconsax.home5),
            _buildTabletNavItem(context, 1, Iconsax.category, Iconsax.category5),
            _buildTabletNavItem(context, 2, Iconsax.shopping_cart, Iconsax.shopping_cart5, showBadge: true),
            _buildTabletNavItem(context, 3, Iconsax.heart, Iconsax.heart5),
            _buildTabletNavItem(context, 4, Iconsax.user, Iconsax.user5),

            const Spacer(),

            // Bottom items
            _buildTabletNavItem(context, -1, Iconsax.search_normal_1, Iconsax.search_normal_1,
                onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen()));
            }),
            _buildTabletNavItem(context, -1, Iconsax.notification, Iconsax.notification, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletNavItem(
    BuildContext context,
    int index,
    IconData icon,
    IconData activeIcon, {
    bool showBadge = false,
    VoidCallback? onTap,
  }) {
    final isSelected = index >= 0 && _currentIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Tooltip(
        message: index == 0
            ? 'Home'
            : index == 1
                ? 'Categories'
                : index == 2
                    ? 'Cart'
                    : index == 3
                        ? 'Wishlist'
                        : index == 4
                            ? 'Profile'
                            : '',
        child: InkWell(
          onTap: onTap ?? (index >= 0 ? () => _onItemTapped(index) : null),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: showBadge
                ? Consumer<CartProvider>(
                    builder: (context, cart, child) {
                      if (cart.itemCount == 0) {
                        return Icon(
                          isSelected ? activeIcon : icon,
                          color: isSelected ? AppColors.primary : AppColors.textSecondary,
                        );
                      }
                      return badges.Badge(
                        badgeContent: Text(
                          cart.itemCount.toString(),
                          style: const TextStyle(color: AppColors.textWhite, fontSize: 10),
                        ),
                        badgeStyle: const badges.BadgeStyle(
                          badgeColor: AppColors.secondary,
                          padding: EdgeInsets.all(5),
                        ),
                        child: Icon(
                          isSelected ? activeIcon : icon,
                          color: isSelected ? AppColors.primary : AppColors.textSecondary,
                        ),
                      );
                    },
                  )
                : Icon(
                    isSelected ? activeIcon : icon,
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  ),
          ),
        ),
      ),
    );
  }

  /// Build sidebar navigation item
  Widget _buildSidebarItem(
    BuildContext context, {
    int? index,
    required IconData icon,
    IconData? activeIcon,
    required String label,
    VoidCallback? onTap,
    bool showCartBadge = false,
  }) {
    final isSelected = index != null && _currentIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ?? (index != null ? () => _onItemTapped(index) : null),
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? (activeIcon ?? icon) : icon,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (showCartBadge)
                  Consumer<CartProvider>(
                    builder: (context, cart, child) {
                      if (cart.itemCount == 0) return const SizedBox.shrink();
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          cart.itemCount.toString(),
                          style: const TextStyle(
                            color: AppColors.textWhite,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build custom bottom navigation bar (mobile)
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
