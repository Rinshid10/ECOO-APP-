import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/admin_colors.dart';

/// Order more menu widget
class OrderMoreMenu extends StatelessWidget {
  final Map<String, dynamic> order;
  final Function(String) onStatusChanged;

  const OrderMoreMenu({
    super.key,
    required this.order,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AdminColors.surfaceVariant,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(Iconsax.more, size: 16, color: AdminColors.textSecondary),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'processing',
          child: const Text('Mark Processing', style: TextStyle(fontSize: 13)),
        ),
        PopupMenuItem(
          value: 'shipped',
          child: const Text('Mark Shipped', style: TextStyle(fontSize: 13)),
        ),
        PopupMenuItem(
          value: 'delivered',
          child: const Text('Mark Delivered', style: TextStyle(fontSize: 13)),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'cancelled',
          child: Text('Cancel Order', style: TextStyle(color: AdminColors.error, fontSize: 13)),
        ),
      ],
      onSelected: (value) => onStatusChanged(value),
    );
  }
}
