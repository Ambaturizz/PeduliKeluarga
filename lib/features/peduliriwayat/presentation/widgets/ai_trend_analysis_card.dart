import 'package:flutter/material.dart';

import '../../../../core/theme/pk_design.dart';
import '../../domain/health_history_models.dart';

class AiTrendAnalysisCard extends StatelessWidget {
  const AiTrendAnalysisCard({required this.insights, super.key});

  final List<AiTrendInsight> insights;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      soft: true,
      padding: const EdgeInsets.all(PkSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const PkIconBox(icon: Icons.auto_awesome_rounded, tone: PkTone.purple),
              const SizedBox(width: PkSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI trend analysis',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: PkColors.text,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.35,
                          ),
                    ),
                    Text(
                      'Analisis tren dari tekanan darah, gula darah, obat, dan log keluarga.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: PkColors.text2),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: PkSpacing.lg),
          ...insights.map(
            (insight) => Padding(
              padding: const EdgeInsets.only(bottom: PkSpacing.md),
              child: _InsightTile(insight: insight),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightTile extends StatelessWidget {
  const _InsightTile({required this.insight});

  final AiTrendInsight insight;

  @override
  Widget build(BuildContext context) {
    final tone = _toneFor(insight.severity);

    return Container(
      padding: const EdgeInsets.all(PkSpacing.md),
      decoration: BoxDecoration(
        color: pkToneSoft(tone).withValues(alpha: 0.56),
        borderRadius: PkRadius.smRadius,
        border: Border.all(color: pkToneColor(tone).withValues(alpha: 0.13)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  insight.title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: PkColors.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
              const SizedBox(width: PkSpacing.sm),
              PkBadge(
                label: '${(insight.confidence * 100).round()}%',
                tone: tone,
                icon: Icons.analytics_outlined,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            insight.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: PkColors.text2,
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.tips_and_updates_outlined, color: pkToneColor(tone), size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  insight.recommendation,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: PkColors.text,
                        height: 1.45,
                        fontWeight: FontWeight.w800,
                      ),
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
