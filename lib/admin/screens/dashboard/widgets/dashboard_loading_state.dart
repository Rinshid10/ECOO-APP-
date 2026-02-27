import 'package:flutter/material.dart';
import '../../../core/admin_colors.dart';

/// Dashboard loading state widget
class DashboardLoadingState extends StatelessWidget {
  const DashboardLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AdminColors.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: AdminColors.cardShadow,
            ),
            child: const CircularProgressIndicator(
              color: AdminColors.primary,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading dashboard...',
            style: TextStyle(
              color: AdminColors.textTertiary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
