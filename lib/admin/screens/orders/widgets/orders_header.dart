import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/admin_colors.dart';

/// Orders header widget
class OrdersHeader extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final bool isMedium;

  const OrdersHeader({
    super.key,
    required this.onSearchChanged,
    required this.isMedium,
  });

  @override
  Widget build(BuildContext context) {
    if (isMedium) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Orders Management',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AdminColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Track and manage orders',
                    style: TextStyle(
                      color: AdminColors.textTertiary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Search
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AdminColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search orders...',
                    hintStyle: TextStyle(color: AdminColors.textTertiary, fontSize: 13),
                    prefixIcon: Icon(Iconsax.search_normal, color: AdminColors.textTertiary, size: 18),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Iconsax.export_1, size: 16),
              label: const Text('Export'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AdminColors.textSecondary,
                side: BorderSide(color: AdminColors.border),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      );
    }

    // Mobile layout
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Orders',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AdminColors.textPrimary,
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Iconsax.export_1, size: 14),
                label: const Text('Export'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AdminColors.textSecondary,
                  side: BorderSide(color: AdminColors.border),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AdminColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search orders...',
                hintStyle: TextStyle(color: AdminColors.textTertiary, fontSize: 13),
                prefixIcon: Icon(Iconsax.search_normal, color: AdminColors.textTertiary, size: 18),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
