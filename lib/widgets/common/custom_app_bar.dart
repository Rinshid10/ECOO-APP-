import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../../core/constants/app_colors.dart';
import '../../providers/cart_provider.dart';

/// Custom app bar widget with consistent styling
/// Supports back button, title, and cart icon
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final bool showCartIcon;
  final bool showSearchIcon;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final VoidCallback? onCartPressed;
  final VoidCallback? onSearchPressed;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    this.title,
    this.showBackButton = true,
    this.showCartIcon = false,
    this.showSearchIcon = false,
    this.actions,
    this.onBackPressed,
    this.onCartPressed,
    this.onSearchPressed,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: centerTitle,
      leading: _buildLeading(context),
      title: title != null
          ? Text(
              title!,
              style: Theme.of(context).textTheme.headlineSmall,
            )
          : null,
      actions: _buildActions(context),
    );
  }

  /// Build leading widget
  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    if (showBackButton && Navigator.canPop(context)) {
      return IconButton(
        onPressed: onBackPressed ?? () => Navigator.pop(context),
        icon: const Icon(Iconsax.arrow_left),
      );
    }

    return null;
  }

  /// Build action widgets
  List<Widget>? _buildActions(BuildContext context) {
    final List<Widget> actionWidgets = [];

    // Add search icon if enabled
    if (showSearchIcon) {
      actionWidgets.add(
        IconButton(
          onPressed: onSearchPressed,
          icon: const Icon(Iconsax.search_normal),
        ),
      );
    }

    // Add cart icon if enabled
    if (showCartIcon) {
      actionWidgets.add(_buildCartIcon(context));
    }

    // Add custom actions
    if (actions != null) {
      actionWidgets.addAll(actions!);
    }

    return actionWidgets.isNotEmpty ? actionWidgets : null;
  }

  /// Build cart icon with badge
  Widget _buildCartIcon(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return IconButton(
          onPressed: onCartPressed,
          icon: cart.itemCount > 0
              ? badges.Badge(
                  badgeContent: Text(
                    cart.itemCount.toString(),
                    style: const TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  badgeStyle: const badges.BadgeStyle(
                    badgeColor: AppColors.secondary,
                    padding: EdgeInsets.all(5),
                  ),
                  child: const Icon(Iconsax.shopping_cart),
                )
              : const Icon(Iconsax.shopping_cart),
        );
      },
    );
  }
}
