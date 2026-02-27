import 'package:flutter/material.dart';
import '../../core/admin_colors.dart';
import 'widgets/analytics_period_selector.dart';
import 'widgets/analytics_revenue_stats.dart';
import 'widgets/analytics_sales_chart.dart';
import 'widgets/analytics_category_distribution.dart';
import 'widgets/analytics_metrics_grid.dart';

/// Admin analytics and reports screen
class AdminAnalyticsScreen extends StatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  State<AdminAnalyticsScreen> createState() => _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends State<AdminAnalyticsScreen> {
  String _selectedPeriod = 'This Month';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period selector
          AnalyticsPeriodSelector(
            selectedPeriod: _selectedPeriod,
            onPeriodChanged: (period) => setState(() => _selectedPeriod = period),
          ),
          const SizedBox(height: 24),

          // Revenue stats
          const AnalyticsRevenueStats(),
          const SizedBox(height: 24),

          // Charts row
          _chartsRow(context),
          const SizedBox(height: 24),

          // Additional metrics
          const AnalyticsMetricsGrid(),
        ],
      ),
    );
  }

  Widget _chartsRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: const AnalyticsSalesChart()),
        const SizedBox(width: 24),
        Expanded(child: const AnalyticsCategoryDistribution()),
      ],
    );
  }
}
