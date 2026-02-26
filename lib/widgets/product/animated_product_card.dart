import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/product_model.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/cart_provider.dart';
import '../common/shimmer_loading.dart';

/// Animated product card with enhanced interactions
/// Features tap animations, wishlist toggle, and quick add to cart
class AnimatedProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;
  final bool showQuickAdd;
  final int index;

  const AnimatedProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.showQuickAdd = true,
    this.index = 0,
  });

  @override
  State<AnimatedProductCard> createState() => _AnimatedProductCardState();
}

class _AnimatedProductCardState extends State<AnimatedProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    // Stagger animation based on index
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (widget.index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onTap?.call();
        },
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: _buildCard(context),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _isPressed
                ? AppColors.primary.withOpacity(0.15)
                : AppColors.shadow.withOpacity(0.08),
            blurRadius: _isPressed ? 20 : 15,
            offset: Offset(0, _isPressed ? 8 : 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          _buildImageSection(context),

          // Details section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand
                  Text(
                    widget.product.brand,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),

                  // Name
                  Text(
                    widget.product.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),

                  // Rating
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: widget.product.rating,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star_rounded,
                          color: AppColors.warning,
                        ),
                        itemCount: 5,
                        itemSize: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${widget.product.reviewCount})',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textLight,
                              fontSize: 11,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Price and quick add
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPriceSection(context),
                      if (widget.showQuickAdd) _buildQuickAddButton(context),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Stack(
      children: [
        // Product image with hero animation
        Hero(
          tag: 'product_${widget.product.id}',
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: CachedNetworkImage(
              imageUrl: widget.product.imageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => const ShimmerLoading(
                height: 140,
                borderRadius: 0,
              ),
              errorWidget: (context, url, error) => Container(
                height: 140,
                color: AppColors.grey100,
                child: const Icon(Iconsax.image, size: 40, color: AppColors.grey400),
              ),
            ),
          ),
        ),

        // Discount badge
        if (widget.product.hasDiscount)
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.secondary, AppColors.secondaryDark],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                '-${widget.product.discountPercentage}%',
                style: const TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        // Wishlist button
        Positioned(
          top: 10,
          right: 10,
          child: _buildWishlistButton(context),
        ),

        // New arrival badge
        if (widget.product.isNewArrival)
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'NEW',
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),

        // Out of stock overlay
        if (!widget.product.isInStock)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: const Center(
                child: Text(
                  'Out of Stock',
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildWishlistButton(BuildContext context) {
    return Consumer<WishlistProvider>(
      builder: (context, wishlist, child) {
        final isInWishlist = wishlist.isInWishlist(widget.product.id);

        return GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            wishlist.toggleWishlist(widget.product);
          },
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 1, end: isInWishlist ? 1.2 : 1),
            duration: const Duration(milliseconds: 200),
            curve: Curves.elasticOut,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isInWishlist
                        ? AppColors.secondary.withOpacity(0.1)
                        : AppColors.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow.withOpacity(0.15),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      isInWishlist ? Iconsax.heart5 : Iconsax.heart,
                      key: ValueKey(isInWishlist),
                      size: 20,
                      color: isInWishlist
                          ? AppColors.secondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPriceSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '\$${widget.product.price.toStringAsFixed(2)}',
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (widget.product.hasDiscount)
          Text(
            '\$${widget.product.originalPrice!.toStringAsFixed(2)}',
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 12,
              decoration: TextDecoration.lineThrough,
            ),
          ),
      ],
    );
  }

  Widget _buildQuickAddButton(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final isInCart = cart.isInCart(widget.product.id);

        return GestureDetector(
          onTap: widget.product.isInStock
              ? () {
                  HapticFeedback.mediumImpact();
                  if (!isInCart) {
                    cart.addToCart(widget.product);
                  }
                }
              : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isInCart ? AppColors.success : AppColors.primary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: (isInCart ? AppColors.success : AppColors.primary)
                      .withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isInCart ? Icons.check_rounded : Iconsax.add,
                key: ValueKey(isInCart),
                color: AppColors.textWhite,
                size: 20,
              ),
            ),
          ),
        );
      },
    );
  }
}
