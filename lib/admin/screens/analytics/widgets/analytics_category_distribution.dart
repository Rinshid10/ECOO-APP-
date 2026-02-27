import 'package:flutter/material.dart';
import '../../../core/admin_colors.dart';

/// Analytics category distribution widget
class AnalyticsCategoryDistribution extends StatelessWidget {
  const AnalyticsCategoryDistribution({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'name': 'Electronics', 'percentage': 35, 'color': AdminColors.accent},
      {'name': 'Fashion', 'percentage': 25, 'color': AdminColors.success},
      {'name': 'Sports', 'percentage': 18, 'color': AdminColors.warning},
      {'name': 'Beauty', 'percentage': 12, 'color': AdminColors.error},
      {'name': 'Others', 'percentage': 10, 'color': AdminColors.textSecondary},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AdminColors.border.withOpacity(0.5), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sales by Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          ...categories.map((category) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: category['color'] as Color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(category['name'] as String),
                      ],
                    ),
                    Text(
                      '${category['percentage']}%',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (category['percentage'] as int) / 100,
                    backgroundColor: AdminColors.border,
                    valueColor: AlwaysStoppedAnimation(category['color'] as Color),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
