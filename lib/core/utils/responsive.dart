import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

enum AppBreakpoint {
  compact,
  medium,
  expanded,
  large;

  static AppBreakpoint fromWidth(double width) {
    if (width < 600) return AppBreakpoint.compact;
    if (width < 905) return AppBreakpoint.medium;
    if (width < 1240) return AppBreakpoint.expanded;
    return AppBreakpoint.large;
  }
}

extension ResponsiveContext on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);

  double get screenWidth => screenSize.width;

  AppBreakpoint get breakpoint => AppBreakpoint.fromWidth(screenWidth);

  bool get isCompact => breakpoint == AppBreakpoint.compact;

  bool get isMedium => breakpoint == AppBreakpoint.medium;

  bool get isExpanded =>
      breakpoint == AppBreakpoint.expanded || breakpoint == AppBreakpoint.large;

  double get horizontalPagePadding {
    return switch (breakpoint) {
      AppBreakpoint.compact => 16,
      AppBreakpoint.medium => 24,
      AppBreakpoint.expanded => 32,
      AppBreakpoint.large => 40,
    };
  }
}

class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({
    required this.child,
    this.maxWidth = AppConstants.maxContentWidth,
    super.key,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}