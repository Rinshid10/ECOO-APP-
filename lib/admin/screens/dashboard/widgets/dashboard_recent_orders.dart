import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/admin_colors.dart';
import '../../../models/dashboard_stats.dart';
import 'dashboard_order_status_badge.dart';

/// Dashboard recent orders widget
class DashboardRecentOrders extends StatelessWidget {
  final DashboardStats stats;

  const DashboardRecentOrders({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AdminColors.cardShadow,
        border: Border.all(color: AdminColors.border.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recent Orders',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AdminColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Latest customer orders',
                    style: TextStyle(
                      color: AdminColors.textTertiary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Text('View All'),
                label: const Icon(Iconsax.arrow_right_3, size: 16),
                style: TextButton.styleFrom(
                  foregroundColor: AdminColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...stats.recentOrders.map((order) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AdminColors.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Customer avatar
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AdminColors.primary.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(order.customerAvatar),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.customerName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AdminColors.textPrimary,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Iconsax.receipt_1,
                              size: 12,
                              color: AdminColors.textTertiary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              order.id,
                              style: TextStyle(
                                color: AdminColors.textTertiary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${order.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AdminColors.textPrimary,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      DashboardOrderStatusBadge(status: order.status),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
