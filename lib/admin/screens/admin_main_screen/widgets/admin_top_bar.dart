import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../core/admin_colors.dart';
import '../../../providers/admin_provider.dart';
import 'admin_top_bar_button.dart';
import 'admin_profile_menu.dart';
import 'admin_notifications_panel.dart';
import 'admin_quick_actions.dart';
import 'admin_global_search.dart';

/// Admin top bar widget with enhanced web features
class AdminTopBar extends StatefulWidget {
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
  State<AdminTopBar> createState() => _AdminTopBarState();
}

class _AdminTopBarState extends State<AdminTopBar> {
  final LayerLink _notificationsLink = LayerLink();
  final LayerLink _quickActionsLink = LayerLink();
  OverlayEntry? _notificationsOverlay;
  OverlayEntry? _quickActionsOverlay;

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return '${days[now.weekday % 7]}, ${months[now.month - 1]} ${now.day}';
  }

  void _showNotifications() {
    HapticFeedback.lightImpact();
    if (_notificationsOverlay != null) {
      _notificationsOverlay?.remove();
      _notificationsOverlay = null;
      return;
    }
    _quickActionsOverlay?.remove();
    _quickActionsOverlay = null;

    _notificationsOverlay = OverlayEntry(
      builder: (context) => AdminNotificationsPanel(
        link: _notificationsLink,
        onClose: () {
          _notificationsOverlay?.remove();
          _notificationsOverlay = null;
        },
      ),
    );
    Overlay.of(context).insert(_notificationsOverlay!);
  }

  void _showQuickActions() {
    HapticFeedback.lightImpact();
    if (_quickActionsOverlay != null) {
      _quickActionsOverlay?.remove();
      _quickActionsOverlay = null;
      return;
    }
    _notificationsOverlay?.remove();
    _notificationsOverlay = null;

    _quickActionsOverlay = OverlayEntry(
      builder: (context) => AdminQuickActions(
        link: _quickActionsLink,
        onClose: () {
          _quickActionsOverlay?.remove();
          _quickActionsOverlay = null;
        },
      ),
    );
    Overlay.of(context).insert(_quickActionsOverlay!);
  }

  @override
  void dispose() {
    _notificationsOverlay?.remove();
    _quickActionsOverlay?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.isWideScreen ? 70 : 60,
      padding: EdgeInsets.symmetric(horizontal: widget.isWideScreen ? 24 : 16),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        boxShadow: [
          BoxShadow(
            color: AdminColors.border.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left section: Breadcrumb & Title
          Expanded(
            flex: widget.isWideScreen ? 2 : 1,
            child: _buildLeftSection(),
          ),

          // Center section: Search (wide screens only)
          if (widget.isWideScreen) ...[
            const Expanded(
              flex: 3,
              child: AdminGlobalSearch(),
            ),
            const SizedBox(width: 16),
          ],

          // Right section: Actions & Profile
          _buildRightSection(),
        ],
      ),
    );
  }

  Widget _buildLeftSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Breadcrumb
        if (widget.isWideScreen)
          Row(
            children: [
              Icon(Iconsax.home_2, size: 14, color: AdminColors.textTertiary),
              const SizedBox(width: 6),
              Text(
                'Admin',
                style: TextStyle(
                  fontSize: 12,
                  color: AdminColors.textTertiary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  Icons.chevron_right,
                  size: 14,
                  color: AdminColors.textTertiary,
                ),
              ),
              Text(
                widget.pageTitle,
                style: TextStyle(
                  fontSize: 12,
                  color: AdminColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        if (widget.isWideScreen) const SizedBox(height: 4),
        // Page title with greeting
        Row(
          children: [
            Text(
              widget.pageTitle,
              style: TextStyle(
                fontSize: widget.isWideScreen ? 18 : 16,
                fontWeight: FontWeight.bold,
                color: AdminColors.textPrimary,
              ),
            ),
            if (widget.isWideScreen && widget.pageTitle == 'Dashboard') ...[
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AdminColors.primarySurface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Iconsax.sun_1, size: 14, color: AdminColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      _getGreeting(),
                      style: TextStyle(
                        fontSize: 12,
                        color: AdminColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildRightSection() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Date display (wide screens)
        if (widget.isWideScreen) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AdminColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Iconsax.calendar, size: 16, color: AdminColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  _getFormattedDate(),
                  style: TextStyle(
                    fontSize: 13,
                    color: AdminColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
        ],

        // Quick Actions (wide screens)
        if (widget.isWideScreen) ...[
          CompositedTransformTarget(
            link: _quickActionsLink,
            child: AdminTopBarButton(
              icon: Iconsax.flash_1,
              tooltip: 'Quick Actions',
              onTap: _showQuickActions,
            ),
          ),
          const SizedBox(width: 8),
        ],

        // Notifications
        CompositedTransformTarget(
          link: _notificationsLink,
          child: AdminTopBarButton(
            icon: Iconsax.notification,
            badge: '5',
            tooltip: 'Notifications',
            onTap: _showNotifications,
          ),
        ),
        const SizedBox(width: 8),

        // Messages (wide screens)
        if (widget.isWideScreen) ...[
          AdminTopBarButton(
            icon: Iconsax.message,
            badge: '3',
            tooltip: 'Messages',
            onTap: () {},
          ),
          const SizedBox(width: 8),
        ],

        // Help (wide screens)
        if (widget.isWideScreen) ...[
          AdminTopBarButton(
            icon: Iconsax.info_circle,
            tooltip: 'Help & Support',
            onTap: () => _showHelpDialog(context),
          ),
          const SizedBox(width: 16),
        ],

        // Divider (wide screens)
        if (widget.isWideScreen) ...[
          Container(
            height: 32,
            width: 1,
            color: AdminColors.border,
          ),
          const SizedBox(width: 16),
        ],

        // Profile
        AdminProfileMenu(
          isWideScreen: widget.isWideScreen,
          onLogout: widget.onLogout,
          onSettings: widget.onSettings,
        ),
      ],
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AdminColors.primarySurface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Iconsax.info_circle, color: AdminColors.primary),
            ),
            const SizedBox(width: 12),
            const Text('Help & Support'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHelpItem(Iconsax.document, 'Documentation', 'View admin guide'),
            _buildHelpItem(Iconsax.video_play, 'Video Tutorials', 'Watch how-to videos'),
            _buildHelpItem(Iconsax.message_question, 'FAQ', 'Common questions'),
            _buildHelpItem(Iconsax.headphone, 'Contact Support', 'Get help from our team'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AdminColors.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: AdminColors.textSecondary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: AdminColors.textTertiary)),
      onTap: () {},
      contentPadding: EdgeInsets.zero,
    );
  }
}
