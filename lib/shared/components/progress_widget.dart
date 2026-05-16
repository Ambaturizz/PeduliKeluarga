import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import 'app_status.dart';

class ProgressWidget extends StatelessWidget {
  const ProgressWidget({
    required this.value,
    this.label,
    this.trailingLabel,
    this.status = AppStatus.success,
    this.height = 6,
    this.showPercent = false,
    super.key,
  }) : assert(value >= 0 && value <= 1);

  final double value;
  final String? label;
  final String? trailingLabel;
  final AppStatus status;
  final double height;
  final bool showPercent;

  @override
  Widget build(BuildContext context) {
    final percent = '${(value * 100).round()}%';

    return Semantics(
      label: label ?? 'Progress',
      value: percent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null || trailingLabel != null || showPercent) ...[
            Row(
              children: [
                if (label != null)
                  Expanded(
                    child: Text(
                      label!,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  )
                else
                  const Spacer(),
                Text(
                  trailingLabel ?? (showPercent ? percent : ''),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: status.progressColor,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xs),
            child: LinearProgressIndicator(
              value: value,
              minHeight: height,
              color: status.progressColor,
              backgroundColor: AppColors.grayBg,
            ),
          ),
        ],
      ),
    );
  }
}
