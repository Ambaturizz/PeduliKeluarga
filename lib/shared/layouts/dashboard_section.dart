import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class DashboardSection extends StatelessWidget {
  const DashboardSection({
    required this.title,
    required this.children,
    this.action,
    this.spacing = AppSpacing.md,
    super.key,
  });

  final String title;
  final List<Widget> children;
  final Widget? action;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      header: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sectionGap),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.sm,
                bottom: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                            letterSpacing: 0.55,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                  ?action,
                ],
              ),
            ),
            for (var i = 0; i < children.length; i++) ...[
              children[i],
              if (i != children.length - 1) SizedBox(height: spacing),
            ],
          ],
        ),
      ),
    );
  }
}
