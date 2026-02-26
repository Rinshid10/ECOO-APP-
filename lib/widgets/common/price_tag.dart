import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Animated price tag with discount display
/// Features count-up animation for price changes
class AnimatedPriceTag extends StatelessWidget {
  final double price;
  final double? originalPrice;
  final TextStyle? priceStyle;
  final TextStyle? originalPriceStyle;
  final bool showCurrency;
  final String currency;
  final Duration animationDuration;

  const AnimatedPriceTag({
    super.key,
    required this.price,
    this.originalPrice,
    this.priceStyle,
    this.originalPriceStyle,
    this.showCurrency = true,
    this.currency = '\$',
    this.animationDuration = const Duration(milliseconds: 500),
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  int? get discountPercentage {
    if (hasDiscount) {
      return (((originalPrice! - price) / originalPrice!) * 100).round();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Current price with animation
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: price),
          duration: animationDuration,
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Text(
              '${showCurrency ? currency : ''}${value.toStringAsFixed(2)}',
              style: priceStyle ??
                  TextStyle(
                    color: AppColors.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
            );
          },
        ),

        // Original price and discount
        if (hasDiscount) ...[
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Discount badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '-$discountPercentage%',
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              // Original price
              Text(
                '${showCurrency ? currency : ''}${originalPrice!.toStringAsFixed(2)}',
                style: originalPriceStyle ??
                    const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 14,
                      decoration: TextDecoration.lineThrough,
                    ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Simple price display with styling
class PriceText extends StatelessWidget {
  final double price;
  final String currency;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextDecoration? decoration;

  const PriceText({
    super.key,
    required this.price,
    this.currency = '\$',
    this.fontSize = 16,
    this.fontWeight = FontWeight.bold,
    this.color,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$currency${price.toStringAsFixed(2)}',
      style: TextStyle(
        color: color ?? AppColors.primary,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: decoration,
      ),
    );
  }
}

/// Savings badge display
class SavingsBadge extends StatelessWidget {
  final double savings;
  final String currency;

  const SavingsBadge({
    super.key,
    required this.savings,
    this.currency = '\$',
  });

  @override
  Widget build(BuildContext context) {
    if (savings <= 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.success.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.savings_outlined,
            color: AppColors.success,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            'Save $currency${savings.toStringAsFixed(2)}',
            style: const TextStyle(
              color: AppColors.success,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
