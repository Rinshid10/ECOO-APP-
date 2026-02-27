import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/responsive.dart';
import '../../widgets/common/custom_app_bar.dart';

/// Orders screen - responsive layout
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    final orders = [
      _Order(id: 'ORD123456', date: 'Feb 20, 2025', status: OrderStatus.delivered,
          total: 156.99, itemCount: 3),
      _Order(id: 'ORD123457', date: 'Feb 18, 2025', status: OrderStatus.shipping,
          total: 89.99, itemCount: 2),
      _Order(id: 'ORD123458', date: 'Feb 15, 2025', status: OrderStatus.processing,
          total: 299.99, itemCount: 1),
      _Order(id: 'ORD123459', date: 'Feb 10, 2025', status: OrderStatus.delivered,
          total: 45.99, itemCount: 1),
    ];

    return Scaffold(
      appBar: isDesktop ? null : const CustomAppBar(title: AppStrings.myOrders),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isDesktop ? Responsive.narrowContentWidth : double.infinity,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isDesktop)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                  child: Row(
                    children: [
                      TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Iconsax.arrow_left),
                        label: const Text('Back'),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        AppStrings.myOrders,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: orders.isEmpty
                    ? _buildEmptyState(context)
                    : ListView.builder(
                        padding: EdgeInsets.all(isDesktop ? 24 : 16),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          return _buildOrderCard(context, orders[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              color: AppColors.grey100, shape: BoxShape.circle,
            ),
            child: const Icon(Iconsax.box, size: 50, color: AppColors.grey400),
          ),
          const SizedBox(height: 24),
          Text('No orders yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Start shopping to see your orders here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textLight)),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, _Order order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.id,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(order.date,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textLight)),
                ],
              ),
              _buildStatusBadge(context, order.status),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${order.itemCount} ${order.itemCount == 1 ? 'item' : 'items'}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary)),
              Text('\$${order.total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('View Details'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(order.status == OrderStatus.delivered
                      ? 'Reorder' : AppStrings.trackOrder),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, OrderStatus status) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case OrderStatus.processing:
        color = AppColors.warning; text = 'Processing'; icon = Iconsax.clock;
      case OrderStatus.shipping:
        color = AppColors.info; text = 'Shipping'; icon = Iconsax.truck;
      case OrderStatus.delivered:
        color = AppColors.success; text = 'Delivered'; icon = Iconsax.tick_circle;
      case OrderStatus.cancelled:
        color = AppColors.error; text = 'Cancelled'; icon = Iconsax.close_circle;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w600,
              fontSize: 12)),
        ],
      ),
    );
  }
}

enum OrderStatus { processing, shipping, delivered, cancelled }

class _Order {
  final String id;
  final String date;
  final OrderStatus status;
  final double total;
  final int itemCount;

  _Order({required this.id, required this.date, required this.status,
      required this.total, required this.itemCount});
}
