import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/admin_colors.dart';
import '../../providers/admin_provider.dart';
import 'widgets/dashboard_loading_state.dart';
import 'widgets/dashboard_error_state.dart';
import 'widgets/dashboard_stats_grid.dart';
import 'widgets/dashboard_revenue_chart.dart';
import 'widgets/dashboard_orders_status.dart';
import 'widgets/dashboard_top_products.dart';
import 'widgets/dashboard_recent_orders.dart';
import 'widgets/dashboard_activity_section.dart';

/// Modern admin dashboard screen with statistics and charts
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProvider>().loadDashboardStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (context, adminProvider, child) {
        if (adminProvider.isLoading && adminProvider.dashboardStats == null) {
          return const DashboardLoadingState();
        }

        final stats = adminProvider.dashboardStats;
        if (stats == null) {
          return const DashboardErrorState();
        }

        return RefreshIndicator(
          onRefresh: () => adminProvider.refreshDashboard(),
          color: AdminColors.primary,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats cards
                DashboardStatsGrid(stats: stats),
                const SizedBox(height: 24),

                // Revenue chart and Orders by status
                _chartsRow(context, stats),
                const SizedBox(height: 24),

                // Top products and Recent orders
                _tablesRow(context, stats),
                const SizedBox(height: 24),

                // Activity timeline
                const DashboardActivitySection(),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Charts row layout
  Widget _chartsRow(BuildContext context, stats) {
    final isWide = MediaQuery.of(context).size.width > 1000;

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: DashboardRevenueChart(stats: stats)),
          const SizedBox(width: 24),
          Expanded(child: DashboardOrdersStatus(stats: stats)),
        ],
      );
    } else {
      return Column(
        children: [
          DashboardRevenueChart(stats: stats),
          const SizedBox(height: 24),
          DashboardOrdersStatus(stats: stats),
        ],
      );
    }
  }

  /// Tables row layout
  Widget _tablesRow(BuildContext context, stats) {
    final isWide = MediaQuery.of(context).size.width > 1000;

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: DashboardTopProducts(stats: stats)),
          const SizedBox(width: 24),
          Expanded(child: DashboardRecentOrders(stats: stats)),
        ],
      );
    } else {
      return Column(
        children: [
          DashboardTopProducts(stats: stats),
          const SizedBox(height: 24),
          DashboardRecentOrders(stats: stats),
        ],
      );
    }
  }
}
