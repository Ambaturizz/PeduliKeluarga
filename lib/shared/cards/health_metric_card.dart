import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../components/app_status.dart';

class HealthMetricCard extends StatelessWidget {
  const HealthMetricCard({
    required this.label,
    required this.value,
    this.unit,
    this.icon,
    this.status = AppStatus.neutral,
    this.helperText,
    super.key,
  });

  final String label;
  final String value;
  final String? unit;
  final IconData? icon;
  final AppStatus status;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label $value ${unit ?? ''}',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.grayBg,
          borderRadius: AppRadius.small,
          border: Border.all(color: AppColors.grayBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 16,
                    color: status.foregroundColor,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                ],
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: status.progressColor,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
                if (unit != null) ...[
                  const SizedBox(width: AppSpacing.xs),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      unit!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ],
            ),
            if (helperText != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                helperText!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}