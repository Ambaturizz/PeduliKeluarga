import 'package:flutter/material.dart';

import '../../core/animations/app_motion.dart';
import '../../core/theme/app_spacing.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.xl),
    this.onTap,
    this.semanticLabel,
    this.clipBehavior = Clip.antiAlias,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final content = Card(
      clipBehavior: clipBehavior,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );

    final wrapped = RepaintBoundary(
      child: Semantics(
        button: onTap != null,
        label: semanticLabel,
        child: content,
      ),
    );

    if (onTap == null) return wrapped;

    return AppPressable(
      onTap: onTap,
      semanticLabel: semanticLabel,
      child: wrapped,
    );
  }
}
