import 'package:flutter/material.dart';
import '../../../core/admin_colors.dart';
import 'customers_table_row.dart';

/// Customers table widget
class CustomersTable extends StatelessWidget {
  final List<Map<String, dynamic>> customers;

  const CustomersTable({
    super.key,
    required this.customers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AdminColors.border.withOpacity(0.5), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AdminColors.background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Row(
              children: [
                Expanded(flex: 2, child: Text('Customer', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                Expanded(child: Text('Phone', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                Expanded(child: Text('Orders', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                Expanded(child: Text('Spent', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                Expanded(child: Text('Status', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                SizedBox(width: 80, child: Text('Actions', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: customers.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) => CustomersTableRow(customer: customers[index]),
            ),
          ),
        ],
      ),
    );
  }
}
