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
    this.headerTrailing,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Widget> children;
  final double maxWidth;
  final Widget? headerTrailing;

  @override
  Widget build(BuildContext context) {
    // Root routes such as Login/Register are rendered outside AppNavigationShell,
    // so they do not automatically get a Scaffold/Material ancestor.
    // TextField/TextFormField requires Material. This transparent Material keeps
    // the existing AppPage gradient/layout intact and also remains safe when
    // PageShell is used inside an existing Scaffold.
    return Material(
      type: MaterialType.transparency,
      child: AppPage(
        maxWidth: maxWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppPageHeader(
              title: title,
              subtitle: subtitle,
              icon: icon,
              trailing: headerTrailing,
            ),
            const SizedBox(height: AppSpacing.xxl),
            ...children,
          ],
        ),
      ),
    );
  }
}
