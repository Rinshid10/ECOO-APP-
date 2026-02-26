import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';

/// Interactive animated rating selector
/// Features tap and drag to rate with visual feedback
class RatingSelector extends StatefulWidget {
  final double initialRating;
  final int itemCount;
  final double itemSize;
  final ValueChanged<double> onRatingChanged;
  final bool allowHalfRating;

  const RatingSelector({
    super.key,
    this.initialRating = 0,
    this.itemCount = 5,
    this.itemSize = 40,
    required this.onRatingChanged,
    this.allowHalfRating = true,
  });

  @override
  State<RatingSelector> createState() => _RatingSelectorState();
}

class _RatingSelectorState extends State<RatingSelector>
    with SingleTickerProviderStateMixin {
  late double _rating;
  late AnimationController _controller;
  int? _animatingIndex;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateRating(double localX) {
    final itemWidth = widget.itemSize;
    final newRating = (localX / itemWidth).clamp(0, widget.itemCount.toDouble());

    final roundedRating = widget.allowHalfRating
        ? (newRating * 2).round() / 2
        : newRating.round().toDouble();

    if (roundedRating != _rating) {
      HapticFeedback.selectionClick();
      setState(() {
        _rating = roundedRating;
        _animatingIndex = roundedRating.ceil() - 1;
      });
      widget.onRatingChanged(_rating);

      _controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) => _updateRating(details.localPosition.dx),
      onTapDown: (details) => _updateRating(details.localPosition.dx),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widget.itemCount, (index) {
          return _buildStar(index);
        }),
      ),
    );
  }

  Widget _buildStar(int index) {
    final isAnimating = _animatingIndex == index;
    double fillAmount;

    if (index < _rating.floor()) {
      fillAmount = 1.0;
    } else if (index < _rating) {
      fillAmount = _rating - index;
    } else {
      fillAmount = 0.0;
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1, end: isAnimating ? 1.3 : 1),
      duration: const Duration(milliseconds: 200),
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: SizedBox(
            width: widget.itemSize,
            height: widget.itemSize,
            child: Stack(
              children: [
                // Empty star
                Icon(
                  Icons.star_rounded,
                  size: widget.itemSize,
                  color: AppColors.grey300,
                ),
                // Filled star with clip
                ClipRect(
                  clipper: _StarClipper(fillAmount),
                  child: Icon(
                    Icons.star_rounded,
                    size: widget.itemSize,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StarClipper extends CustomClipper<Rect> {
  final double fillAmount;

  _StarClipper(this.fillAmount);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * fillAmount, size.height);
  }

  @override
  bool shouldReclip(_StarClipper oldClipper) {
    return fillAmount != oldClipper.fillAmount;
  }
}

/// Simple star rating display with animation
class AnimatedStarRating extends StatelessWidget {
  final double rating;
  final int starCount;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final int reviewCount;
  final bool showCount;

  const AnimatedStarRating({
    super.key,
    required this.rating,
    this.starCount = 5,
    this.size = 20,
    this.activeColor,
    this.inactiveColor,
    this.reviewCount = 0,
    this.showCount = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(starCount, (index) {
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 300 + (index * 100)),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              double fillAmount;
              if (index < rating.floor()) {
                fillAmount = 1.0;
              } else if (index < rating) {
                fillAmount = rating - index;
              } else {
                fillAmount = 0.0;
              }

              return Transform.scale(
                scale: value,
                child: SizedBox(
                  width: size,
                  height: size,
                  child: Stack(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: size,
                        color: inactiveColor ?? AppColors.grey300,
                      ),
                      ClipRect(
                        clipper: _StarClipper(fillAmount),
                        child: Icon(
                          Icons.star_rounded,
                          size: size,
                          color: activeColor ?? AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
        if (showCount && reviewCount > 0) ...[
          const SizedBox(width: 8),
          Text(
            '${rating.toStringAsFixed(1)} ($reviewCount)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ],
    );
  }
}
