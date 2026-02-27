import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/admin_colors.dart';
import 'customers_stat_card.dart';

/// Customers stats cards widget
class CustomersStatsCards extends StatelessWidget {
  final int totalCustomers;
  final int activeCustomers;
  final int vipCustomers;
  final int inactiveCustomers;

  const CustomersStatsCards({
    super.key,
    required this.totalCustomers,
    required this.activeCustomers,
    required this.vipCustomers,
    required this.inactiveCustomers,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomersStatCard(
            title: 'Total Customers',
            value: '$totalCustomers',
            icon: Iconsax.people,
            color: AdminColors.accent,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomersStatCard(
            title: 'Active',
            value: '$activeCustomers',
            icon: Iconsax.tick_circle,
            color: AdminColors.success,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomersStatCard(
            title: 'VIP Members',
            value: '$vipCustomers',
            icon: Iconsax.crown,
            color: AdminColors.warning,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomersStatCard(
            title: 'Inactive',
            value: '$inactiveCustomers',
            icon: Iconsax.user_remove,
            color: AdminColors.error,
          ),
        ),
      ],
    );
  }
}
