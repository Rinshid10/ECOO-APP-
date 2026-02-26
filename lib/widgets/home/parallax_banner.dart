import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';

/// Parallax banner widget with scroll effect
/// Creates depth illusion as user scrolls
class ParallaxBanner extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final double height;
  final GlobalKey? scrollKey;

  const ParallaxBanner({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    this.buttonText,
    this.onButtonPressed,
    this.height = 200,
    this.scrollKey,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Flow(
        delegate: _ParallaxFlowDelegate(
          scrollable: Scrollable.of(context),
          itemContext: context,
        ),
        children: [
          _buildBannerContent(context),
        ],
      ),
    );
  }

  Widget _buildBannerContent(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Parallax image
        CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: AppColors.grey200,
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.primary.withOpacity(0.2),
          ),
        ),

        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.transparent,
              ],
            ),
          ),
        ),

        // Content
        Positioned(
          left: 24,
          bottom: 24,
          right: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  color: AppColors.textWhite.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
              if (buttonText != null) ...[
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: onButtonPressed,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.textWhite,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      buttonText!,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ParallaxFlowDelegate extends FlowDelegate {
  final ScrollableState scrollable;
  final BuildContext itemContext;

  _ParallaxFlowDelegate({
    required this.scrollable,
    required this.itemContext,
  }) : super(repaint: scrollable.position);

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(
      width: constraints.maxWidth,
      height: constraints.maxHeight * 1.5,
    );
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    // Get the scroll position relative to the banner
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final itemBox = itemContext.findRenderObject() as RenderBox;
    final itemOffset = itemBox.localToGlobal(
      Offset.zero,
      ancestor: scrollableBox,
    );

    // Calculate parallax offset
    final viewportHeight = scrollable.position.viewportDimension;
    final scrollFraction = (itemOffset.dy / viewportHeight).clamp(0.0, 1.0);
    final parallaxOffset = (context.size.height - context.getChildSize(0)!.height) * scrollFraction;

    context.paintChild(
      0,
      transform: Matrix4.translationValues(0, parallaxOffset, 0),
    );
  }

  @override
  bool shouldRepaint(_ParallaxFlowDelegate oldDelegate) {
    return scrollable != oldDelegate.scrollable ||
        itemContext != oldDelegate.itemContext;
  }
}

/// Simple promotional banner with gradient
class PromoBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final IconData? icon;
  final VoidCallback? onTap;

  const PromoBanner({
    super.key,
    required this.title,
    required this.subtitle,
    this.gradientColors = const [AppColors.primary, AppColors.primaryLight],
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.textWhite.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (icon != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.textWhite.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: AppColors.textWhite,
                  size: 30,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
