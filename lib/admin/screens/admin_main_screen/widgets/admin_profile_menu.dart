import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/admin_colors.dart';
import '../../../providers/admin_provider.dart';
import 'admin_popup_menu_item.dart';

/// Admin profile menu widget
class AdminProfileMenu extends StatelessWidget {
  final bool isWideScreen;
  final Function()? onLogout;
  final Function()? onSettings;

  const AdminProfileMenu({
    super.key,
    required this.isWideScreen,
    this.onLogout,
    this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) {
        final admin = adminProvider.currentAdmin;
        return PopupMenuButton<String>(
          offset: const Offset(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AdminColors.accent,
                backgroundImage: admin?.avatarUrl != null
                    ? NetworkImage(admin!.avatarUrl!)
                    : null,
                child: admin?.avatarUrl == null
                    ? Text(
                        admin?.name.substring(0, 1).toUpperCase() ?? 'A',
                        style: const TextStyle(color: Colors.white),
                      )
                    : null,
              ),
              if (isWideScreen) ...[
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      admin?.name ?? 'Admin',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AdminColors.textPrimary,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Admin',
                      style: const TextStyle(
                        color: AdminColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                const Icon(Iconsax.arrow_down_1,
                    size: 16, color: AdminColors.textSecondary),
              ],
            ],
          ),
          itemBuilder: (context) => [
            AdminPopupMenuItem(
              value: 'profile',
              icon: Iconsax.user,
              title: 'My Profile',
            ),
            AdminPopupMenuItem(
              value: 'settings',
              icon: Iconsax.setting_2,
              title: 'Settings',
            ),
            const PopupMenuDivider(),
            AdminPopupMenuItem(
              value: 'logout',
              icon: Iconsax.logout,
              title: 'Logout',
              isDestructive: true,
            ),
          ],
          onSelected: (value) {
            if (value == 'logout' && onLogout != null) {
              onLogout!();
            } else if (value == 'settings' && onSettings != null) {
              onSettings!();
            }
          },
        );
      },
    );
  }
}
