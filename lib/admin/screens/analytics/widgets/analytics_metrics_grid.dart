import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/admin_colors.dart';
import 'analytics_metric_card.dart';

/// Analytics metrics grid widget
class AnalyticsMetricsGrid extends StatelessWidget {
  const AnalyticsMetricsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2,
      children: [
        AnalyticsMetricCard(
          title: 'Average Order Value',
          value: '\$89.50',
          icon: Iconsax.chart_1,
          color: AdminColors.accent,
        ),
        AnalyticsMetricCard(
          title: 'Conversion Rate',
          value: '3.24%',
          icon: Iconsax.percentage_circle,
          color: AdminColors.success,
        ),
        AnalyticsMetricCard(
          title: 'Cart Abandonment',
          value: '68.5%',
          icon: Iconsax.shopping_cart,
          color: AdminColors.warning,
        ),
        AnalyticsMetricCard(
          title: 'Customer Lifetime',
          value: '\$456.00',
          icon: Iconsax.people,
          color: AdminColors.info,
        ),
      ],
    );
  }
}
