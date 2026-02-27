import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/admin_colors.dart';

/// Quick actions dropdown panel
class AdminQuickActions extends StatelessWidget {
  final LayerLink link;
  final VoidCallback onClose;

  const AdminQuickActions({
    super.key,
    required this.link,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Backdrop
        Positioned.fill(
          child: GestureDetector(
            onTap: onClose,
            child: Container(color: Colors.transparent),
          ),
        ),
        // Panel
        CompositedTransformFollower(
          link: link,
          targetAnchor: Alignment.bottomRight,
          followerAnchor: Alignment.topRight,
          offset: const Offset(0, 8),
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 280,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AdminColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AdminColors.border),
                boxShadow: AdminColors.elevatedShadow,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(Iconsax.flash_1, size: 18, color: AdminColors.primary),
                        const SizedBox(width: 8),
                        const Text(
                          'Quick Actions',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  // Actions grid
                  _buildActionsGrid(),
                  const SizedBox(height: 8),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  // Recent actions
                  _buildRecentActions(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionsGrid() {
    final actions = [
      {'icon': Iconsax.add_circle, 'label': 'New Product', 'color': AdminColors.primary},
      {'icon': Iconsax.receipt_add, 'label': 'New Order', 'color': AdminColors.success},
      {'icon': Iconsax.user_add, 'label': 'Add Customer', 'color': AdminColors.info},
      {'icon': Iconsax.discount_shape, 'label': 'Create Coupon', 'color': AdminColors.warning},
      {'icon': Iconsax.chart_2, 'label': 'View Reports', 'color': AdminColors.accent},
      {'icon': Iconsax.export_1, 'label': 'Export Data', 'color': AdminColors.textSecondary},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) => _buildActionItem(actions[index]),
    );
  }

  Widget _buildActionItem(Map<String, dynamic> action) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onClose();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: (action['color'] as Color).withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              action['icon'] as IconData,
              size: 22,
              color: action['color'] as Color,
            ),
            const SizedBox(height: 6),
            Text(
              action['label'] as String,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: action['color'] as Color,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Text(
            'Recent',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AdminColors.textTertiary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        _buildRecentItem(Iconsax.box, 'Added: Wireless Earbuds'),
        _buildRecentItem(Iconsax.receipt_1, 'Processed Order #2024-001'),
      ],
    );
  }

  Widget _buildRecentItem(IconData icon, String text) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onClose();
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AdminColors.textTertiary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  color: AdminColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.chevron_right, size: 16, color: AdminColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
