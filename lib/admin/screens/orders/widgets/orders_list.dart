import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/admin_colors.dart';
import 'order_card.dart';

/// Orders list widget
class OrdersList extends StatelessWidget {
  final List<Map<String, dynamic>> orders;
  final String searchQuery;
  final bool isMedium;
  final Function(Map<String, dynamic>) onOrderDetails;
  final Function(String, String) onStatusChanged;

  const OrdersList({
    super.key,
    required this.orders,
    required this.searchQuery,
    required this.isMedium,
    required this.onOrderDetails,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    var filteredOrders = orders;

    if (searchQuery.isNotEmpty) {
      filteredOrders = filteredOrders.where((o) {
        return o['id'].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
            o['customer'].toString().toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    if (filteredOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AdminColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(Iconsax.receipt_1, size: 40, color: AdminColors.textTertiary),
            ),
            const SizedBox(height: 16),
            Text(
              'No orders found',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AdminColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(isMedium ? 16 : 12),
      itemCount: filteredOrders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) => OrderCard(
        order: filteredOrders[index],
        isMedium: isMedium,
        onOrderDetails: () => onOrderDetails(filteredOrders[index]),
        onStatusChanged: (status) => onStatusChanged(filteredOrders[index]['id'], status),
      ),
    );
  }
}
