import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/admin_colors.dart';

/// Customers screen header widget
class CustomersHeader extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;

  const CustomersHeader({
    super.key,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search customers...',
              prefixIcon: const Icon(Iconsax.search_normal),
              filled: true,
              fillColor: AdminColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AdminColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AdminColors.border),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Iconsax.export),
          label: const Text('Export'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AdminColors.surface,
            foregroundColor: AdminColors.textPrimary,
            elevation: 0,
            side: const BorderSide(color: AdminColors.border),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}
