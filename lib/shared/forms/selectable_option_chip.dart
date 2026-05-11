import 'package:flutter/material.dart';

import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../components/app_status.dart';

class SelectableOptionChip extends StatelessWidget {
  const SelectableOptionChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    this.status = AppStatus.success,
    this.icon,
    super.key,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final AppStatus status;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = selected ? status.backgroundColor : Theme.of(context).scaffoldBackgroundColor;
    final foregroundColor = selected ? status.foregroundColor : Theme.of(context).textTheme.bodySmall?.color;
    final borderColor = selected ? status.borderColor : Theme.of(context).dividerColor;

    return Semantics(
      selected: selected,
      button: true,
      label: label,
      child: InkWell(
        borderRadius: AppRadius.small,
        onTap: () => onSelected(!selected),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: AppRadius.small,
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: foregroundColor,
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: foregroundColor,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}