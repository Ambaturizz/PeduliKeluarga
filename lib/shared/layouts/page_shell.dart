import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import 'app_page.dart';

class PageShell extends StatelessWidget {
  const PageShell({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.children,
    this.maxWidth = 840,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Widget> children;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      maxWidth: maxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppPageHeader(title: title, subtitle: subtitle, icon: icon),
          const SizedBox(height: AppSpacing.xxl),
          ...children,
        ],
      ),
    );
  }
}
