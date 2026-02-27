import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/admin_colors.dart';
import '../../../models/dashboard_stats.dart';
import 'dashboard_order_status_item.dart';

/// Dashboard orders status widget
class DashboardOrdersStatus extends StatelessWidget {
  final DashboardStats stats;

  const DashboardOrdersStatus({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final total = stats.pendingOrders +
        stats.processingOrders +
        stats.shippedOrders +
        stats.deliveredOrders;

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
              const Text(
                'Orders Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AdminColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AdminColors.primarySurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$total total',
                  style: TextStyle(
                    color: AdminColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          DashboardOrderStatusItem(
            label: 'Pending',
            value: stats.pendingOrders,
            total: total,
            color: AdminColors.warning,
            icon: Iconsax.clock,
          ),
          const SizedBox(height: 16),
          DashboardOrderStatusItem(
            label: 'Processing',
            value: stats.processingOrders,
            total: total,
            color: AdminColors.info,
            icon: Iconsax.refresh_circle,
          ),
          const SizedBox(height: 16),
          DashboardOrderStatusItem(
            label: 'Shipped',
            value: stats.shippedOrders,
            total: total,
            color: AdminColors.accent,
            icon: Iconsax.truck_fast,
          ),
          const SizedBox(height: 16),
          DashboardOrderStatusItem(
            label: 'Delivered',
            value: stats.deliveredOrders,
            total: total,
            color: AdminColors.success,
            icon: Iconsax.tick_circle,
          ),
        ],
      ),
    );
  }
}
