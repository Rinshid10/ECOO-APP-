import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/admin_colors.dart';
import 'admin_top_bar_button.dart';
import 'admin_profile_menu.dart';

/// Admin top bar widget
class AdminTopBar extends StatelessWidget {
  final String pageTitle;
  final bool isWideScreen;
  final Function()? onLogout;
  final Function()? onSettings;

  const AdminTopBar({
    super.key,
    required this.pageTitle,
    required this.isWideScreen,
    this.onLogout,
    this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        boxShadow: [
          BoxShadow(
            color: AdminColors.border.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Page title
          Text(
            pageTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AdminColors.textPrimary,
            ),
          ),
          const Spacer(),

          // Search bar (wide screens)
          if (isWideScreen)
            Container(
              width: 300,
              height: 42,
              decoration: BoxDecoration(
                color: AdminColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AdminColors.border),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: AdminColors.textLight),
                  prefixIcon: Icon(Iconsax.search_normal,
                      color: AdminColors.textSecondary, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          const SizedBox(width: 16),

          // Notifications
          AdminTopBarButton(
            icon: Iconsax.notification,
            badge: '5',
            onTap: () {},
          ),
          const SizedBox(width: 8),

          // Messages
          AdminTopBarButton(
            icon: Iconsax.message,
            badge: '3',
            onTap: () {},
          ),
          const SizedBox(width: 16),

          // Profile
          AdminProfileMenu(
            isWideScreen: isWideScreen,
            onLogout: onLogout,
            onSettings: onSettings,
          ),
        ],
      ),
    );
  }
}
