import 'package:flutter/material.dart';

import '../../../../core/theme/pk_design.dart';
import '../../../../shared/charts/mini_line_chart.dart';
import '../../domain/health_history_models.dart';

class HealthSummaryCard extends StatelessWidget {
  const HealthSummaryCard({required this.metric, super.key});

  final HealthSummaryMetric metric;

  @override
  Widget build(BuildContext context) {
    final tone = _toneFor(metric.severity);
    final color = pkToneColor(tone);

    return PkCard(
      soft: true,
      padding: const EdgeInsets.all(PkSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PkIconBox(icon: _iconFor(metric.title), tone: tone),
              const Spacer(),
              PkBadge(label: metric.severity.label, tone: tone),
            ],
          ),
          const SizedBox(height: PkSpacing.lg),
          Text(
            metric.title,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: PkColors.muted,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
          ),
          const SizedBox(height: 7),
          RichText(
            text: TextSpan(
              text: metric.value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: PkColors.text,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
              children: [
                TextSpan(
                  text: ' ${metric.unit}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: PkColors.muted,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: PkSpacing.sm),
          Text(
            metric.caption,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: PkColors.text2,
                  height: 1.5,
                ),
          ),
          const SizedBox(height: PkSpacing.md),
          MiniLineChart(values: metric.sparklineValues, color: color),
          const SizedBox(height: PkSpacing.md),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: PkRadius.pillRadius,
                  child: LinearProgressIndicator(
                    minHeight: 7,
                    value: metric.score.clamp(0.0, 1.0).toDouble(),
                    backgroundColor: pkToneSoft(tone),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ),
              const SizedBox(width: PkSpacing.sm),
              Text(
                metric.trendLabel,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

PkTone _toneFor(HealthTrendSeverity severity) {
  return switch (severity) {
    HealthTrendSeverity.stable => PkTone.green,
    HealthTrendSeverity.attention => PkTone.amber,
    HealthTrendSeverity.improving => PkTone.brand,
    HealthTrendSeverity.risk => PkTone.red,
  };
}

IconData _iconFor(String title) {
  final lower = title.toLowerCase();
  if (lower.contains('darah')) return Icons.monitor_heart_outlined;
  if (lower.contains('gula')) return Icons.bloodtype_outlined;
  if (lower.contains('obat')) return Icons.medication_outlined;
  return Icons.nightlight_round;
}
