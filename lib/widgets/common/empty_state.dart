import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/constants/app_colors.dart';
import 'custom_button.dart';

/// Empty state widget for when content is not available
/// Provides visual feedback and action button
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;
  final Widget? customIcon;
  final Color? iconColor;

  const EmptyState({
    super.key,
    this.icon = Iconsax.box,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
    this.customIcon,
    this.iconColor,
  });

  /// Empty cart state
  factory EmptyState.cart({VoidCallback? onAction}) {
    return EmptyState(
      icon: Iconsax.shopping_cart,
      title: 'Your cart is empty',
      subtitle: 'Add items to get started',
      actionText: 'Start Shopping',
      onAction: onAction,
    );
  }

  /// Empty wishlist state
  factory EmptyState.wishlist({VoidCallback? onAction}) {
    return EmptyState(
      icon: Iconsax.heart,
      title: 'Your wishlist is empty',
      subtitle: 'Save items you love',
      actionText: 'Explore Products',
      onAction: onAction,
      iconColor: AppColors.secondary,
    );
  }

  /// No search results state
  factory EmptyState.noResults({String? query, VoidCallback? onAction}) {
    return EmptyState(
      icon: Iconsax.search_normal,
      title: 'No results found',
      subtitle: query != null ? 'No results for "$query"' : 'Try a different search term',
      actionText: 'Clear Search',
      onAction: onAction,
    );
  }

  /// No orders state
  factory EmptyState.noOrders({VoidCallback? onAction}) {
    return EmptyState(
      icon: Iconsax.box,
      title: 'No orders yet',
      subtitle: 'Start shopping to see your orders here',
      actionText: 'Start Shopping',
      onAction: onAction,
    );
  }

  /// No notifications state
  factory EmptyState.noNotifications() {
    return const EmptyState(
      icon: Iconsax.notification,
      title: 'No notifications',
      subtitle: 'We\'ll notify you when something arrives',
    );
  }

  /// Error state
  factory EmptyState.error({VoidCallback? onRetry}) {
    return EmptyState(
      icon: Iconsax.warning_2,
      title: 'Something went wrong',
      subtitle: 'Please try again later',
      actionText: 'Retry',
      onAction: onRetry,
      iconColor: AppColors.error,
    );
  }

  /// No internet state
  factory EmptyState.noInternet({VoidCallback? onRetry}) {
    return EmptyState(
      icon: Iconsax.wifi_square,
      title: 'No internet connection',
      subtitle: 'Please check your connection and try again',
      actionText: 'Retry',
      onAction: onRetry,
      iconColor: AppColors.warning,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated icon container
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: customIcon ??
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: (iconColor ?? AppColors.primary).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          size: 50,
                          color: iconColor ?? AppColors.primary,
                        ),
                      ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Title
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),

            // Subtitle
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textLight,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ],

            // Action button
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 32),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: SizedBox(
                        width: 200,
                        child: CustomButton(
                          text: actionText!,
                          onPressed: onAction,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Animated illustration empty state
class IllustratedEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? actionText;
  final VoidCallback? onAction;
  final List<Color> gradientColors;

  const IllustratedEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    this.actionText,
    this.onAction,
    this.gradientColors = const [AppColors.primary, AppColors.primaryLight],
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated illustration
            _buildIllustration(),
            const SizedBox(height: 32),

            // Title
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Subtitle
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),

            // Action button
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 32),
              CustomButton(
                text: actionText!,
                onPressed: onAction,
                isFullWidth: false,
                width: 200,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background circles
        ...List.generate(3, (index) {
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 800 + (index * 200)),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              final size = 80.0 + (index * 40);
              return Container(
                width: size * value,
                height: size * value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: gradientColors.first.withOpacity(0.1 - (index * 0.03)),
                ),
              );
            },
          );
        }),

        // Center icon
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradientColors),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: gradientColors.first.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Iconsax.box_1,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
