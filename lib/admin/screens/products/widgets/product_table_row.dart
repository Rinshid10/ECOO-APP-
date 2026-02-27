import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import '../../../core/admin_colors.dart';
import 'product_status_badge.dart';
import 'product_action_button.dart';

/// Product table row widget
class ProductTableRow extends StatelessWidget {
  final Map<String, dynamic> product;
  final bool isSelected;
  final VoidCallback onToggled;
  final VoidCallback? onDelete;

  const ProductTableRow({
    super.key,
    required this.product,
    required this.isSelected,
    required this.onToggled,
    this.onDelete,
  });

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Electronics':
        return Iconsax.cpu;
      case 'Fashion':
        return Iconsax.shopping_bag;
      case 'Sports':
        return Iconsax.weight;
      case 'Beauty':
        return Iconsax.brush_1;
      case 'Home':
        return Iconsax.home_2;
      default:
        return Iconsax.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: isSelected ? AdminColors.primarySurface.withOpacity(0.3) : Colors.transparent,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Checkbox
          Checkbox(
            value: isSelected,
            onChanged: (_) => onToggled(),
            activeColor: AdminColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(width: 8),

          // Product info
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: product['image'],
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'SKU: PRD-${product['id'].toString().padLeft(4, '0')}',
                        style: TextStyle(
                          color: AdminColors.textTertiary,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Category
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AdminColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    _getCategoryIcon(product['category']),
                    size: 14,
                    color: AdminColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    product['category'],
                    style: TextStyle(
                      color: AdminColors.textSecondary,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Price
          Expanded(
            child: Text(
              '\$${product['price'].toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AdminColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Stock
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: product['stock'] > 20
                        ? AdminColors.success
                        : (product['stock'] > 0 ? AdminColors.warning : AdminColors.error),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${product['stock']}',
                    style: TextStyle(
                      color: AdminColors.textSecondary,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Sold
          Expanded(
            child: Text(
              '${product['sold']}',
              style: TextStyle(
                color: AdminColors.textSecondary,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Status
          Expanded(
            child: ProductStatusBadge(status: product['status']),
          ),

          // Actions
          SizedBox(
            width: 90,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ProductActionButton(
                  icon: Iconsax.eye,
                  color: AdminColors.info,
                  onTap: () {},
                ),
                ProductActionButton(
                  icon: Iconsax.edit,
                  color: AdminColors.primary,
                  onTap: () {},
                ),
                ProductActionButton(
                  icon: Iconsax.trash,
                  color: AdminColors.error,
                  onTap: onDelete ?? () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
