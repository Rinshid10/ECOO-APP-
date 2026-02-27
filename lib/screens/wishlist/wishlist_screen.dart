import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/responsive.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/custom_snackbar.dart';
import '../../widgets/product/animated_product_card.dart';
import '../../widgets/common/animated_list_item.dart';
import '../product_detail/product_detail_screen.dart';

/// Wishlist screen - responsive grid layout
class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: isDesktop
          ? null
          : CustomAppBar(
              title: AppStrings.myWishlist,
              showBackButton: false,
              actions: [
                Consumer<WishlistProvider>(
                  builder: (context, wishlist, child) {
                    if (wishlist.isEmpty) return const SizedBox.shrink();
                    return TextButton.icon(
                      onPressed: () => _showClearConfirmation(context, wishlist),
                      icon: const Icon(Iconsax.trash, size: 18),
                      label: const Text('Clear'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                      ),
                    );
                  },
                ),
              ],
            ),
      body: Consumer<WishlistProvider>(
        builder: (context, wishlist, child) {
          if (wishlist.isEmpty) {
            return EmptyState.wishlist(
              onAction: () => Navigator.pop(context),
            );
          }

          final columns = Responsive.productGridColumns(context);

          return Column(
                children: [
                  // Desktop header
                  if (isDesktop)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: Row(
                        children: [
                          Text(
                            AppStrings.myWishlist,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () => _showClearConfirmation(context, wishlist),
                            icon: const Icon(Iconsax.trash, size: 18),
                            label: const Text('Clear All'),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Item count and actions
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.horizontalPadding(context),
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Iconsax.heart5, size: 16,
                                  color: AppColors.secondary),
                              const SizedBox(width: 6),
                              Text(
                                '${wishlist.itemCount} items',
                                style: const TextStyle(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () => _addAllToCart(context, wishlist),
                          icon: const Icon(Iconsax.shopping_cart, size: 18),
                          label: const Text('Add All'),
                        ),
                      ],
                    ),
                  ),

                  // Products grid
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.all(Responsive.horizontalPadding(context)),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: isDesktop ? 0.62 : 0.65,
                      ),
                      itemCount: wishlist.items.length,
                      itemBuilder: (context, index) {
                        final product = wishlist.items[index];
                        return StaggeredGridItem(
                          index: index,
                          columnCount: columns,
                          child: AnimatedProductCard(
                            product: product,
                            index: index,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailScreen(product: product),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
          );
        },
      ),
    );
  }

  void _showClearConfirmation(BuildContext context, WishlistProvider wishlist) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear Wishlist?'),
        content: const Text(
          'Are you sure you want to remove all items from your wishlist?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              wishlist.clearWishlist();
              Navigator.pop(context);
              CustomSnackBar.showSuccess(context, 'Wishlist cleared');
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _addAllToCart(BuildContext context, WishlistProvider wishlist) {
    HapticFeedback.mediumImpact();
    final cart = context.read<CartProvider>();

    for (final product in wishlist.items) {
      if (!cart.isInCart(product.id)) {
        cart.addToCart(product);
      }
    }

    CustomSnackBar.showSuccess(
      context,
      'All items added to cart',
      actionLabel: 'View Cart',
      onAction: () {},
    );
  }
}
