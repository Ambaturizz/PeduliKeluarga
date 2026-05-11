import 'package:flutter/material.dart';

import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import 'app_status.dart';

class AlertCard extends StatelessWidget {
  const AlertCard({
    required this.title,
    required this.message,
    this.status = AppStatus.info,
    this.icon,
    this.action,
    this.margin,
    super.key,
  });

  final String title;
  final String message;
  final AppStatus status;
  final IconData? icon;
  final Widget? action;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      liveRegion: status == AppStatus.danger || status == AppStatus.warning,
      child: Container(
        margin: margin ?? const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: status.backgroundColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: status.borderColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon ?? status.defaultIcon,
              size: 20,
              color: status.foregroundColor,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: status.foregroundColor,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: status.foregroundColor,
                          height: 1.6,
                        ),
                  ),
                  if (action != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    action!,
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}