import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Responsive utility class for building adaptive UIs
/// Provides breakpoints and helper methods for responsive design
class Responsive {
  Responsive._(); // Private constructor

  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;

  // Max content width for web
  static const double maxContentWidth = 1280;
  static const double narrowContentWidth = 800;
  static const double wideContentWidth = 1400;

  /// Check if the current device is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Check if the current device is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// Check if the current device is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletBreakpoint;
  }

  /// Check if running on web platform
  static bool get isWebPlatform => kIsWeb;

  /// Get screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Return a value based on screen size
  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    } else if (isTablet(context)) {
      return tablet ?? mobile;
    }
    return mobile;
  }

  /// Get the number of grid columns based on screen size
  static int gridColumns(BuildContext context) {
    return value(context, mobile: 2, tablet: 3, desktop: 4);
  }

  /// Get product grid columns (more columns for wider screens)
  /// Accounts for sidebar width (260px) on desktop
  static int productGridColumns(BuildContext context) {
    final width = screenWidth(context);
    // On desktop, subtract sidebar width to get actual content width
    final contentWidth = width >= tabletBreakpoint ? width - 260 : width;
    if (contentWidth >= 1200) return 5;
    if (contentWidth >= 900) return 4;
    if (contentWidth >= 600) return 3;
    return 2;
  }

  /// Get horizontal padding based on screen size
  static double horizontalPadding(BuildContext context) {
    return value(context, mobile: 16.0, tablet: 24.0, desktop: 24.0);
  }

  /// Get screen edge padding
  static EdgeInsets screenPadding(BuildContext context) {
    final horizontal = horizontalPadding(context);
    return EdgeInsets.symmetric(horizontal: horizontal);
  }

  /// Get banner height
  static double bannerHeight(BuildContext context) {
    return value(context, mobile: 180.0, tablet: 260.0, desktop: 340.0);
  }

  /// Get category card size
  static double categoryCardSize(BuildContext context) {
    return value(context, mobile: 80.0, tablet: 100.0, desktop: 120.0);
  }

  /// Get content padding for centered web layouts
  static EdgeInsets webContentPadding(BuildContext context) {
    if (!isDesktop(context)) {
      return EdgeInsets.symmetric(horizontal: horizontalPadding(context));
    }
    final screenW = screenWidth(context);
    final sideSpace = ((screenW - maxContentWidth) / 2).clamp(40.0, double.infinity);
    return EdgeInsets.symmetric(horizontal: sideSpace);
  }
}

/// Widget that constrains content to a max width and centers it on web
class WebContentWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const WebContentWrapper({
    super.key,
    required this.child,
    this.maxWidth = Responsive.maxContentWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: padding != null
            ? Padding(padding: padding!, child: child)
            : child,
      ),
    );
  }
}

/// Responsive builder widget for building different layouts
class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= Responsive.tabletBreakpoint) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= Responsive.mobileBreakpoint) {
          return tablet ?? mobile;
        }
        return mobile;
      },
    );
  }
}
