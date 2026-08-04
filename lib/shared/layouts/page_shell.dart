import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import 'app_page.dart';

class PageShell extends StatelessWidget {
  const PageShell({
    this.title = '',
    this.subtitle = '',
    this.icon,
    this.imageAssetIcon,
    required this.children,
    this.maxWidth = 840,
    this.headerTrailing,
    this.showPageHeader = true,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData? icon;
  final String? imageAssetIcon;
  final List<Widget> children;
  final double maxWidth;
  final Widget? headerTrailing;
  final bool showPageHeader;

  @override
  Widget build(BuildContext context) {
    final hasHeaderContent = title.isNotEmpty || subtitle.isNotEmpty || icon != null || headerTrailing != null;
    final shouldShowHeader = showPageHeader && hasHeaderContent;

    return Material(
      type: MaterialType.transparency,
      child: AppPage(
        maxWidth: maxWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (shouldShowHeader) ...[
              AppPageHeader(
                title: title,
                subtitle: subtitle,
                icon: icon,
                imageAssetIcon: imageAssetIcon,
                trailing: headerTrailing,
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
            ...children,
          ],
        ),
      ),
    );
  }
}
