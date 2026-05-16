import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import 'status_badge.dart';

class HeroHeader extends StatelessWidget {
  const HeroHeader({
    required this.title,
    required this.subtitle,
    required this.stats,
    this.badge,
    this.icon,
    this.backgroundColor = AppColors.teal,
    super.key,
  });

  final String title;
  final String subtitle;
  final String? badge;
  final IconData? icon;
  final Color backgroundColor;
  final List<HeroHeaderStat> stats;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      header: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.xxl),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: AppRadius.medium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (badge != null) ...[
              StatusBadge(
                label: badge!,
                showIcon: icon != null,
                icon: icon,
                compact: true,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.white,
                  ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.white.withValues(alpha: 0.82),
                  ),
            ),
            if (stats.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xl),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 420;

                  if (isNarrow) {
                    return Column(
                      children: [
                        for (final stat in stats) ...[
                          _HeroStatTile(stat: stat),
                          const SizedBox(height: AppSpacing.sm),
                        ],
                      ],
                    );
                  }

                  return Row(
                    children: [
                      for (var i = 0; i < stats.length; i++) ...[
                        Expanded(child: _HeroStatTile(stat: stats[i])),
                        if (i != stats.length - 1)
                          const SizedBox(width: AppSpacing.sm),
                      ],
                    ],
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class HeroHeaderStat {
  const HeroHeaderStat({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;
}

class _HeroStatTile extends StatelessWidget {
  const _HeroStatTile({
    required this.stat,
  });

  final HeroHeaderStat stat;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.black.withValues(alpha: 0.15),
        borderRadius: AppRadius.small,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Text(
              stat.value,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.white,
                  ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              stat.label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.white.withValues(alpha: 0.76),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
