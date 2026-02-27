import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../screens/search/search_screen.dart';
import '../../screens/notifications/notifications_screen.dart';
import '../../screens/auth/login_screen.dart';

/// Web header for desktop view with search, cart, wishlist, and user menu
class WebHeader extends StatefulWidget {
  final int currentIndex;
  final Function(int) onNavigate;

  const WebHeader({
    super.key,
    required this.currentIndex,
    required this.onNavigate,
  });

  @override
  State<WebHeader> createState() => _WebHeaderState();
}

class _WebHeaderState extends State<WebHeader> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  bool _isSearchFocused = false;
  bool _showSearchSuggestions = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
        _showSearchSuggestions = _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo
          _buildLogo(context),
          const SizedBox(width: 40),

          // Navigation links
          _buildNavLinks(),
          const Spacer(),

          // Search bar
          _buildSearchBar(context),
          const SizedBox(width: 20),

          // Action buttons
          _buildActionButtons(context),
          const SizedBox(width: 16),

          // User menu
          _buildUserMenu(context),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Iconsax.shop,
            color: AppColors.textWhite,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.appName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              AppStrings.appTagline,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textLight,
                    fontSize: 11,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNavLinks() {
    final links = [
      {'label': 'Home', 'index': 0},
      {'label': 'Categories', 'index': 1},
      {'label': 'Deals', 'index': -1},
      {'label': 'New Arrivals', 'index': -1},
    ];

    return Row(
      children: links.map((link) {
        final isSelected = widget.currentIndex == link['index'];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: TextButton(
            onPressed: () {
              if ((link['index'] as int) >= 0) {
                widget.onNavigate(link['index'] as int);
              }
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              link['label'] as String,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: _isSearchFocused
                  ? Theme.of(context).cardColor
                  : AppColors.grey100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isSearchFocused ? AppColors.primary : AppColors.grey200,
                width: _isSearchFocused ? 2 : 1,
              ),
              boxShadow: _isSearchFocused
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                const SizedBox(width: 14),
                Icon(
                  Iconsax.search_normal,
                  color: _isSearchFocused
                      ? AppColors.primary
                      : AppColors.textLight,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Search products, brands...',
                      hintStyle: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchScreen(initialQuery: value),
                          ),
                        );
                      }
                    },
                  ),
                ),
                // Keyboard shortcut hint
                if (!_isSearchFocused)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: AppColors.grey200,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.keyboard_command_key,
                            size: 12, color: AppColors.textLight),
                        const SizedBox(width: 2),
                        Text(
                          'K',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        // Wishlist
        Consumer<WishlistProvider>(
          builder: (context, wishlist, child) {
            return _buildActionButton(
              context,
              icon: Iconsax.heart,
              tooltip: 'Wishlist',
              badge: wishlist.itemCount > 0 ? wishlist.itemCount.toString() : null,
              onTap: () => widget.onNavigate(3),
            );
          },
        ),
        const SizedBox(width: 8),

        // Cart
        Consumer<CartProvider>(
          builder: (context, cart, child) {
            return _buildActionButton(
              context,
              icon: Iconsax.shopping_cart,
              tooltip: 'Cart',
              badge: cart.itemCount > 0 ? cart.itemCount.toString() : null,
              onTap: () => widget.onNavigate(2),
            );
          },
        ),
        const SizedBox(width: 8),

        // Notifications
        _buildActionButton(
          context,
          icon: Iconsax.notification,
          tooltip: 'Notifications',
          badge: '3',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationsScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    String? badge,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.grey100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: badge != null
              ? badges.Badge(
                  badgeContent: Text(
                    badge,
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
                  child: Icon(icon, color: AppColors.textSecondary, size: 22),
                )
              : Icon(icon, color: AppColors.textSecondary, size: 22),
        ),
      ),
    );
  }

  Widget _buildUserMenu(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 56),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: const Icon(
                Iconsax.user,
                color: AppColors.textWhite,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Guest User',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Sign in for more',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Icon(Iconsax.arrow_down_1, size: 16, color: AppColors.textLight),
          ],
        ),
      ),
      itemBuilder: (context) => [
        // Sign In
        PopupMenuItem<String>(
          value: 'signin',
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Iconsax.login, size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              const Text('Sign In', style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'register',
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Iconsax.user_add, size: 18, color: AppColors.success),
              ),
              const SizedBox(width: 12),
              const Text('Create Account', style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'orders',
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Iconsax.box, size: 18, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 12),
              const Text('My Orders', style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'profile',
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Iconsax.user, size: 18, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 12),
              const Text('Profile', style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'settings',
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Iconsax.setting_2, size: 18, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 12),
              const Text('Settings', style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'help',
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Iconsax.message_question, size: 18, color: AppColors.info),
              ),
              const SizedBox(width: 12),
              const Text('Help & Support', style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'signin':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
            break;
          case 'profile':
            widget.onNavigate(4);
            break;
        }
      },
    );
  }
}
