import 'package:flutter/material.dart';

import '../../../../core/theme/pk_design.dart';
import '../../domain/health_history_models.dart';

class HealthLogCard extends StatelessWidget {
  const HealthLogCard({required this.log, super.key});

  final HealthLogEntry log;

  @override
  Widget build(BuildContext context) {
    final tone = _toneFor(log.severity);

    return Container(
      padding: const EdgeInsets.all(PkSpacing.md),
      decoration: BoxDecoration(
        color: PkColors.surfaceSoft,
        borderRadius: PkRadius.smRadius,
        border: Border.all(color: PkColors.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PkIconBox(icon: _iconFor(log.title), tone: tone, size: 40, iconSize: 20),
          const SizedBox(width: PkSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        log.title,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: PkColors.text,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ),
                    Text(
                      _formatTime(log.timestamp),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: PkColors.muted,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  log.value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: pkToneColor(tone),
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 5),
                Text(
                  log.note,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: PkColors.text2),
                ),
              ],
            ),
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
  if (lower.contains('sarapan')) return Icons.restaurant_menu_rounded;
  if (lower.contains('tidur')) return Icons.bedtime_outlined;
  if (lower.contains('aktivitas')) return Icons.directions_walk_rounded;
  return Icons.notes_rounded;
}

String _formatTime(DateTime value) {
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
