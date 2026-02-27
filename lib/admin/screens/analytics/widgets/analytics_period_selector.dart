import 'package:flutter/material.dart';
import '../../../core/admin_colors.dart';

/// Analytics period selector widget
class AnalyticsPeriodSelector extends StatelessWidget {
  final String selectedPeriod;
  final ValueChanged<String> onPeriodChanged;

  const AnalyticsPeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final periods = ['Today', 'This Week', 'This Month', 'This Year'];
    return Row(
      children: periods.map((period) {
        final isSelected = selectedPeriod == period;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(period),
            selected: isSelected,
            onSelected: (_) => onPeriodChanged(period),
            backgroundColor: AdminColors.surface,
            selectedColor: AdminColors.accent,
            labelStyle: TextStyle(color: isSelected ? Colors.white : AdminColors.textPrimary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: isSelected ? AdminColors.accent : AdminColors.border),
            ),
          ),
        );
      }).toList(),
    );
  }
}
