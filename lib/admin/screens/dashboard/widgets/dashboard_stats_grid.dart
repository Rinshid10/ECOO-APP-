import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/admin_colors.dart';
import '../../../models/dashboard_stats.dart';
import 'dashboard_stat_card.dart';
import 'dashboard_utils.dart';

/// Dashboard stats grid widget
class DashboardStatsGrid extends StatelessWidget {
  final DashboardStats stats;

  const DashboardStatsGrid({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 1200;
    final isMedium = MediaQuery.of(context).size.width > 800;

    final statCards = [
      StatCardData(
        icon: Iconsax.dollar_circle,
        title: 'Total Revenue',
        value: '\$${DashboardUtils.formatNumber(stats.totalRevenue)}',
        change: '+${stats.revenueGrowth}%',
        isPositive: true,
        gradient: AdminColors.primaryGradient,
        bgColor: AdminColors.primarySurface,
      ),
      StatCardData(
        icon: Iconsax.shopping_bag,
        title: 'Total Orders',
        value: DashboardUtils.formatNumber(stats.totalOrders.toDouble()),
        change: '+${stats.ordersGrowth}%',
        isPositive: true,
        gradient: AdminColors.successGradient,
        bgColor: AdminColors.successLight,
      ),
      StatCardData(
        icon: Iconsax.people,
        title: 'Total Customers',
        value: DashboardUtils.formatNumber(stats.totalCustomers.toDouble()),
        change: '+${stats.customersGrowth}%',
        isPositive: true,
        gradient: AdminColors.accentGradient,
        bgColor: AdminColors.infoLight,
      ),
      StatCardData(
        icon: Iconsax.box,
        title: 'Total Products',
        value: stats.totalProducts.toString(),
        change: '${stats.lowStockProducts} low stock',
        isPositive: false,
        isWarning: true,
        gradient: AdminColors.warningGradient,
        bgColor: AdminColors.warningLight,
      ),
    ];

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWide ? 4 : (isMedium ? 2 : 1),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: isWide ? 1.5 : (isMedium ? 1.8 : 2.5),
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: statCards.length,
      itemBuilder: (context, index) => DashboardStatCard(data: statCards[index]),
    );
  }
}
