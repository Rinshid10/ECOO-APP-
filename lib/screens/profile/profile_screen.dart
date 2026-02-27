import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/responsive.dart';
import '../../providers/user_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/common/animated_list_item.dart';
import '../settings/settings_screen.dart';
import '../contact_support/contact_support_screen.dart';
import '../orders/orders_screen.dart';

/// Profile screen - responsive layout
/// Desktop: centered with max width
/// Mobile: full-width
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _headerAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _headerAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
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
    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _buildHeaderWithQuickActions(context, userProvider),
              ),
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: Responsive.narrowContentWidth,
                    ),
                    child: _buildStatsSection(context),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: Responsive.narrowContentWidth,
                    ),
                    child: _buildMenuSections(context),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _buildAppVersion(context),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeaderWithQuickActions(
      BuildContext context, UserProvider userProvider) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildAnimatedHeader(context, userProvider),
        Positioned(
          left: 20,
          right: 20,
          bottom: -40,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: Responsive.narrowContentWidth - 40,
              ),
              child: _buildQuickActionsCard(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedHeader(BuildContext context, UserProvider userProvider) {
    final user = userProvider.user;

    return AnimatedBuilder(
      animation: _headerAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 50),
          child: Stack(
            children: [
              Container(
                height: 280,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primaryDark,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -50,
                      right: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: Responsive.narrowContentWidth,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'My Profile',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  _buildHeaderButton(
                                    icon: Iconsax.notification,
                                    onTap: () {},
                                    badge: '3',
                                  ),
                                  const SizedBox(width: 12),
                                  _buildHeaderButton(
                                    icon: Iconsax.setting_2,
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SettingsScreen(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Transform.scale(
                                scale: _headerAnimation.value,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 3,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            blurRadius: 20,
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: ClipOval(
                                        child: user?.avatarUrl != null
                                            ? CachedNetworkImage(
                                                imageUrl: user!.avatarUrl!,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    _buildAvatarPlaceholder(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        _buildAvatarPlaceholder(),
                                              )
                                            : _buildAvatarPlaceholder(),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          HapticFeedback.lightImpact();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppColors.accent,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                          child: const Icon(
                                            Iconsax.camera,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Opacity(
                                  opacity: _headerAnimation.value,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user?.name ?? 'Guest User',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        user?.email ??
                                            'Sign in to access your account',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.85),
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.accent,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Iconsax.crown5,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              'Premium Member',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatarPlaceholder() {
    return Container(
      color: AppColors.primaryLight,
      child: const Icon(Iconsax.user, color: Colors.white, size: 40),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required VoidCallback onTap,
    String? badge,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          if (badge != null)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildQuickAction(context, icon: Iconsax.box, label: 'Orders',
              color: AppColors.info, onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const OrdersScreen()))),
          _buildQuickAction(context, icon: Iconsax.heart, label: 'Wishlist',
              color: AppColors.secondary, onTap: () {}),
          _buildQuickAction(context, icon: Iconsax.wallet_3, label: 'Wallet',
              color: AppColors.accent, onTap: () {}),
          _buildQuickAction(context, icon: Iconsax.gift, label: 'Rewards',
              color: AppColors.warning, onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context,
      {required IconData icon, required String label, required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Activity',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          const SizedBox(height: 16),
          if (isDesktop)
            // Four columns on desktop
            Row(
              children: [
                Expanded(child: _buildStatCard(context, icon: Iconsax.shopping_bag,
                    value: '24', label: 'Total Orders', color: AppColors.primary)),
                const SizedBox(width: 12),
                Expanded(child: Consumer<WishlistProvider>(
                  builder: (context, wishlist, child) {
                    return _buildStatCard(context, icon: Iconsax.heart,
                        value: '${wishlist.itemCount}', label: 'Wishlist',
                        color: AppColors.secondary);
                  },
                )),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard(context, icon: Iconsax.star,
                    value: '12', label: 'Reviews', color: AppColors.warning)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard(context, icon: Iconsax.discount_shape,
                    value: '\$340', label: 'Total Saved', color: AppColors.success)),
              ],
            )
          else ...[
            Row(
              children: [
                Expanded(child: _buildStatCard(context, icon: Iconsax.shopping_bag,
                    value: '24', label: 'Total Orders', color: AppColors.primary)),
                const SizedBox(width: 12),
                Expanded(child: Consumer<WishlistProvider>(
                  builder: (context, wishlist, child) {
                    return _buildStatCard(context, icon: Iconsax.heart,
                        value: '${wishlist.itemCount}', label: 'Wishlist',
                        color: AppColors.secondary);
                  },
                )),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildStatCard(context, icon: Iconsax.star,
                    value: '12', label: 'Reviews', color: AppColors.warning)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard(context, icon: Iconsax.discount_shape,
                    value: '\$340', label: 'Total Saved', color: AppColors.success)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context,
      {required IconData icon, required String value, required String label,
      required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
              Text(label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textLight,
                      )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSections(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Account'),
          const SizedBox(height: 12),
          _buildMenuCard(context, [
            _MenuItemData(icon: Iconsax.user_edit, title: 'Edit Profile',
                color: AppColors.info, onTap: () {}),
            _MenuItemData(icon: Iconsax.location, title: 'Shipping Addresses',
                color: AppColors.accent, onTap: () {}),
            _MenuItemData(icon: Iconsax.card, title: 'Payment Methods',
                color: AppColors.warning, onTap: () {}),
            _MenuItemData(icon: Iconsax.security_safe, title: 'Security',
                color: AppColors.success, onTap: () {}),
          ]),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'Support'),
          const SizedBox(height: 12),
          _buildMenuCard(context, [
            _MenuItemData(icon: Iconsax.message_question, title: 'Help Center',
                color: AppColors.primary,
                onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const ContactSupportScreen()))),
            _MenuItemData(icon: Iconsax.message_text, title: 'Live Chat',
                color: AppColors.secondary, onTap: () {}),
            _MenuItemData(icon: Iconsax.document_text, title: 'Terms & Privacy',
                color: AppColors.textSecondary, onTap: () {}),
          ]),
          const SizedBox(height: 24),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ));
  }

  Widget _buildMenuCard(BuildContext context, List<_MenuItemData> items) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Column(
            children: [
              _buildMenuItem(context, item, index),
              if (index < items.length - 1)
                Divider(height: 1, indent: 70, endIndent: 20,
                    color: AppColors.grey200),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, _MenuItemData item, int index) {
    return FadeIn(
      delay: Duration(milliseconds: index * 50),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            item.onTap?.call();
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, color: item.color, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(item.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          )),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.arrow_forward_ios_rounded,
                      size: 14, color: AppColors.textLight),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLogoutDialog(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.error.withOpacity(0.3)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.logout, color: AppColors.error),
            SizedBox(width: 12),
            Text('Log Out',
                style: TextStyle(color: AppColors.error, fontSize: 16,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Iconsax.logout, color: AppColors.error),
            ),
            const SizedBox(width: 12),
            const Text('Log Out'),
          ],
        ),
        content: const Text('Are you sure you want to log out of your account?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  Widget _buildAppVersion(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Text('ShopEase',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold, color: AppColors.textLight)),
            const SizedBox(height: 4),
            Text('Version 1.0.0',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textLight)),
          ],
        ),
      ),
    );
  }
}

class _MenuItemData {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback? onTap;

  _MenuItemData({required this.icon, required this.title,
      required this.color, this.onTap});
}
