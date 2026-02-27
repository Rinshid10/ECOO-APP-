import 'package:flutter/material.dart';
import '../../../core/admin_colors.dart';

/// Orders tabs widget
class OrdersTabs extends StatelessWidget {
  final TabController tabController;
  final List<Map<String, dynamic>> tabs;
  final List<Map<String, dynamic>> orders;

  const OrdersTabs({
    super.key,
    required this.tabController,
    required this.tabs,
    required this.orders,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AdminColors.border.withOpacity(0.5))),
      ),
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        labelColor: AdminColors.primary,
        unselectedLabelColor: AdminColors.textTertiary,
        indicatorColor: AdminColors.primary,
        indicatorWeight: 2,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        labelPadding: const EdgeInsets.symmetric(horizontal: 12),
        tabs: tabs.map((tab) {
          final count = tab['status'] == 'all'
              ? orders.length
              : orders.where((o) => o['status'] == tab['status']).length;
          return Tab(
            height: 44,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(tab['icon'] as IconData, size: 16),
                const SizedBox(width: 6),
                Text(tab['label'] as String),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AdminColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(fontSize: 10, color: AdminColors.textSecondary),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
