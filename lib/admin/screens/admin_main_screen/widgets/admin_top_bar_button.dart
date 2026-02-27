import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/admin_colors.dart';

/// Admin top bar button widget with hover effects
class AdminTopBarButton extends StatefulWidget {
  final IconData icon;
  final String? badge;
  final String? tooltip;
  final VoidCallback onTap;

  const AdminTopBarButton({
    super.key,
    required this.icon,
    this.badge,
    this.tooltip,
    required this.onTap,
  });

  @override
  State<AdminTopBarButton> createState() => _AdminTopBarButtonState();
}

class _AdminTopBarButtonState extends State<AdminTopBarButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Widget button = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _isHovered
                ? AdminColors.primarySurface
                : AdminColors.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _isHovered
                  ? AdminColors.primary.withOpacity(0.3)
                  : Colors.transparent,
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                widget.icon,
                color: _isHovered ? AdminColors.primary : AdminColors.textSecondary,
                size: 20,
              ),
              if (widget.badge != null)
                Positioned(
                  top: -8,
                  right: -8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      gradient: AdminColors.errorGradient,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AdminColors.error.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        preferBelow: false,
        decoration: BoxDecoration(
          color: AdminColors.sidebarBg,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
        child: button,
      );
    }

    return button;
  }
}
