import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';

/// Shimmer loading widget for skeleton loading states
/// Provides smooth loading animations for various content types
class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Widget? child;

  const ShimmerLoading({
    super.key,
    this.width = double.infinity,
    this.height = 100,
    this.borderRadius = 12,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.grey800 : AppColors.grey200,
      highlightColor: isDark ? AppColors.grey700 : AppColors.grey100,
      child: child ??
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: AppColors.grey200,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
    );
  }
}

/// Product card shimmer loading
class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          ShimmerLoading(
            height: 140,
            borderRadius: 16,
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.grey200,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand
                const ShimmerLoading(width: 60, height: 12, borderRadius: 6),
                const SizedBox(height: 8),
                // Name
                const ShimmerLoading(width: double.infinity, height: 16, borderRadius: 6),
                const SizedBox(height: 4),
                const ShimmerLoading(width: 100, height: 16, borderRadius: 6),
                const SizedBox(height: 12),
                // Rating
                const ShimmerLoading(width: 80, height: 14, borderRadius: 6),
                const SizedBox(height: 8),
                // Price
                const ShimmerLoading(width: 70, height: 20, borderRadius: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Category card shimmer loading
class CategoryCardShimmer extends StatelessWidget {
  const CategoryCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShimmerLoading(
          width: 70,
          height: 70,
          borderRadius: 20,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.grey200,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const ShimmerLoading(width: 60, height: 12, borderRadius: 6),
      ],
    );
  }
}

/// Banner shimmer loading
class BannerShimmer extends StatelessWidget {
  const BannerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      height: 180,
      borderRadius: 20,
      child: Container(
        height: 180,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.grey200,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

/// List item shimmer loading
class ListItemShimmer extends StatelessWidget {
  const ListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ShimmerLoading(
            width: 80,
            height: 80,
            borderRadius: 12,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.grey200,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerLoading(width: double.infinity, height: 16, borderRadius: 6),
                const SizedBox(height: 8),
                const ShimmerLoading(width: 100, height: 14, borderRadius: 6),
                const SizedBox(height: 8),
                const ShimmerLoading(width: 80, height: 18, borderRadius: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
