import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/admin_colors.dart';
import '../../../models/dashboard_stats.dart';

/// Dashboard revenue chart widget
class DashboardRevenueChart extends StatelessWidget {
  final DashboardStats stats;

  const DashboardRevenueChart({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final maxValue = stats.revenueChart
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b);

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
                    'Revenue Overview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AdminColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Monthly revenue performance',
                    style: TextStyle(
                      color: AdminColors.textTertiary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AdminColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AdminColors.border),
                ),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.calendar_1,
                      size: 16,
                      color: AdminColors.textTertiary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'This Month',
                      style: TextStyle(
                        color: AdminColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Iconsax.arrow_down_1,
                      size: 16,
                      color: AdminColors.textTertiary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 220,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: stats.revenueChart.asMap().entries.map((entry) {
                final data = entry.value;
                final percentage = data.value / maxValue;
                final isHighest = data.value == maxValue;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '\$${(data.value / 1000).toStringAsFixed(1)}k',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isHighest ? FontWeight.bold : FontWeight.normal,
                            color: isHighest
                                ? AdminColors.primary
                                : AdminColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Flexible(
                          child: FractionallySizedBox(
                            heightFactor: percentage,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: isHighest
                                    ? AdminColors.primaryGradient
                                    : LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          AdminColors.primary.withOpacity(0.4),
                                          AdminColors.primary.withOpacity(0.7),
                                        ],
                                      ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          data.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AdminColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
