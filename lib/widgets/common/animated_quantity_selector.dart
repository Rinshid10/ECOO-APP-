import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/constants/app_colors.dart';

/// Animated quantity selector with smooth transitions
/// Includes haptic feedback and scale animations
class AnimatedQuantitySelector extends StatefulWidget {
  final int quantity;
  final int minQuantity;
  final int maxQuantity;
  final ValueChanged<int> onChanged;
  final bool compact;

  const AnimatedQuantitySelector({
    super.key,
    required this.quantity,
    this.minQuantity = 1,
    this.maxQuantity = 99,
    required this.onChanged,
    this.compact = false,
  });

  @override
  State<AnimatedQuantitySelector> createState() =>
      _AnimatedQuantitySelectorState();
}

class _AnimatedQuantitySelectorState extends State<AnimatedQuantitySelector>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _increment() {
    if (widget.quantity < widget.maxQuantity) {
      HapticFeedback.lightImpact();
      _animateQuantity();
      widget.onChanged(widget.quantity + 1);
    }
  }

  void _decrement() {
    if (widget.quantity > widget.minQuantity) {
      HapticFeedback.lightImpact();
      _animateQuantity();
      widget.onChanged(widget.quantity - 1);
    }
  }

  void _animateQuantity() {
    _controller.forward().then((_) => _controller.reverse());
  }

  @override
  Widget build(BuildContext context) {
    final buttonSize = widget.compact ? 32.0 : 40.0;
    final iconSize = widget.compact ? 16.0 : 20.0;
    final fontSize = widget.compact ? 14.0 : 18.0;
    final containerWidth = widget.compact ? 40.0 : 50.0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(widget.compact ? 10 : 14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrement button
          _buildButton(
            icon: Iconsax.minus,
            onTap: _decrement,
            enabled: widget.quantity > widget.minQuantity,
            size: buttonSize,
            iconSize: iconSize,
          ),

          // Quantity display
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: SizedBox(
                  width: containerWidth,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      '${widget.quantity}',
                      key: ValueKey<int>(widget.quantity),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Increment button
          _buildButton(
            icon: Iconsax.add,
            onTap: _increment,
            enabled: widget.quantity < widget.maxQuantity,
            size: buttonSize,
            iconSize: iconSize,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool enabled,
    required double size,
    required double iconSize,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: enabled ? AppColors.primary : AppColors.grey200,
          borderRadius: BorderRadius.circular(widget.compact ? 8 : 12),
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: enabled ? AppColors.textWhite : AppColors.textLight,
        ),
      ),
    );
  }
}
