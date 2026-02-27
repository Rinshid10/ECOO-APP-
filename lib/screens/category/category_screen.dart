import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/responsive.dart';
import '../../data/repositories/product_repository.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/category/category_card.dart';
import 'category_products_screen.dart';

/// Category screen - responsive grid layout
class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ProductRepository.categories;
    final isDesktop = Responsive.isDesktop(context);
    final columns = Responsive.value(context, mobile: 2, tablet: 3, desktop: 5);

    return Scaffold(
      appBar: isDesktop
          ? null
          : const CustomAppBar(
              title: AppStrings.allCategories,
              showBackButton: false,
            ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Text(
                AppStrings.allCategories,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          Expanded(
            child: GridView.builder(
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
          ),
        ],
      ),
    );
  }
}
