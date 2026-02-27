import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/admin_colors.dart';

/// Categories screen header widget
class CategoriesHeader extends StatelessWidget {
  final int categoryCount;
  final VoidCallback onAddCategory;

  const CategoriesHeader({
    super.key,
    required this.categoryCount,
    required this.onAddCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$categoryCount Categories',
          style: const TextStyle(color: AdminColors.textSecondary),
        ),
        ElevatedButton.icon(
          onPressed: onAddCategory,
          icon: const Icon(Iconsax.add),
          label: const Text('Add Category'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AdminColors.accent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}
