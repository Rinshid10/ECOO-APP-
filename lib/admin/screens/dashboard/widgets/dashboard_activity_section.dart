import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/admin_colors.dart';
import 'dashboard_activity_item.dart';

/// Dashboard activity section widget
class DashboardActivitySection extends StatelessWidget {
  const DashboardActivitySection({super.key});

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
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AdminColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Latest store activities',
                    style: TextStyle(
                      color: AdminColors.textTertiary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          DashboardActivityItem(
            icon: Iconsax.shopping_bag,
            color: AdminColors.success,
            title: 'New order placed',
            subtitle: 'Order #1234 by John Doe',
            time: '2 min ago',
          ),
          DashboardActivityItem(
            icon: Iconsax.profile_add,
            color: AdminColors.info,
            title: 'New customer registered',
            subtitle: 'Sarah Wilson joined the store',
            time: '15 min ago',
          ),
          DashboardActivityItem(
            icon: Iconsax.star,
            color: AdminColors.warning,
            title: 'New product review',
            subtitle: '5-star rating on iPhone 15',
            time: '1 hour ago',
          ),
          DashboardActivityItem(
            icon: Iconsax.box,
            color: AdminColors.primary,
            title: 'Product updated',
            subtitle: 'MacBook Pro stock updated',
            time: '2 hours ago',
            isLast: true,
          ),
        ],
      ),
    );
  }
}
