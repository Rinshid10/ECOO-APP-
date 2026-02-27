import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/admin_colors.dart';
import 'widgets/orders_stats_cards.dart';
import 'widgets/orders_header.dart';
import 'widgets/orders_tabs.dart';
import 'widgets/orders_list.dart';
import 'widgets/order_details_dialog.dart';

/// Modern admin orders management screen
class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  final List<Map<String, dynamic>> _orders = [
    {
      'id': '#ORD-2024-001',
      'customer': 'John Doe',
      'email': 'john@example.com',
      'avatar': 'https://i.pravatar.cc/100?img=1',
      'items': 3,
      'total': 256.99,
      'status': 'pending',
      'date': '2024-01-15',
      'payment': 'Credit Card',
    },
    {
      'id': '#ORD-2024-002',
      'customer': 'Jane Smith',
      'email': 'jane@example.com',
      'avatar': 'https://i.pravatar.cc/100?img=5',
      'items': 1,
      'total': 89.00,
      'status': 'processing',
      'date': '2024-01-15',
      'payment': 'PayPal',
    },
    {
      'id': '#ORD-2024-003',
      'customer': 'Mike Johnson',
      'email': 'mike@example.com',
      'avatar': 'https://i.pravatar.cc/100?img=3',
      'items': 5,
      'total': 445.50,
      'status': 'shipped',
      'date': '2024-01-14',
      'payment': 'Credit Card',
    },
    {
      'id': '#ORD-2024-004',
      'customer': 'Sarah Wilson',
      'email': 'sarah@example.com',
      'avatar': 'https://i.pravatar.cc/100?img=9',
      'items': 2,
      'total': 178.00,
      'status': 'delivered',
      'date': '2024-01-13',
      'payment': 'Bank Transfer',
    },
    {
      'id': '#ORD-2024-005',
      'customer': 'Tom Brown',
      'email': 'tom@example.com',
      'avatar': 'https://i.pravatar.cc/100?img=8',
      'items': 1,
      'total': 65.00,
      'status': 'cancelled',
      'date': '2024-01-12',
      'payment': 'Credit Card',
    },
  ];

  final List<Map<String, dynamic>> _tabs = [
    {'label': 'All', 'status': 'all', 'icon': Iconsax.receipt_1},
    {'label': 'Pending', 'status': 'pending', 'icon': Iconsax.clock},
    {'label': 'Processing', 'status': 'processing', 'icon': Iconsax.refresh_circle},
    {'label': 'Shipped', 'status': 'shipped', 'icon': Iconsax.truck_fast},
    {'label': 'Delivered', 'status': 'delivered', 'icon': Iconsax.tick_circle},
    {'label': 'Cancelled', 'status': 'cancelled', 'icon': Iconsax.close_circle},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => OrderDetailsDialog(order: order),
    );
  }

  List<Map<String, dynamic>> _getFilteredOrders(String status) {
    var filteredOrders = status == 'all'
        ? _orders
        : _orders.where((o) => o['status'] == status).toList();

    if (_searchQuery.isNotEmpty) {
      filteredOrders = filteredOrders.where((o) {
        return o['id'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
            o['customer'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    return filteredOrders;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        final isMedium = constraints.maxWidth > 600;

        return Padding(
          padding: EdgeInsets.all(isMedium ? 24 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats cards
              OrdersStatsCards(
                orders: _orders,
                isWide: isWide,
                isMedium: isMedium,
              ),
              SizedBox(height: isMedium ? 24 : 16),

              // Orders container
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AdminColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: AdminColors.cardShadow,
                    border: Border.all(color: AdminColors.border.withOpacity(0.5)),
                  ),
                  child: Column(
                    children: [
                      // Header with search
                      OrdersHeader(
                        isMedium: isMedium,
                        onSearchChanged: (value) => setState(() => _searchQuery = value),
                      ),

                      // Tabs
                      OrdersTabs(
                        tabController: _tabController,
                        tabs: _tabs,
                        orders: _orders,
                      ),

                      // Orders list
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: _tabs.map((tab) {
                            return OrdersList(
                              orders: _getFilteredOrders(tab['status']),
                              searchQuery: _searchQuery,
                              isMedium: isMedium,
                              onOrderDetails: _showOrderDetails,
                              onStatusChanged: (orderId, status) {
                                setState(() {
                                  final order = _orders.firstWhere((o) => o['id'] == orderId);
                                  order['status'] = status;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
