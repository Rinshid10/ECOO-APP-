import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

/// Admin mobile menu button widget
class AdminMobileMenuButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AdminMobileMenuButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (scaffoldContext) => IconButton(
        icon: const Icon(Iconsax.menu_1),
        onPressed: () {
          Scaffold.of(scaffoldContext).openDrawer();
          onPressed();
        },
      ),
    );
  }
}
