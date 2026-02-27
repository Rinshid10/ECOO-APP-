import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/admin_colors.dart';
import 'widgets/products_stats_cards.dart';
import 'widgets/products_header.dart';
import 'widgets/products_filters.dart';
import 'widgets/products_grid.dart';
import 'widgets/products_table.dart';
import 'widgets/product_add_dialog.dart';
import 'widgets/product_delete_dialog.dart';

/// Modern admin products management screen
class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isGridView = false;
  final Set<String> _selectedProducts = {};

  final List<Map<String, dynamic>> _products = [
    {
      'id': '1',
      'name': 'Wireless Earbuds Pro',
      'category': 'Electronics',
      'price': 99.99,
      'stock': 245,
      'status': 'active',
      'sold': 1250,
      'image': 'https://picsum.photos/seed/earbuds/200',
    },
    {
      'id': '2',
      'name': 'Smart Watch Series X',
      'category': 'Electronics',
      'price': 199.00,
      'stock': 89,
      'status': 'active',
      'sold': 890,
      'image': 'https://picsum.photos/seed/watch/200',
    },
    {
      'id': '3',
      'name': 'Premium Leather Bag',
      'category': 'Fashion',
      'price': 149.99,
      'stock': 56,
      'status': 'active',
      'sold': 456,
      'image': 'https://picsum.photos/seed/bag/200',
    },
    {
      'id': '4',
      'name': 'Running Shoes Elite',
      'category': 'Sports',
      'price': 129.00,
      'stock': 12,
      'status': 'low_stock',
      'sold': 2100,
      'image': 'https://picsum.photos/seed/shoes/200',
    },
    {
      'id': '5',
      'name': 'Organic Face Serum',
      'category': 'Beauty',
      'price': 44.00,
      'stock': 0,
      'status': 'out_of_stock',
      'sold': 780,
      'image': 'https://picsum.photos/seed/serum/200',
    },
    {
      'id': '6',
      'name': 'Vintage Desk Lamp',
      'category': 'Home',
      'price': 79.99,
      'stock': 34,
      'status': 'active',
      'sold': 320,
      'image': 'https://picsum.photos/seed/lamp/200',
    },
  ];

  final List<String> _categories = [
    'All',
    'Electronics',
    'Fashion',
    'Sports',
    'Beauty',
    'Home',
  ];

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _products.where((p) {
      final matchesCategory =
          _selectedCategory == 'All' || p['category'] == _selectedCategory;
      final matchesSearch = p['name']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    final totalProducts = _products.length;
    final activeProducts = _products.where((p) => p['status'] == 'active').length;
    final lowStock = _products.where((p) => p['status'] == 'low_stock').length;
    final outOfStock = _products.where((p) => p['status'] == 'out_of_stock').length;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats cards
          ProductsStatsCards(
            totalProducts: totalProducts,
            activeProducts: activeProducts,
            lowStock: lowStock,
            outOfStock: outOfStock,
          ),
          const SizedBox(height: 24),

          // Header with actions
          ProductsHeader(
            productCount: filteredProducts.length,
            selectedCount: _selectedProducts.length,
            onClearSelection: () => setState(() => _selectedProducts.clear()),
            onAddProduct: _showAddProductDialog,
          ),
          const SizedBox(height: 20),

          // Filters
          ProductsFilters(
            searchQuery: _searchQuery,
            onSearchChanged: (value) => setState(() => _searchQuery = value),
            selectedCategory: _selectedCategory,
            onCategoryChanged: (value) => setState(() => _selectedCategory = value),
            categories: _categories,
            isGridView: _isGridView,
            onViewChanged: (value) => setState(() => _isGridView = value),
          ),
          const SizedBox(height: 20),

          // Products table or grid
          Expanded(
            child: _isGridView
                ? ProductsGrid(
                    products: filteredProducts,
                    selectedProducts: _selectedProducts,
                    onProductToggled: (productId) {
                      setState(() {
                        if (_selectedProducts.contains(productId)) {
                          _selectedProducts.remove(productId);
                        } else {
                          _selectedProducts.add(productId);
                        }
                      });
                    },
                  )
                : ProductsTable(
                    products: filteredProducts,
                    selectedProducts: _selectedProducts,
                    onProductToggled: (productId) {
                      setState(() {
                        if (_selectedProducts.contains(productId)) {
                          _selectedProducts.remove(productId);
                        } else {
                          _selectedProducts.add(productId);
                        }
                      });
                    },
                    onSelectAll: () {
                      setState(() {
                        if (_selectedProducts.length == filteredProducts.length) {
                          _selectedProducts.clear();
                        } else {
                          _selectedProducts.addAll(
                            filteredProducts.map((p) => p['id'] as String),
                          );
                        }
                      });
                    },
                    onDelete: _showDeleteDialog,
                  ),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) => ProductAddDialog(categories: _categories),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => ProductDeleteDialog(
        product: product,
        onDelete: () {
          setState(() => _products.removeWhere((p) => p['id'] == product['id']));
        },
      ),
    );
  }
}
