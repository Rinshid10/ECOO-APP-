import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../core/admin_colors.dart';
import '../../providers/admin_provider.dart';
import '../../widgets/admin_sidebar.dart';
import '../dashboard/admin_dashboard_screen.dart';
import '../products/admin_products_screen.dart';
import '../orders/admin_orders_screen.dart';
import '../customers/admin_customers_screen.dart';
import '../categories/admin_categories_screen.dart';
import '../analytics/admin_analytics_screen.dart';
import '../settings/admin_settings_screen.dart';
import 'widgets/admin_top_bar.dart';
import 'widgets/admin_mobile_menu_button.dart';
import 'widgets/admin_logout_dialog.dart';

/// Admin main screen with modern sidebar navigation
class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isSidebarExpanded = true;

  late AnimationController _animationController;

  final List<AdminMenuItem> _menuItems = [
    AdminMenuItem(
      icon: Iconsax.home_2,
      activeIcon: Iconsax.home_25,
      title: 'Dashboard',
    ),
    AdminMenuItem(
      icon: Iconsax.box,
      activeIcon: Iconsax.box5,
      title: 'Products',
    ),
    AdminMenuItem(
      icon: Iconsax.shopping_bag,
      activeIcon: Iconsax.shopping_bag5,
      title: 'Orders',
      badge: '12',
    ),
    AdminMenuItem(
      icon: Iconsax.people,
      activeIcon: Iconsax.people5,
      title: 'Customers',
    ),
    AdminMenuItem(
      icon: Iconsax.category,
      activeIcon: Iconsax.category_25,
      title: 'Categories',
    ),
    AdminMenuItem(
      icon: Iconsax.chart_2,
      activeIcon: Iconsax.chart_25,
      title: 'Analytics',
    ),
    AdminMenuItem(
      icon: Iconsax.setting_2,
      activeIcon: Iconsax.setting_25,
      title: 'Settings',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: AdminColors.background,
      drawer: isWideScreen ? null : _buildDrawer(),
      body: SafeArea(
        child: Row(
          children: [
            // Sidebar (visible on wide screens)
            if (isWideScreen)
              AdminSidebar(
                menuItems: _menuItems,
                selectedIndex: _selectedIndex,
                isExpanded: _isSidebarExpanded,
                onItemSelected: (index) {
                  HapticFeedback.lightImpact();
                  setState(() => _selectedIndex = index);
                },
                onToggleExpanded: () {
                  HapticFeedback.lightImpact();
                  setState(() => _isSidebarExpanded = !_isSidebarExpanded);
                },
              ),
        
            // Main content
            Expanded(
              child: Column(
                children: [
                  // Top bar
                  _topBar(isWideScreen),
        
                  // Page content
                  Expanded(
                    child: _pageContent(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build drawer for mobile
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AdminColors.sidebarBg,
      child: AdminSidebar(
        menuItems: _menuItems,
        selectedIndex: _selectedIndex,
        isExpanded: true,
        onItemSelected: (index) {
          HapticFeedback.lightImpact();
          setState(() => _selectedIndex = index);
          Navigator.pop(context);
        },
        onToggleExpanded: () {},
        isDrawer: true,
      ),
    );
  }

  /// Build top bar
  Widget _topBar(bool isWideScreen) {
    return Row(
      children: [
        if (!isWideScreen)
          AdminMobileMenuButton(
            onPressed: () {},
          ),
        Expanded(
          child: AdminTopBar(
            pageTitle: _menuItems[_selectedIndex].title,
            isWideScreen: isWideScreen,
            onLogout: () => _handleLogout(context),
            onSettings: () => setState(() => _selectedIndex = 6),
          ),
        ),
      ],
    );
  }

  /// Build page content
  Widget _pageContent() {
    switch (_selectedIndex) {
      case 0:
        return const AdminDashboardScreen();
      case 1:
        return const AdminProductsScreen();
      case 2:
        return const AdminOrdersScreen();
      case 3:
        return const AdminCustomersScreen();
      case 4:
        return const AdminCategoriesScreen();
      case 5:
        return const AdminAnalyticsScreen();
      case 6:
        return const AdminSettingsScreen();
      default:
        return const AdminDashboardScreen();
    }
  }

  /// Handle logout
  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AdminLogoutDialog(
        onLogout: () {
          context.read<AdminProvider>().logout();
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
  }
}

/// Admin menu item data
class AdminMenuItem {
  final IconData icon;
  final IconData activeIcon;
  final String title;
  final String? badge;

  AdminMenuItem({
    required this.icon,
    required this.activeIcon,
    required this.title,
    this.badge,
  });
}
