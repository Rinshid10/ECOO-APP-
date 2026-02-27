import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/services.dart';
import '../../../core/admin_colors.dart';
import 'order_status_badge.dart';
import 'order_info_chip.dart';
import 'order_action_button.dart';
import 'order_more_menu.dart';

/// Order card widget
class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final bool isMedium;
  final VoidCallback onOrderDetails;
  final Function(String) onStatusChanged;

  const OrderCard({
    super.key,
    required this.order,
    required this.isMedium,
    required this.onOrderDetails,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (isMedium) {
      return _desktopCard();
    }
    return _mobileCard();
  }

  Widget _desktopCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AdminColors.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminColors.border.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          // Customer avatar
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(order['avatar']),
          ),
          const SizedBox(width: 12),

          // Order info
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order['id'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  order['customer'],
                  style: TextStyle(color: AdminColors.textSecondary, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Date
          Expanded(
            child: Text(
              order['date'],
              style: TextStyle(fontSize: 12, color: AdminColors.textTertiary),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Items
          Expanded(
            child: Text(
              '${order['items']} items',
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Total
          Expanded(
            child: Text(
              '\$${order['total'].toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Status
          OrderStatusBadge(status: order['status']),
          const SizedBox(width: 12),

          // Actions
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OrderActionButton(
                icon: Iconsax.eye,
                color: AdminColors.info,
                onTap: onOrderDetails,
              ),
              const SizedBox(width: 6),
              OrderMoreMenu(
                order: order,
                onStatusChanged: onStatusChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mobileCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AdminColors.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminColors.border.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          // Top row: Avatar, Customer info, Status
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(order['avatar']),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order['customer'],
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      order['id'],
                      style: TextStyle(color: AdminColors.textTertiary, fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              OrderStatusBadge(status: order['status']),
            ],
          ),
          const SizedBox(height: 10),
          // Divider
          Divider(color: AdminColors.border.withOpacity(0.5), height: 1),
          const SizedBox(height: 10),
          // Bottom row: Details and actions
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    OrderInfoChip(icon: Iconsax.calendar, text: order['date']),
                    const SizedBox(width: 8),
                    OrderInfoChip(icon: Iconsax.box, text: '${order['items']}'),
                  ],
                ),
              ),
              Text(
                '\$${order['total'].toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(width: 10),
              OrderActionButton(
                icon: Iconsax.eye,
                color: AdminColors.info,
                onTap: onOrderDetails,
              ),
              const SizedBox(width: 4),
              OrderMoreMenu(
                order: order,
                onStatusChanged: onStatusChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
