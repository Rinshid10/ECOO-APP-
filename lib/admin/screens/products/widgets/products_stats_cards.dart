import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/admin_colors.dart';
import 'products_stat_card.dart';

/// Products stats cards widget
class ProductsStatsCards extends StatelessWidget {
  final int totalProducts;
  final int activeProducts;
  final int lowStock;
  final int outOfStock;

  const ProductsStatsCards({
    super.key,
    required this.totalProducts,
    required this.activeProducts,
    required this.lowStock,
    required this.outOfStock,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ProductsStatCard(
            label: 'Total Products',
            value: '$totalProducts',
            icon: Iconsax.box,
            color: AdminColors.primary,
            bgColor: AdminColors.primarySurface,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ProductsStatCard(
            label: 'Active',
            value: '$activeProducts',
            icon: Iconsax.tick_circle,
            color: AdminColors.success,
            bgColor: AdminColors.successLight,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ProductsStatCard(
            label: 'Low Stock',
            value: '$lowStock',
            icon: Iconsax.warning_2,
            color: AdminColors.warning,
            bgColor: AdminColors.warningLight,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ProductsStatCard(
            label: 'Out of Stock',
            value: '$outOfStock',
            icon: Iconsax.close_circle,
            color: AdminColors.error,
            bgColor: AdminColors.errorLight,
          ),
        ),
      ],
    );
  }
}
