import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/admin_colors.dart';
import 'widgets/categories_header.dart';
import 'widgets/category_card.dart';

/// Admin categories management screen
class AdminCategoriesScreen extends StatefulWidget {
  const AdminCategoriesScreen({super.key});

  @override
  State<AdminCategoriesScreen> createState() => _AdminCategoriesScreenState();
}

class _AdminCategoriesScreenState extends State<AdminCategoriesScreen> {
  final List<Map<String, dynamic>> _categories = [
    {'id': '1', 'name': 'Electronics', 'icon': Iconsax.cpu, 'products': 156, 'status': 'active', 'color': const Color(0xFF3B82F6)},
    {'id': '2', 'name': 'Fashion', 'icon': Iconsax.shopping_bag, 'products': 234, 'status': 'active', 'color': const Color(0xFFEC4899)},
    {'id': '3', 'name': 'Sports', 'icon': Iconsax.weight, 'products': 89, 'status': 'active', 'color': const Color(0xFF10B981)},
    {'id': '4', 'name': 'Beauty', 'icon': Iconsax.brush_1, 'products': 67, 'status': 'active', 'color': const Color(0xFFF59E0B)},
    {'id': '5', 'name': 'Home & Living', 'icon': Iconsax.home_2, 'products': 123, 'status': 'active', 'color': const Color(0xFF8B5CF6)},
    {'id': '6', 'name': 'Books', 'icon': Iconsax.book_1, 'products': 45, 'status': 'inactive', 'color': const Color(0xFF6366F1)},
    {'id': '7', 'name': 'Jewelry', 'icon': Iconsax.diamonds, 'products': 34, 'status': 'active', 'color': const Color(0xFFEF4444)},
    {'id': '8', 'name': 'Phones', 'icon': Iconsax.mobile, 'products': 78, 'status': 'active', 'color': const Color(0xFF14B8A6)},
  ];

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add New Category'),
        content: const SizedBox(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(decoration: InputDecoration(labelText: 'Category Name', border: OutlineInputBorder())),
              SizedBox(height: 16),
              TextField(decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder())),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Add')),
        ],
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [Icon(Iconsax.trash, color: AdminColors.error), SizedBox(width: 12), Text('Delete Category')],
        ),
        content: Text('Are you sure you want to delete "${category['name']}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() => _categories.removeWhere((c) => c['id'] == category['id']));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AdminColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          CategoriesHeader(
            categoryCount: _categories.length,
            onAddCategory: _showAddCategoryDialog,
          ),
          const SizedBox(height: 24),

          // Categories grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.3,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return CategoryCard(
                  category: category,
                  onToggleStatus: () {
                    setState(() {
                      category['status'] = category['status'] == 'active' ? 'inactive' : 'active';
                    });
                  },
                  onDelete: () => _showDeleteDialog(category),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
