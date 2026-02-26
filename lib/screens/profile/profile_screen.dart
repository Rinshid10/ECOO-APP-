import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../settings/settings_screen.dart';
import '../contact_support/contact_support_screen.dart';
import '../orders/orders_screen.dart';

/// Profile screen showing user information and account options
/// Displays profile picture, name, and navigation to settings
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.myProfile,
        showBackButton: false,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.user;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile header
                _buildProfileHeader(context, userProvider),
                const SizedBox(height: 24),

                // Stats row
                _buildStatsRow(context),
                const SizedBox(height: 24),

                // Menu items
                _buildMenuSection(context, 'My Account', [
                  _MenuItem(
                    icon: Iconsax.box,
                    title: AppStrings.myOrders,
                    subtitle: 'Track and manage orders',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrdersScreen(),
                      ),
                    ),
                  ),
                  _MenuItem(
                    icon: Iconsax.location,
                    title: AppStrings.shippingAddress,
                    subtitle: 'Manage delivery addresses',
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Iconsax.card,
                    title: AppStrings.paymentMethods,
                    subtitle: 'Manage payment options',
                    onTap: () {},
                  ),
                ]),
                const SizedBox(height: 16),

                _buildMenuSection(context, 'General', [
                  _MenuItem(
                    icon: Iconsax.setting_2,
                    title: AppStrings.settings,
                    subtitle: 'App preferences',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    ),
                  ),
                  _MenuItem(
                    icon: Iconsax.message_question,
                    title: AppStrings.helpCenter,
                    subtitle: 'Get help and support',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ContactSupportScreen(),
                      ),
                    ),
                  ),
                  _MenuItem(
                    icon: Iconsax.info_circle,
                    title: AppStrings.aboutUs,
                    subtitle: 'Learn more about ShopEase',
                    onTap: () {},
                  ),
                ]),
                const SizedBox(height: 16),

                // Logout button
                _buildLogoutButton(context),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build profile header with avatar and name
  Widget _buildProfileHeader(BuildContext context, UserProvider userProvider) {
    final user = userProvider.user;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Profile picture
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.textWhite, width: 3),
            ),
            child: ClipOval(
              child: user?.avatarUrl != null
                  ? CachedNetworkImage(
                      imageUrl: user!.avatarUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.grey200,
                        child: const Icon(Iconsax.user, size: 40),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.grey200,
                        child: const Icon(Iconsax.user, size: 40),
                      ),
                    )
                  : Container(
                      color: AppColors.grey200,
                      child: const Icon(Iconsax.user, size: 40),
                    ),
            ),
          ),
          const SizedBox(width: 16),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'Guest User',
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? 'Sign in to access your account',
                  style: TextStyle(
                    color: AppColors.textWhite.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Edit button
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Iconsax.edit,
              color: AppColors.textWhite,
            ),
          ),
        ],
      ),
    );
  }

  /// Build stats row
  Widget _buildStatsRow(BuildContext context) {
    return Row(
      children: [
        _buildStatItem(context, '15', 'Orders'),
        _buildStatItem(context, '8', 'Wishlist'),
        _buildStatItem(context, '5', 'Reviews'),
        _buildStatItem(context, '\$250', 'Saved'),
      ],
    );
  }

  /// Build individual stat item
  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textLight,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build menu section
  Widget _buildMenuSection(
      BuildContext context, String title, List<_MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withOpacity(0.05),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        item.icon,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 15,
                          ),
                    ),
                    subtitle: Text(
                      item.subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textLight,
                          ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: AppColors.textLight,
                    ),
                    onTap: item.onTap,
                  ),
                  if (index < items.length - 1)
                    const Divider(height: 1, indent: 70),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// Build logout button
  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Iconsax.logout,
            color: AppColors.error,
            size: 22,
          ),
        ),
        title: Text(
          AppStrings.logout,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 15,
                color: AppColors.error,
              ),
        ),
        onTap: () {
          // Show logout confirmation
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Perform logout
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Menu item data class
class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });
}
