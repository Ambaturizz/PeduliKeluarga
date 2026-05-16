import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../components/app_status.dart';
import '../components/status_badge.dart';

class HealthCard extends StatelessWidget {
  const HealthCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.status = AppStatus.success,
    this.badgeLabel,
    this.onTap,
    this.child,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final AppStatus status;
  final String? badgeLabel;
  final VoidCallback? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.grayCard,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.grayBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HealthCardHeader(
            title: title,
            subtitle: subtitle,
            icon: icon,
            status: status,
          ),
          if (badgeLabel != null) ...[
            const SizedBox(height: AppSpacing.md),
            StatusBadge(
              label: badgeLabel!,
              status: status,
              showIcon: true,
              compact: true,
            ),
          ],
          if (child != null) ...[
            const SizedBox(height: AppSpacing.md),
            child!,
          ],
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return Semantics(
      button: true,
      label: title,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.medium,
        child: content,
      ),
    );
  }
}

class _HealthCardHeader extends StatelessWidget {
  const _HealthCardHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.status,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final AppStatus status;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: status.backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: status.foregroundColor,
            size: 22,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
