import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';

/// Gradient icon button with press animation
/// Provides visual feedback on tap
class GradientIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final List<Color> gradientColors;
  final double size;
  final double iconSize;
  final String? badge;

  const GradientIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.gradientColors = const [AppColors.primary, AppColors.primaryLight],
    this.size = 50,
    this.iconSize = 24,
    this.badge,
  });

  @override
  State<GradientIconButton> createState() => _GradientIconButtonState();
}

class _GradientIconButtonState extends State<GradientIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onPressed();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(widget.size / 3),
                boxShadow: [
                  BoxShadow(
                    color: widget.gradientColors.first.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                widget.icon,
                color: Colors.white,
                size: widget.iconSize,
              ),
            ),
            if (widget.badge != null)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
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
    );
  }
}

/// Outline icon button with hover effect
class OutlineIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color color;
  final double size;
  final double iconSize;
  final bool isActive;

  const OutlineIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color = AppColors.primary,
    this.size = 50,
    this.iconSize = 24,
    this.isActive = false,
  });

  @override
  State<OutlineIconButton> createState() => _OutlineIconButtonState();
}

class _OutlineIconButtonState extends State<OutlineIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onPressed();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.isActive || _isHovered
              ? widget.color.withOpacity(0.1)
              : Colors.transparent,
          border: Border.all(
            color: widget.isActive ? widget.color : AppColors.grey300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(widget.size / 3),
        ),
        child: Icon(
          widget.icon,
          color: widget.isActive || _isHovered
              ? widget.color
              : AppColors.textSecondary,
          size: widget.iconSize,
        ),
      ),
    );
  }
}

/// Circular icon button with ripple
class CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final double iconSize;
  final bool hasShadow;

  const CircularIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 45,
    this.iconSize = 22,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? Theme.of(context).cardColor,
      shape: const CircleBorder(),
      elevation: hasShadow ? 4 : 0,
      shadowColor: AppColors.shadow,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onPressed();
        },
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Icon(
              icon,
              size: iconSize,
              color: iconColor ?? AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
