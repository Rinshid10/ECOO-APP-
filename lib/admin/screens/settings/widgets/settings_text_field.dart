import 'package:flutter/material.dart';
import '../../../core/admin_colors.dart';

/// Settings text field widget
class SettingsTextField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const SettingsTextField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: TextEditingController(text: value),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AdminColors.textSecondary, size: 20),
          filled: true,
          fillColor: AdminColors.background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AdminColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AdminColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AdminColors.accent, width: 2),
          ),
        ),
      ),
    );
  }
}
