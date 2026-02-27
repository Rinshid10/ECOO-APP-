import 'package:flutter/material.dart';
import 'product_card.dart';

/// Products grid widget
class ProductsGrid extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Set<String> selectedProducts;
  final Function(String) onProductToggled;

  const ProductsGrid({
    super.key,
    required this.products,
    required this.selectedProducts,
    required this.onProductToggled,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 280,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) => ProductCard(
        product: products[index],
        isSelected: selectedProducts.contains(products[index]['id']),
        onToggled: () => onProductToggled(products[index]['id']),
      ),
    );
  }
}
