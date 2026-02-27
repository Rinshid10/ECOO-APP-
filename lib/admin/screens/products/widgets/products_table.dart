import 'package:flutter/material.dart';
import '../../../core/admin_colors.dart';
import 'product_table_row.dart';

/// Products table widget
class ProductsTable extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Set<String> selectedProducts;
  final Function(String) onProductToggled;
  final Function() onSelectAll;
  final Function(Map<String, dynamic>)? onDelete;

  const ProductsTable({
    super.key,
    required this.products,
    required this.selectedProducts,
    required this.onProductToggled,
    required this.onSelectAll,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AdminColors.cardShadow,
        border: Border.all(color: AdminColors.border.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AdminColors.surfaceVariant.withOpacity(0.5),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                // Checkbox
                Checkbox(
                  value: selectedProducts.length == products.length && products.isNotEmpty,
                  onChanged: (_) => onSelectAll(),
                  activeColor: AdminColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                const SizedBox(width: 8),
                const Expanded(flex: 3, child: Text('Product', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                const Expanded(flex: 2, child: Text('Category', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                const Expanded(child: Text('Price', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                const Expanded(child: Text('Stock', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                const Expanded(child: Text('Sold', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                const Expanded(child: Text('Status', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                const SizedBox(width: 90, child: Text('Actions', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
              ],
            ),
          ),

          // Table body
          Expanded(
            child: ListView.separated(
              itemCount: products.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: AdminColors.border.withOpacity(0.5)),
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductTableRow(
                  product: product,
                  isSelected: selectedProducts.contains(product['id']),
                  onToggled: () => onProductToggled(product['id']),
                  onDelete: onDelete != null ? () => onDelete!(product) : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
