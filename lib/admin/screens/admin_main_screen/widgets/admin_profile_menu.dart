import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/admin_colors.dart';
import '../../../providers/admin_provider.dart';

/// Admin profile menu widget with enhanced design
class AdminProfileMenu extends StatefulWidget {
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
  State<AdminProfileMenu> createState() => _AdminProfileMenuState();
}

class _AdminProfileMenuState extends State<AdminProfileMenu> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) {
        final admin = adminProvider.currentAdmin;

        return PopupMenuButton<String>(
          offset: const Offset(0, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: AdminColors.surface,
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            cursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: EdgeInsets.symmetric(
                horizontal: widget.isWideScreen ? 12 : 8,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: _isHovered
                    ? AdminColors.primarySurface
                    : AdminColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isHovered
                      ? AdminColors.primary.withOpacity(0.3)
                      : AdminColors.border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Avatar with online indicator
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _isHovered ? AdminColors.primary : AdminColors.border,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: AdminColors.primary,
                          backgroundImage: admin?.avatarUrl != null
                              ? NetworkImage(admin!.avatarUrl!)
                              : null,
                          child: admin?.avatarUrl == null
                              ? Text(
                                  admin?.name.substring(0, 1).toUpperCase() ?? 'A',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: AdminColors.success,
                            shape: BoxShape.circle,
                            border: Border.all(color: AdminColors.surface, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.isWideScreen) ...[
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          admin?.name ?? 'Admin',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: _isHovered
                                ? AdminColors.primary
                                : AdminColors.textPrimary,
                            fontSize: 13,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: AdminColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Admin',
                                style: TextStyle(
                                  color: AdminColors.success,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Iconsax.arrow_down_1,
                      size: 14,
                      color: _isHovered
                          ? AdminColors.primary
                          : AdminColors.textSecondary,
                    ),
                  ],
                ],
              ),
            ),
          ),
          itemBuilder: (context) => [
            // Profile header in popup
            PopupMenuItem<String>(
              enabled: false,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AdminColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AdminColors.primary,
                      backgroundImage: admin?.avatarUrl != null
                          ? NetworkImage(admin!.avatarUrl!)
                          : null,
                      child: admin?.avatarUrl == null
                          ? Text(
                              admin?.name.substring(0, 1).toUpperCase() ?? 'A',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            admin?.name ?? 'Admin User',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            admin?.email ?? 'admin@example.com',
                            style: TextStyle(
                              color: AdminColors.textTertiary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const PopupMenuDivider(),
            _buildMenuItem('profile', Iconsax.user, 'My Profile', AdminColors.primary),
            _buildMenuItem('account', Iconsax.security_user, 'Account Security', AdminColors.info),
            _buildMenuItem('settings', Iconsax.setting_2, 'Settings', AdminColors.accent),
            const PopupMenuDivider(),
            _buildMenuItem('help', Iconsax.message_question, 'Help & Support', AdminColors.success),
            const PopupMenuDivider(),
            _buildMenuItem('logout', Iconsax.logout, 'Sign Out', AdminColors.error, isDestructive: true),
          ],
          onSelected: (value) {
            if (value == 'logout' && widget.onLogout != null) {
              widget.onLogout!();
            } else if (value == 'settings' && widget.onSettings != null) {
              widget.onSettings!();
            }
          },
        );
      },
    );
  }

  PopupMenuItem<String> _buildMenuItem(
    String value,
    IconData icon,
    String title,
    Color color, {
    bool isDestructive = false,
  }) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDestructive ? color : AdminColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
