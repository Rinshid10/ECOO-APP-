import 'package:flutter/material.dart';
import '../../../core/admin_colors.dart';

/// Admin popup menu item widget
class AdminPopupMenuItem extends PopupMenuItem<String> {
  AdminPopupMenuItem({
    required String value,
    required IconData icon,
    required String title,
    bool isDestructive = false,
  }) : super(
          value: value,
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isDestructive ? AdminColors.error : AdminColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: isDestructive ? AdminColors.error : AdminColors.textPrimary,
                ),
              ),
            ],
          ),
        );
}
