import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../widgets/common/custom_app_bar.dart';

/// Notifications screen showing all notifications
/// Displays order updates, promotions, and system alerts
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample notifications data
    final notifications = [
      _Notification(
        type: NotificationType.order,
        title: 'Order Shipped!',
        message: 'Your order #ORD123456 has been shipped and is on its way.',
        time: '2 hours ago',
        isRead: false,
      ),
      _Notification(
        type: NotificationType.promo,
        title: 'Flash Sale! 50% Off',
        message: 'Hurry! Get 50% off on all electronics. Limited time only.',
        time: '5 hours ago',
        isRead: false,
      ),
      _Notification(
        type: NotificationType.system,
        title: 'Account Verified',
        message: 'Your email address has been verified successfully.',
        time: '1 day ago',
        isRead: true,
      ),
      _Notification(
        type: NotificationType.order,
        title: 'Order Delivered',
        message: 'Your order #ORD123455 has been delivered.',
        time: '2 days ago',
        isRead: true,
      ),
      _Notification(
        type: NotificationType.promo,
        title: 'New Arrivals!',
        message: 'Check out the latest collection of summer dresses.',
        time: '3 days ago',
        isRead: true,
      ),
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.notifications,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return _buildNotificationCard(context, notifications[index]);
              },
            ),
    );
  }

  /// Build empty state
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.grey100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Iconsax.notification,
              size: 50,
              color: AppColors.grey400,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No notifications yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'ll notify you when something arrives',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textLight,
                ),
          ),
        ],
      ),
    );
  }

  /// Build notification card
  Widget _buildNotificationCard(BuildContext context, _Notification notification) {
    IconData icon;
    Color color;

    switch (notification.type) {
      case NotificationType.order:
        icon = Iconsax.box;
        color = AppColors.info;
        break;
      case NotificationType.promo:
        icon = Iconsax.discount_shape;
        color = AppColors.secondary;
        break;
      case NotificationType.system:
        icon = Iconsax.info_circle;
        color = AppColors.primary;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: notification.isRead
            ? Theme.of(context).cardColor
            : AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: notification.isRead
            ? null
            : Border.all(color: AppColors.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  notification.time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textLight,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Notification type enum
enum NotificationType {
  order,
  promo,
  system,
}

/// Notification model
class _Notification {
  final NotificationType type;
  final String title;
  final String message;
  final String time;
  final bool isRead;

  _Notification({
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
  });
}
