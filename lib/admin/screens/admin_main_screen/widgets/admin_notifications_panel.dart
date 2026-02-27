import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/admin_colors.dart';

/// Notifications dropdown panel
class AdminNotificationsPanel extends StatelessWidget {
  final LayerLink link;
  final VoidCallback onClose;

  const AdminNotificationsPanel({
    super.key,
    required this.link,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Backdrop
        Positioned.fill(
          child: GestureDetector(
            onTap: onClose,
            child: Container(color: Colors.transparent),
          ),
        ),
        // Panel
        CompositedTransformFollower(
          link: link,
          targetAnchor: Alignment.bottomRight,
          followerAnchor: Alignment.topRight,
          offset: const Offset(0, 8),
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 360,
              constraints: const BoxConstraints(maxHeight: 480),
              decoration: BoxDecoration(
                color: AdminColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AdminColors.border),
                boxShadow: AdminColors.elevatedShadow,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  _buildHeader(),
                  // Tabs
                  _buildTabs(),
                  // Notifications list
                  Flexible(child: _buildNotificationsList()),
                  // Footer
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AdminColors.border.withOpacity(0.5)),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AdminColors.primarySurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Iconsax.notification, size: 18, color: AdminColors.primary),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  '5 unread',
                  style: TextStyle(
                    fontSize: 12,
                    color: AdminColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Mark all read',
              style: TextStyle(
                fontSize: 12,
                color: AdminColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildTab('All', true),
          const SizedBox(width: 8),
          _buildTab('Orders', false),
          const SizedBox(width: 8),
          _buildTab('System', false),
        ],
      ),
    );
  }

  Widget _buildTab(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? AdminColors.primary : AdminColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isActive ? Colors.white : AdminColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildNotificationsList() {
    final notifications = [
      {
        'icon': Iconsax.shopping_cart,
        'color': AdminColors.success,
        'title': 'New order received',
        'message': 'Order #2024-001 from John Doe',
        'time': '2 min ago',
        'unread': true,
      },
      {
        'icon': Iconsax.warning_2,
        'color': AdminColors.warning,
        'title': 'Low stock alert',
        'message': 'Wireless Earbuds Pro is running low',
        'time': '15 min ago',
        'unread': true,
      },
      {
        'icon': Iconsax.user_add,
        'color': AdminColors.info,
        'title': 'New customer',
        'message': 'Sarah Wilson just signed up',
        'time': '1 hour ago',
        'unread': true,
      },
      {
        'icon': Iconsax.tick_circle,
        'color': AdminColors.success,
        'title': 'Order delivered',
        'message': 'Order #2024-003 was delivered',
        'time': '2 hours ago',
        'unread': false,
      },
      {
        'icon': Iconsax.message,
        'color': AdminColors.primary,
        'title': 'New review',
        'message': 'Mike left a 5-star review',
        'time': '3 hours ago',
        'unread': false,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: true,
      itemCount: notifications.length,
      itemBuilder: (context, index) => _buildNotificationItem(notifications[index]),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    final isUnread = notification['unread'] as bool;

    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUnread ? AdminColors.primarySurface.withOpacity(0.3) : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (notification['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                notification['icon'] as IconData,
                size: 18,
                color: notification['color'] as Color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification['title'] as String,
                          style: TextStyle(
                            fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AdminColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notification['message'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: AdminColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification['time'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      color: AdminColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AdminColors.border.withOpacity(0.5)),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'View all notifications',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AdminColors.primary,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward, size: 16, color: AdminColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
