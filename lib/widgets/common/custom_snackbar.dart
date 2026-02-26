import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/constants/app_colors.dart';

/// Custom snackbar with better styling and animations
/// Provides success, error, warning, and info variants
enum SnackBarType { success, error, warning, info }

class CustomSnackBar {
  /// Show a custom styled snackbar
  static void show({
    required BuildContext context,
    required String message,
    SnackBarType type = SnackBarType.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final config = _getConfig(type);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                config.icon,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    config.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: config.color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        duration: duration,
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: Colors.white,
                onPressed: onAction ?? () {},
              )
            : null,
      ),
    );
  }

  /// Show success snackbar
  static void showSuccess(BuildContext context, String message,
      {String? actionLabel, VoidCallback? onAction}) {
    show(
      context: context,
      message: message,
      type: SnackBarType.success,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Show error snackbar
  static void showError(BuildContext context, String message,
      {String? actionLabel, VoidCallback? onAction}) {
    show(
      context: context,
      message: message,
      type: SnackBarType.error,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Show warning snackbar
  static void showWarning(BuildContext context, String message,
      {String? actionLabel, VoidCallback? onAction}) {
    show(
      context: context,
      message: message,
      type: SnackBarType.warning,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Show info snackbar
  static void showInfo(BuildContext context, String message,
      {String? actionLabel, VoidCallback? onAction}) {
    show(
      context: context,
      message: message,
      type: SnackBarType.info,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  static _SnackBarConfig _getConfig(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return _SnackBarConfig(
          icon: Iconsax.tick_circle,
          color: AppColors.success,
          title: 'Success',
        );
      case SnackBarType.error:
        return _SnackBarConfig(
          icon: Iconsax.close_circle,
          color: AppColors.error,
          title: 'Error',
        );
      case SnackBarType.warning:
        return _SnackBarConfig(
          icon: Iconsax.warning_2,
          color: AppColors.warning,
          title: 'Warning',
        );
      case SnackBarType.info:
        return _SnackBarConfig(
          icon: Iconsax.info_circle,
          color: AppColors.info,
          title: 'Info',
        );
    }
  }
}

class _SnackBarConfig {
  final IconData icon;
  final Color color;
  final String title;

  _SnackBarConfig({
    required this.icon,
    required this.color,
    required this.title,
  });
}
