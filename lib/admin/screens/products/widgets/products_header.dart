import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/admin_colors.dart';

/// Products header widget
class ProductsHeader extends StatelessWidget {
  final int productCount;
  final int selectedCount;
  final VoidCallback onClearSelection;
  final VoidCallback onAddProduct;

  const ProductsHeader({
    super.key,
    required this.productCount,
    required this.selectedCount,
    required this.onClearSelection,
    required this.onAddProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Products Inventory',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AdminColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$productCount items found',
              style: TextStyle(
                color: AdminColors.textTertiary,
                fontSize: 13,
              ),
            ),
          ],
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // Bulk actions (when items selected)
            if (selectedCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AdminColors.errorLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$selectedCount selected',
                      style: TextStyle(
                        color: AdminColors.error,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onClearSelection,
                      child: Icon(Iconsax.close_circle, color: AdminColors.error, size: 18),
                    ),
                  ],
                ),
              ),
            // Export button
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Iconsax.export_1, size: 16),
              label: const Text('Export'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AdminColors.textSecondary,
                side: BorderSide(color: AdminColors.border),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            // Add product button
            ElevatedButton.icon(
              onPressed: onAddProduct,
              icon: const Icon(Iconsax.add, size: 16),
              label: const Text('Add'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AdminColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
