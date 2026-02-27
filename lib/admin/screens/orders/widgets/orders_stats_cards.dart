import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/admin_colors.dart';
import 'orders_stat_card.dart';

/// Orders stats cards widget
class OrdersStatsCards extends StatelessWidget {
  final List<Map<String, dynamic>> orders;
  final bool isWide;
  final bool isMedium;

  const OrdersStatsCards({
    super.key,
    required this.orders,
    required this.isWide,
    required this.isMedium,
  });

  @override
  Widget build(BuildContext context) {
    final totalRevenue = orders.fold<double>(0, (sum, o) => sum + (o['total'] as double));

    final stats = [
      {
        'label': 'Total Orders',
        'value': '${orders.length}',
        'icon': Iconsax.receipt_1,
        'color': AdminColors.primary,
        'bg': AdminColors.primarySurface
      },
      {
        'label': 'Pending',
        'value': '${orders.where((o) => o['status'] == 'pending').length}',
        'icon': Iconsax.clock,
        'color': AdminColors.warning,
        'bg': AdminColors.warningLight
      },
      {
        'label': 'Completed',
        'value': '${orders.where((o) => o['status'] == 'delivered').length}',
        'icon': Iconsax.tick_circle,
        'color': AdminColors.success,
        'bg': AdminColors.successLight
      },
      {
        'label': 'Revenue',
        'value': '\$${totalRevenue.toStringAsFixed(0)}',
        'icon': Iconsax.dollar_circle,
        'color': AdminColors.accent,
        'bg': AdminColors.infoLight
      },
    ];

    if (isWide) {
      return Row(
        children: stats.asMap().entries.map((entry) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: entry.key < stats.length - 1 ? 12 : 0),
              child: OrdersStatCard(
                label: entry.value['label'] as String,
                value: entry.value['value'] as String,
                icon: entry.value['icon'] as IconData,
                color: entry.value['color'] as Color,
                bgColor: entry.value['bg'] as Color,
              ),
            ),
          );
        }).toList(),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMedium ? 4 : 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: isMedium ? 2.2 : 1.8,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) => OrdersStatCard(
        label: stats[index]['label'] as String,
        value: stats[index]['value'] as String,
        icon: stats[index]['icon'] as IconData,
        color: stats[index]['color'] as Color,
        bgColor: stats[index]['bg'] as Color,
      ),
    );
  }
}
