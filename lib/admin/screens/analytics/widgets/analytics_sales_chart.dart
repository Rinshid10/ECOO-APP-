import 'package:flutter/material.dart';
import '../../../core/admin_colors.dart';

/// Analytics sales chart widget
class AnalyticsSalesChart extends StatelessWidget {
  const AnalyticsSalesChart({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      {'label': 'Jan', 'value': 12500.0},
      {'label': 'Feb', 'value': 18200.0},
      {'label': 'Mar', 'value': 15800.0},
      {'label': 'Apr', 'value': 22400.0},
      {'label': 'May', 'value': 28600.0},
      {'label': 'Jun', 'value': 32100.0},
    ];
    final maxValue = data.map((e) => e['value'] as double).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AdminColors.border.withOpacity(0.5), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sales Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((item) {
                final percentage = (item['value'] as double) / maxValue;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '\$${((item['value'] as double) / 1000).toStringAsFixed(1)}k',
                          style: const TextStyle(fontSize: 11, color: AdminColors.textSecondary),
                        ),
                        const SizedBox(height: 8),
                        Flexible(
                          child: FractionallySizedBox(
                            heightFactor: percentage,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: AdminColors.accentGradient,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['label'] as String,
                          style: const TextStyle(fontSize: 12, color: AdminColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
