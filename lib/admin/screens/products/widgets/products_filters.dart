import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/services.dart';
import '../../../core/admin_colors.dart';

/// Products filters widget
class ProductsFilters extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final List<String> categories;
  final bool isGridView;
  final ValueChanged<bool> onViewChanged;

  const ProductsFilters({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.categories,
    required this.isGridView,
    required this.onViewChanged,
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
    return Row(
      children: [
        // Search
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              color: AdminColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AdminColors.border),
            ),
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search products by name, SKU...',
                hintStyle: TextStyle(color: AdminColors.textTertiary),
                prefixIcon: Icon(Iconsax.search_normal, color: AdminColors.textTertiary, size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Category filter
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AdminColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AdminColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCategory,
              icon: Icon(Iconsax.arrow_down_1, color: AdminColors.textTertiary, size: 18),
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Row(
                    children: [
                      Icon(
                        category == 'All'
                            ? Iconsax.category
                            : _getCategoryIcon(category),
                        size: 18,
                        color: AdminColors.textSecondary,
                      ),
                      const SizedBox(width: 10),
                      Text(category),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) onCategoryChanged(value);
              },
            ),
          ),
        ),
        const SizedBox(width: 16),

        // View toggle
        Container(
          decoration: BoxDecoration(
            color: AdminColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AdminColors.border),
          ),
          child: Row(
            children: [
              _viewToggle(Iconsax.menu_1, !isGridView, () => onViewChanged(false)),
              _viewToggle(Iconsax.element_3, isGridView, () => onViewChanged(true)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _viewToggle(IconData icon, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? AdminColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: isActive ? AdminColors.primary : AdminColors.textTertiary,
          size: 20,
        ),
      ),
    );
  }
}
