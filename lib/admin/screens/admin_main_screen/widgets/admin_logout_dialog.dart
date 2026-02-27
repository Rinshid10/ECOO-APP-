import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/admin_colors.dart';

/// Admin logout dialog widget
class AdminLogoutDialog extends StatelessWidget {
  final VoidCallback onLogout;

  const AdminLogoutDialog({
    super.key,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        children: [
          Icon(Iconsax.logout, color: AdminColors.error),
          SizedBox(width: 12),
          Text('Logout'),
        ],
      ),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            onLogout();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AdminColors.error,
          ),
          child: const Text('Logout'),
        ),
      ],
    );
  }
}
