import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/admin_colors.dart';

/// Admin mobile menu button widget
class AdminMobileMenuButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AdminMobileMenuButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (scaffoldContext) => Padding(
        padding: const EdgeInsets.only(left: 16),
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            Scaffold.of(scaffoldContext).openDrawer();
            onPressed?.call();
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AdminColors.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Iconsax.menu_1,
              size: 20,
              color: AdminColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
