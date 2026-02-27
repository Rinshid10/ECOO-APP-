import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/admin_colors.dart';

/// Product status badge widget
class ProductStatusBadge extends StatelessWidget {
  final String status;

  const ProductStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    String label;

    switch (status) {
      case 'active':
        color = AdminColors.success;
        icon = Iconsax.tick_circle;
        label = 'Active';
        break;
      case 'low_stock':
        color = AdminColors.warning;
        icon = Iconsax.warning_2;
        label = 'Low Stock';
        break;
      case 'out_of_stock':
        color = AdminColors.error;
        icon = Iconsax.close_circle;
        label = 'Out of Stock';
        break;
      default:
        color = AdminColors.textSecondary;
        icon = Iconsax.minus_cirlce;
        label = 'Inactive';
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
            label,
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
