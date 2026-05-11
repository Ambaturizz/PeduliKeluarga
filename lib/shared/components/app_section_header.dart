import 'package:flutter/material.dart';

import '../../core/theme/pk_design.dart';

class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    required this.title,
    this.subtitle,
    this.action,
    this.topPadding = 26,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? action;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding, bottom: 12),
      child: Semantics(
        header: true,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: PkColors.text,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.4,
                        ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: PkColors.muted,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            if (action != null) ...[
              const SizedBox(width: PkSpacing.md),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
