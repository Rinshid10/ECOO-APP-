import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/admin_colors.dart';

/// Stat card data model
class StatCardData {
  final IconData icon;
  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final bool isWarning;
  final LinearGradient gradient;
  final Color bgColor;

  StatCardData({
    required this.icon,
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    this.isWarning = false,
    required this.gradient,
    required this.bgColor,
  });
}

/// Dashboard stat card widget
class DashboardStatCard extends StatelessWidget {
  final StatCardData data;

  const DashboardStatCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AdminColors.cardShadow,
        border: Border.all(color: AdminColors.border.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: data.gradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: data.gradient.colors.first.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(data.icon, color: Colors.white, size: 20),
              ),
              // Change indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: data.isWarning
                      ? AdminColors.warningLight
                      : (data.isPositive
                          ? AdminColors.successLight
                          : AdminColors.errorLight),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      data.isWarning
                          ? Iconsax.warning_2
                          : (data.isPositive
                              ? Iconsax.arrow_up_3
                              : Iconsax.arrow_down_2),
                      size: 12,
                      color: data.isWarning
                          ? AdminColors.warning
                          : (data.isPositive
                              ? AdminColors.success
                              : AdminColors.error),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      data.change,
                      style: TextStyle(
                        color: data.isWarning
                            ? AdminColors.warning
                            : (data.isPositive
                                ? AdminColors.success
                                : AdminColors.error),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Value
          Text(
            data.value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AdminColors.textPrimary,
            ),
          ),
          // Title
          Text(
            data.title,
            style: TextStyle(
              color: AdminColors.textTertiary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
