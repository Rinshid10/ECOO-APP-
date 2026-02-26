import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/responsive.dart';
import '../../data/repositories/product_repository.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/category/category_card.dart';
import 'category_products_screen.dart';

/// Category screen displaying all product categories
/// Shows categories in a grid layout with images
class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ProductRepository.categories;
    final columns = Responsive.value(context, mobile: 2, tablet: 3, desktop: 4);

    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.allCategories,
        showBackButton: false,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(Responsive.horizontalPadding(context)),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return CategoryCard(
            category: category,
            style: CategoryCardStyle.image,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryProductsScreen(
                    category: category,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
