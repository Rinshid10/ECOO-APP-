import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/category_model.dart';

/// Category card widget for displaying categories
/// Shows category icon/image, name, and product count
class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback? onTap;
  final bool showProductCount;
  final CategoryCardStyle style;

  const CategoryCard({
    super.key,
    required this.category,
    this.onTap,
    this.showProductCount = true,
    this.style = CategoryCardStyle.icon,
  });

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case CategoryCardStyle.icon:
        return _buildIconStyle(context);
      case CategoryCardStyle.image:
        return _buildImageStyle(context);
      case CategoryCardStyle.compact:
        return _buildCompactStyle(context);
    }
  }

  /// Icon style category card
  Widget _buildIconStyle(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon container
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              category.icon,
              size: 32,
              color: category.color,
            ),
          ),
          const SizedBox(height: 8),

          // Category name
          Text(
            category.name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),

          // Product count
          if (showProductCount)
            Text(
              '${category.productCount} items',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textLight,
                    fontSize: 11,
                  ),
            ),
        ],
      ),
    );
  }

  /// Image style category card
  Widget _buildImageStyle(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background image
              CachedNetworkImage(
                imageUrl: category.imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: AppColors.grey200,
                  highlightColor: AppColors.grey100,
                  child: Container(color: AppColors.grey200),
                ),
                errorWidget: (context, url, error) => Container(
                  color: category.color.withOpacity(0.3),
                  child: Icon(
                    category.icon,
                    size: 40,
                    color: category.color,
                  ),
                ),
              ),

              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),

              // Category info
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (showProductCount)
                      Text(
                        '${category.productCount} items',
                        style: TextStyle(
                          color: AppColors.textWhite.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Compact style category card (horizontal)
  Widget _buildCompactStyle(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                category.icon,
                size: 24,
                color: category.color,
              ),
            ),
            const SizedBox(width: 16),

            // Category info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 16,
                        ),
                  ),
                  if (showProductCount)
                    Text(
                      '${category.productCount} items',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textLight,
                          ),
                    ),
                ],
              ),
            ),

            // Arrow icon
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.textLight,
            ),
          ],
        ),
      ),
    );
  }
}

/// Category card style options
enum CategoryCardStyle {
  icon,
  image,
  compact,
}
