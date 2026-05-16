import 'package:flutter/material.dart';

import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import 'app_status.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    required this.label,
    this.status = AppStatus.neutral,
    this.icon,
    this.showIcon = false,
    this.compact = false,
    super.key,
  });

  final String label;
  final AppStatus status;
  final IconData? icon;
  final bool showIcon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final textStyle = compact
        ? Theme.of(context).textTheme.labelSmall
        : Theme.of(context).textTheme.labelMedium;

    return Semantics(
      label: label,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: status.backgroundColor,
          borderRadius: AppRadius.full,
          border: Border.all(color: status.borderColor),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? AppSpacing.sm : AppSpacing.md,
            vertical: compact ? AppSpacing.xs : AppSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showIcon) ...[
                Icon(
                  icon ?? status.defaultIcon,
                  size: compact ? 13 : 15,
                  color: status.foregroundColor,
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle?.copyWith(
                    color: status.foregroundColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
