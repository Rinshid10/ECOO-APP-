import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/cart_item_model.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/animated_quantity_selector.dart';
import '../../widgets/common/animated_list_item.dart';
import '../checkout/checkout_screen.dart';

/// Cart screen displaying items in shopping cart
/// Shows item list, quantities, and order summary with animations
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppStrings.myCart,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.isEmpty) {
            return EmptyState.cart(
              onAction: () => Navigator.pop(context),
            );
          }
          return Column(
            children: [
              // Free shipping progress
              if (cart.subtotal < 50) _buildFreeShippingProgress(context, cart),

              // Cart items list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    return AnimatedListItem(
                      index: index,
                      child: _buildCartItem(context, cart.items[index], cart),
                    );
                  },
                ),
              ),

              // Order summary and checkout
              _buildOrderSummary(context, cart),
            ],
          );
        },
      ),
    );
  }

  /// Build free shipping progress indicator
  Widget _buildFreeShippingProgress(BuildContext context, CartProvider cart) {
    final remaining = 50 - cart.subtotal;
    final progress = (cart.subtotal / 50).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Iconsax.truck_fast, color: AppColors.accent, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Add \$${remaining.toStringAsFixed(2)} more for FREE shipping!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: value,
                  backgroundColor: AppColors.grey200,
                  valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                  minHeight: 8,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Build individual cart item with swipe to delete
  Widget _buildCartItem(BuildContext context, CartItem item, CartProvider cart) {
    return Dismissible(
      key: Key(item.product.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        HapticFeedback.mediumImpact();
        return true;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.error, Color(0xFFDC2626)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Iconsax.trash, color: AppColors.textWhite, size: 28),
            const SizedBox(height: 4),
            Text(
              'Delete',
              style: TextStyle(
                color: AppColors.textWhite.withOpacity(0.9),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (_) => cart.removeFromCart(item.product.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Row(
            children: [
              // Product image
              Hero(
                tag: 'cart_${item.product.id}',
                child: CachedNetworkImage(
                  imageUrl: item.product.imageUrl,
                  width: 110,
                  height: 130,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.grey200,
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.grey200,
                    child: const Icon(Iconsax.image),
                  ),
                ),
              ),

              // Product details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product name
                      Text(
                        item.product.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Size and color chips
                      if (item.selectedSize != null || item.selectedColor != null)
                        Wrap(
                          spacing: 6,
                          children: [
                            if (item.selectedSize != null)
                              _buildChip(context, item.selectedSize!),
                            if (item.selectedColor != null)
                              _buildChip(context, item.selectedColor!),
                          ],
                        ),
                      const SizedBox(height: 12),

                      // Price and quantity
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\$${item.totalPrice.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              if (item.product.hasDiscount)
                                Text(
                                  '\$${(item.product.originalPrice! * item.quantity).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: AppColors.textLight,
                                    fontSize: 12,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                            ],
                          ),

                          // Animated quantity selector
                          AnimatedQuantitySelector(
                            quantity: item.quantity,
                            compact: true,
                            onChanged: (quantity) {
                              cart.updateQuantity(item.product.id, quantity);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build small chip
  Widget _buildChip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
      ),
    );
  }

  /// Build order summary section
  Widget _buildOrderSummary(BuildContext context, CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.15),
            blurRadius: 25,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag indicator
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Coupon code input
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.05),
                    AppColors.primaryLight.withOpacity(0.05),
                  ],
                ),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Iconsax.discount_shape, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: AppStrings.couponCode,
                        hintStyle: TextStyle(color: AppColors.textLight),
                        border: InputBorder.none,
                        fillColor: Colors.transparent,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      AppStrings.apply,
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Summary rows with animations
            _buildAnimatedSummaryRow(context, AppStrings.subtotal,
                '\$${cart.subtotal.toStringAsFixed(2)}', 0),
            const SizedBox(height: 10),
            _buildAnimatedSummaryRow(
                context,
                AppStrings.shipping,
                cart.shippingCost == 0
                    ? 'FREE'
                    : '\$${cart.shippingCost.toStringAsFixed(2)}',
                1,
                valueColor: cart.shippingCost == 0 ? AppColors.accent : null),
            const SizedBox(height: 10),
            _buildAnimatedSummaryRow(context, AppStrings.tax,
                '\$${cart.tax.toStringAsFixed(2)}', 2),

            // Savings badge
            if (cart.totalSavings > 0) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.savings_outlined,
                        color: AppColors.success, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'You\'re saving \$${cart.totalSavings.toStringAsFixed(2)}!',
                      style: const TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const Divider(height: 28),

            // Total row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.total,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: cart.total),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Text(
                      '\$${value.toStringAsFixed(2)}',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Checkout button with animation
            CustomButton(
              text: '${AppStrings.checkout} (${cart.itemCount} items)',
              icon: Iconsax.shopping_bag,
              onPressed: () {
                HapticFeedback.mediumImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CheckoutScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Build animated summary row
  Widget _buildAnimatedSummaryRow(
    BuildContext context,
    String label,
    String value,
    int index, {
    Color? valueColor,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOut,
      builder: (context, animValue, child) {
        return Opacity(
          opacity: animValue,
          child: Transform.translate(
            offset: Offset(20 * (1 - animValue), 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: valueColor,
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
