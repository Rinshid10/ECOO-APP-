import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/admin_colors.dart';

/// Customer status badge widget
class CustomersStatusBadge extends StatelessWidget {
  final String status;

  const CustomersStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    switch (status) {
      case 'vip':
        color = AdminColors.warning;
        icon = Iconsax.crown5;
        break;
      case 'active':
        color = AdminColors.success;
        icon = Iconsax.tick_circle;
        break;
      default:
        color = AdminColors.textSecondary;
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
          Flexible(
            child: Text(
              status[0].toUpperCase() + status.substring(1),
              style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
