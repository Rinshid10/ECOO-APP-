import 'package:flutter/material.dart';
import '../../core/admin_colors.dart';
import 'widgets/customers_header.dart';
import 'widgets/customers_stats_cards.dart';
import 'widgets/customers_table.dart';

/// Admin customers management screen
class AdminCustomersScreen extends StatefulWidget {
  const AdminCustomersScreen({super.key});

  @override
  State<AdminCustomersScreen> createState() => _AdminCustomersScreenState();
}

class _AdminCustomersScreenState extends State<AdminCustomersScreen> {
  String _searchQuery = '';

  final List<Map<String, dynamic>> _customers = [
    {
      'id': '1',
      'name': 'John Doe',
      'email': 'john@example.com',
      'phone': '+1 234 567 890',
      'orders': 12,
      'spent': 1456.99,
      'status': 'active',
      'joined': '2023-05-15',
      'avatar': 'https://i.pravatar.cc/100?img=1',
    },
    {
      'id': '2',
      'name': 'Jane Smith',
      'email': 'jane@example.com',
      'phone': '+1 234 567 891',
      'orders': 8,
      'spent': 892.50,
      'status': 'active',
      'joined': '2023-06-20',
      'avatar': 'https://i.pravatar.cc/100?img=5',
    },
    {
      'id': '3',
      'name': 'Mike Johnson',
      'email': 'mike@example.com',
      'phone': '+1 234 567 892',
      'orders': 24,
      'spent': 3245.00,
      'status': 'vip',
      'joined': '2022-11-10',
      'avatar': 'https://i.pravatar.cc/100?img=3',
    },
    {
      'id': '4',
      'name': 'Sarah Wilson',
      'email': 'sarah@example.com',
      'phone': '+1 234 567 893',
      'orders': 3,
      'spent': 234.25,
      'status': 'active',
      'joined': '2024-01-05',
      'avatar': 'https://i.pravatar.cc/100?img=9',
    },
    {
      'id': '5',
      'name': 'Tom Brown',
      'email': 'tom@example.com',
      'phone': '+1 234 567 894',
      'orders': 0,
      'spent': 0.0,
      'status': 'inactive',
      'joined': '2023-12-01',
      'avatar': 'https://i.pravatar.cc/100?img=8',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredCustomers = _customers.where((c) {
      return c['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c['email'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    final activeCustomers = _customers.where((c) => c['status'] == 'active').length;
    final vipCustomers = _customers.where((c) => c['status'] == 'vip').length;
    final inactiveCustomers = _customers.where((c) => c['status'] == 'inactive').length;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Header
          CustomersHeader(
            onSearchChanged: (value) => setState(() => _searchQuery = value),
          ),
          const SizedBox(height: 24),

          // Stats cards
          CustomersStatsCards(
            totalCustomers: _customers.length,
            activeCustomers: activeCustomers,
            vipCustomers: vipCustomers,
            inactiveCustomers: inactiveCustomers,
          ),
          const SizedBox(height: 24),

          // Customers table
          Expanded(child: CustomersTable(customers: filteredCustomers)),
        ],
      ),
    );
  }
}
