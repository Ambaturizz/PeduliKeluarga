import 'package:flutter/material.dart';

import '../../core/theme/pk_design.dart';
import '../../core/utils/responsive.dart';

class AppPage extends StatelessWidget {
  const AppPage({
    required this.child,
    this.maxWidth = 1180,
    this.padding,
    this.useGradient = true,
    this.safeAreaTop = true,
    this.safeAreaBottom = false,
    super.key,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;
  final bool useGradient;
  final bool safeAreaTop;
  final bool safeAreaBottom;

  @override
  Widget build(BuildContext context) {
    final content = SafeArea(
      top: safeAreaTop,
      bottom: safeAreaBottom,
      child: SingleChildScrollView(
        padding: padding ??
            EdgeInsets.symmetric(
              horizontal: context.horizontalPagePadding,
              vertical: PkSpacing.xxl,
            ),
        child: ResponsiveCenter(
          maxWidth: maxWidth,
          child: RepaintBoundary(child: child),
        ),
      ),
    );

    if (!useGradient) return content;
    return PkGradientBackground(child: content);
  }
}

class AppPageHeader extends StatelessWidget {
  const AppPageHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.trailing,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PkIconBox(icon: icon, size: 48, iconSize: 24),
          const SizedBox(width: PkSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.6,
                      ),
                ),
                const SizedBox(height: PkSpacing.xs),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: PkSpacing.md),
            trailing!,
          ],
        ],
      ),
    );
  }
}
