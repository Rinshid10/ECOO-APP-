import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/admin_colors.dart';

/// Dashboard order status badge widget
class DashboardOrderStatusBadge extends StatelessWidget {
  final String status;

  const DashboardOrderStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    switch (status.toLowerCase()) {
      case 'pending':
        color = AdminColors.warning;
        icon = Iconsax.clock;
        break;
      case 'processing':
        color = AdminColors.info;
        icon = Iconsax.refresh_circle;
        break;
      case 'shipped':
        color = AdminColors.accent;
        icon = Iconsax.truck_fast;
        break;
      case 'delivered':
        color = AdminColors.success;
        icon = Iconsax.tick_circle;
        break;
      default:
        color = AdminColors.textTertiary;
        icon = Iconsax.minus_cirlce;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            status.substring(0, 1).toUpperCase() + status.substring(1),
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
