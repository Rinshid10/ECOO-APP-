import 'package:flutter/material.dart';
import '../../../core/admin_colors.dart';

/// Order info chip widget
class OrderInfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const OrderInfoChip({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AdminColors.surfaceVariant,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AdminColors.textTertiary),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(fontSize: 11, color: AdminColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
