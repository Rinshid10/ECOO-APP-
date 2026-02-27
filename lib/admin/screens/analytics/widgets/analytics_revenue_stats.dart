import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/admin_colors.dart';
import 'analytics_stat_card.dart';

/// Analytics revenue stats widget
class AnalyticsRevenueStats extends StatelessWidget {
  const AnalyticsRevenueStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AnalyticsStatCard(
            title: 'Total Revenue',
            value: '\$125,840',
            change: '+12.5%',
            isPositive: true,
            gradient: AdminColors.accentGradient,
            icon: Iconsax.dollar_circle,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AnalyticsStatCard(
            title: 'Net Profit',
            value: '\$45,620',
            change: '+8.2%',
            isPositive: true,
            gradient: AdminColors.successGradient,
            icon: Iconsax.money_recive,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AnalyticsStatCard(
            title: 'Expenses',
            value: '\$32,450',
            change: '-5.4%',
            isPositive: false,
            gradient: AdminColors.warningGradient,
            icon: Iconsax.money_send,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AnalyticsStatCard(
            title: 'Refunds',
            value: '\$2,840',
            change: '+2.1%',
            isPositive: false,
            gradient: AdminColors.errorGradient,
            icon: Iconsax.money_remove,
          ),
        ),
      ],
    );
  }
}
