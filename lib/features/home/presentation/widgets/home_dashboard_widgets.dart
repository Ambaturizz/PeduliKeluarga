import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../state/providers/app_mode_provider.dart';
import '../../data/home_dummy_data.dart';

Color dashboardToneColor(DashboardTone tone) {
  return switch (tone) {
    DashboardTone.teal => AppColors.teal,
    DashboardTone.blue => AppColors.blue,
    DashboardTone.amber => AppColors.amberMid,
    DashboardTone.red => AppColors.redMid,
    DashboardTone.green => AppColors.greenMid,
    DashboardTone.purple => AppColors.purple,
    DashboardTone.gray => AppColors.textSecondary,
  };
}

Color dashboardToneBackground(DashboardTone tone) {
  return switch (tone) {
    DashboardTone.teal => AppColors.tealLight,
    DashboardTone.blue => AppColors.blueLight,
    DashboardTone.amber => AppColors.amberLight,
    DashboardTone.red => AppColors.redLight,
    DashboardTone.green => AppColors.greenLight,
    DashboardTone.purple => AppColors.purpleLight,
    DashboardTone.gray => AppColors.grayBg,
  };
}

class DashboardSectionTitle extends StatelessWidget {
  const DashboardSectionTitle({
    required this.title,
    this.trailing,
    super.key,
  });

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.lg,
        bottom: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.9,
                  ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
class DashboardCard extends StatelessWidget {
  const DashboardCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.xl),
    this.backgroundColor = AppColors.grayCard,
    this.borderColor = AppColors.grayBorder,
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.medium,
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return content;

    return Semantics(
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadius.medium,
          onTap: onTap,
          child: content,
        ),
      ),
    );
  }
}

class DashboardStatusBadge extends StatelessWidget {
  const DashboardStatusBadge({
    required this.label,
    required this.tone,
    this.icon,
    super.key,
  });

  final String label;
  final DashboardTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final color = dashboardToneColor(tone);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: dashboardToneBackground(tone),
        borderRadius: AppRadius.full,
        border: Border.all(
          color: color.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 14),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class DashboardAlertCard extends StatelessWidget {
  const DashboardAlertCard({
    required this.alert,
    super.key,
  });

  final HomeAlertData alert;

  @override
  Widget build(BuildContext context) {
    final color = dashboardToneColor(alert.tone);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: dashboardToneBackground(alert.tone),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(alert.icon, color: color, size: 21),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  alert.message,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: color,
                        height: 1.45,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeModeSwitcher extends StatelessWidget {
  const HomeModeSwitcher({
    required this.mode,
    required this.onChanged,
    super.key,
  });

  final AppUserMode mode;
  final ValueChanged<AppUserMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<AppUserMode>(
      showSelectedIcon: false,
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        ),
      ),
      segments: const [
        ButtonSegment<AppUserMode>(
          value: AppUserMode.elder,
          label: Text('Lansia'),
          icon: Icon(Icons.volunteer_activism_outlined),
        ),
        ButtonSegment<AppUserMode>(
          value: AppUserMode.caregiver,
          label: Text('Anak'),
          icon: Icon(Icons.groups_outlined),
        ),
      ],
      selected: {mode},
      onSelectionChanged: (selection) {
        if (selection.isEmpty) return;
        onChanged(selection.first);
      },
    );
  }
}

class HomeDashboardHero extends StatelessWidget {
  const HomeDashboardHero({
    required this.data,
    required this.onPrimaryPressed,
    super.key,
  });

  final HomeDashboardData data;
  final VoidCallback onPrimaryPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Ringkasan dashboard ${data.modeBadge}',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.xxl),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.teal,
              AppColors.tealMid,
            ],
          ),
          borderRadius: AppRadius.large,
          boxShadow: [
            BoxShadow(
              color: AppColors.teal.withValues(alpha: 0.18),
              blurRadius: 30,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardStatusBadge(
              label: data.modeBadge,
              tone: DashboardTone.teal,
              icon: data.isElder
                  ? Icons.volunteer_activism_outlined
                  : Icons.groups_outlined,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              data.name,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              data.subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.white.withValues(alpha: 0.82),
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Icon(
                  Icons.sensors_rounded,
                  color: AppColors.white.withValues(alpha: 0.75),
                  size: 17,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  data.lastUpdatedLabel,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.white.withValues(alpha: 0.78),
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 520;

                return GridView.count(
                  crossAxisCount: isCompact ? 1 : 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: AppSpacing.sm,
                  crossAxisSpacing: AppSpacing.sm,
                  childAspectRatio: isCompact ? 4.2 : 1.9,
                  children: [
                    for (final stat in data.heroStats)
                      _HeroStatTile(stat: stat),
                  ],
                );
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.tealDark,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.lg,
                  ),
                ),
                onPressed: onPrimaryPressed,
                icon: Icon(
                  data.isElder
                      ? Icons.medical_services_outlined
                      : Icons.assignment_outlined,
                ),
                label: Text(data.primaryCtaLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroStatTile extends StatelessWidget {
  const _HeroStatTile({
    required this.stat,
  });

  final HomeHeroStat stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.black.withValues(alpha: 0.15),
        borderRadius: AppRadius.medium,
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Icon(
            stat.icon,
            color: AppColors.white.withValues(alpha: 0.82),
            size: 24,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                Text(
                  stat.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.white.withValues(alpha: 0.72),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeHealthStatusWidget extends StatelessWidget {
  const HomeHealthStatusWidget({
    required this.data,
    super.key,
  });

  final HomeDashboardData data;

  @override
  Widget build(BuildContext context) {
    final tone = data.overallScore >= 90
        ? DashboardTone.green
        : data.overallScore >= 82
            ? DashboardTone.amber
            : DashboardTone.red;

    final color = dashboardToneColor(tone);

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _IconBox(
                icon: Icons.health_and_safety_outlined,
                tone: tone,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Health Status',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      data.overallStatus,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 380),
                curve: Curves.easeOutCubic,
                tween: Tween<double>(
                  begin: 0,
                  end: data.overallScore.toDouble(),
                ),
                builder: (context, value, _) {
                  return Text(
                    '${value.round()}%',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w900,
                        ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ClipRRect(
            borderRadius: AppRadius.full,
            child: LinearProgressIndicator(
              value: data.overallScore / 100,
              minHeight: 9,
              color: color,
              backgroundColor: AppColors.grayBg,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            data.overallMessage,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}

class HomeHealthSummaryCard extends StatelessWidget {
  const HomeHealthSummaryCard({
    required this.metrics,
    super.key,
  });

  final List<HomeHealthMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(
            title: 'Health Summary',
            subtitle: 'Ringkasan kondisi terbaru',
            icon: Icons.monitor_heart_outlined,
            tone: DashboardTone.teal,
          ),
          const SizedBox(height: AppSpacing.lg),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 520;

              return GridView.count(
                crossAxisCount: isWide ? 2 : 1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                childAspectRatio: isWide ? 2.25 : 3.15,
                children: [
                  for (final metric in metrics)
                    _HealthMetricTile(metric: metric),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HealthMetricTile extends StatelessWidget {
  const _HealthMetricTile({
    required this.metric,
  });

  final HomeHealthMetric metric;

  @override
  Widget build(BuildContext context) {
    final color = dashboardToneColor(metric.tone);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.grayBg,
        borderRadius: AppRadius.medium,
        border: Border.all(color: AppColors.grayBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _IconBox(
                icon: metric.icon,
                tone: metric.tone,
                size: 36,
                iconSize: 19,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  metric.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                metric.value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              if (metric.unit.isNotEmpty) ...[
                const SizedBox(width: AppSpacing.xs),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    metric.unit,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(
                child: Text(
                  metric.status,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              Text(
                metric.trend,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textMuted,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: AppRadius.full,
            child: LinearProgressIndicator(
              value: metric.progress.clamp(0, 1),
              minHeight: 6,
              color: color,
              backgroundColor: AppColors.grayBorder,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeMedicationProgressCard extends StatelessWidget {
  const HomeMedicationProgressCard({
    required this.medications,
    super.key,
  });

  final List<HomeMedicationProgress> medications;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(
            title: 'Medication Progress',
            subtitle: 'Jadwal dan kepatuhan obat hari ini',
            icon: Icons.medication_outlined,
            tone: DashboardTone.teal,
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final medication in medications)
            _MedicationProgressRow(medication: medication),
        ],
      ),
    );
  }
}

class _MedicationProgressRow extends StatelessWidget {
  const _MedicationProgressRow({
    required this.medication,
  });

  final HomeMedicationProgress medication;

  @override
  Widget build(BuildContext context) {
    final color = dashboardToneColor(medication.tone);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 62,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: dashboardToneBackground(medication.tone),
              borderRadius: AppRadius.small,
              border: Border.all(
                color: color.withValues(alpha: 0.18),
              ),
            ),
            child: Text(
              medication.time,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medication.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  medication.detail,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                ClipRRect(
                  borderRadius: AppRadius.full,
                  child: LinearProgressIndicator(
                    value: medication.progress.clamp(0, 1),
                    minHeight: 6,
                    color: color,
                    backgroundColor: AppColors.grayBg,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          DashboardStatusBadge(
            label: medication.status,
            tone: medication.tone,
            icon: medication.completed
                ? Icons.check_rounded
                : Icons.schedule_rounded,
          ),
        ],
      ),
    );
  }
}

class HomeNotificationSummaryCard extends StatelessWidget {
  const HomeNotificationSummaryCard({
    required this.notifications,
    super.key,
  });

  final List<HomeNotificationData> notifications;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(
            title: 'Notification Summary',
            subtitle: 'Aktivitas dan alert terkini',
            icon: Icons.notifications_active_outlined,
            tone: DashboardTone.amber,
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final notification in notifications)
            _NotificationRow(notification: notification),
        ],
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({
    required this.notification,
  });

  final HomeNotificationData notification;

  @override
  Widget build(BuildContext context) {
    final color = dashboardToneColor(notification.tone);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.grayBg,
        borderRadius: AppRadius.small,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(notification.icon, color: color, size: 20),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  notification.message,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            notification.time,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
        ],
      ),
    );
  }
}

class HomeAIInsightCard extends StatelessWidget {
  const HomeAIInsightCard({
    required this.data,
    super.key,
  });

  final HomeDashboardData data;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      backgroundColor: AppColors.purpleLight,
      borderColor: AppColors.purple.withValues(alpha: 0.18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(
            title: data.aiTitle,
            subtitle: data.aiConfidence,
            icon: Icons.auto_awesome_outlined,
            tone: DashboardTone.purple,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            data.aiMessage,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.purpleDark,
                  height: 1.55,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: const [
              DashboardStatusBadge(
                label: 'AI Insight',
                tone: DashboardTone.purple,
                icon: Icons.auto_awesome_outlined,
              ),
              DashboardStatusBadge(
                label: 'Preventif',
                tone: DashboardTone.teal,
                icon: Icons.health_and_safety_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HomeQuickActionMenu extends StatelessWidget {
  const HomeQuickActionMenu({
    required this.actions,
    required this.onActionTap,
    super.key,
  });

  final List<HomeQuickAction> actions;
  final ValueChanged<HomeQuickAction> onActionTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 700 ? 4 : 2;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: constraints.maxWidth >= 700 ? 1.15 : 1.08,
          children: [
            for (final action in actions)
              _QuickActionTile(
                action: action,
                onTap: () => onActionTap(action),
              ),
          ],
        );
      },
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.action,
    required this.onTap,
  });

  final HomeQuickAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = dashboardToneColor(action.tone);

    return DashboardCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBox(
            icon: action.icon,
            tone: action.tone,
            size: 46,
            iconSize: 24,
          ),
          const Spacer(),
          Text(
            action.title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            action.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          if (action.badge != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.10),
                borderRadius: AppRadius.full,
              ),
              child: Text(
                action.badge!,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class HomeEmergencyCTA extends StatelessWidget {
  const HomeEmergencyCTA({
    required this.data,
    required this.onPressed,
    super.key,
  });

  final HomeDashboardData data;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = data.isElder ? AppColors.redMid : AppColors.tealMid;

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.all(AppSpacing.xxl),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.medium,
          ),
        ),
        onPressed: onPressed,
        child: Column(
          children: [
            Icon(
              data.isElder
                  ? Icons.emergency_outlined
                  : Icons.notifications_active_outlined,
              size: 34,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              data.emergencyTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              data.emergencySubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.white.withValues(alpha: 0.78),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeTimelineCard extends StatelessWidget {
  const HomeTimelineCard({
    required this.items,
    super.key,
  });

  final List<HomeTimelineItem> items;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardHeader(
            title: 'Aktivitas terbaru',
            subtitle: 'Simulasi timeline keluarga',
            icon: Icons.timeline_outlined,
            tone: DashboardTone.blue,
          ),
          const SizedBox(height: AppSpacing.md),
          for (final item in items)
            _TimelineRow(item: item),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.item,
  });

  final HomeTimelineItem item;

  @override
  Widget build(BuildContext context) {
    final color = dashboardToneColor(item.tone);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 9,
            height: 9,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              item.title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            item.time,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textMuted,
                ),
          ),
        ],
      ),
    );
  }
}

class DashboardResponsiveColumns extends StatelessWidget {
  const DashboardResponsiveColumns({
    required this.left,
    required this.right,
    super.key,
  });

  final List<Widget> left;
  final List<Widget> right;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 820;

        if (!isWide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...left,
              ...right,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: left,
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: right,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tone,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final DashboardTone tone;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _IconBox(
          icon: icon,
          tone: tone,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox({
    required this.icon,
    required this.tone,
    this.size = 42,
    this.iconSize = 22,
  });

  final IconData icon;
  final DashboardTone tone;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final color = dashboardToneColor(tone);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: dashboardToneBackground(tone),
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Icon(
        icon,
        color: color,
        size: iconSize,
      ),
    );
  }
}