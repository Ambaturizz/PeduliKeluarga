import 'package:flutter/material.dart';

import '../../core/animations/app_motion.dart';
import '../../core/theme/pk_design.dart';
import '../states/app_state_widgets.dart';

class PkTimelineEntry {
  const PkTimelineEntry({
    required this.timeLabel,
    required this.title,
    required this.description,
    required this.metaLabel,
    required this.icon,
    required this.tone,
  });

  final String timeLabel;
  final String title;
  final String description;
  final String metaLabel;
  final IconData icon;
  final PkTone tone;
}

class HealthTimeline extends StatelessWidget {
  const HealthTimeline({
    required this.entries,
    this.title = 'Health timeline',
    this.subtitle = 'Riwayat aktivitas kesehatan keluarga',
    this.emptyTitle = 'Timeline masih kosong',
    this.emptyMessage = 'Aktivitas kesehatan akan tampil setelah keluarga mulai mencatat data.',
    super.key,
  });

  final List<PkTimelineEntry> entries;
  final String title;
  final String subtitle;
  final String emptyTitle;
  final String emptyMessage;

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
              const PkIconBox(icon: Icons.timeline_rounded, tone: PkTone.brand),
              const SizedBox(width: PkSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: PkColors.text,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.35,
                          ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: PkColors.text2),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: PkSpacing.lg),
          if (entries.isEmpty)
            AppEmptyState(
              title: emptyTitle,
              message: emptyMessage,
              icon: Icons.timeline_rounded,
            )
          else
            AppStaggeredList(
              spacing: 0,
              children: List.generate(entries.length, (index) {
                final entry = entries[index];
                return _TimelineTile(
                  entry: entry,
                  isLast: index == entries.length - 1,
                );
              }),
            ),
        ],
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({required this.entry, required this.isLast});

  final PkTimelineEntry entry;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = pkToneColor(entry.tone);

    return Semantics(
      label: '${entry.title}, ${entry.timeLabel}, ${entry.description}',
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 72,
              child: Text(
                entry.timeLabel,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: PkColors.muted,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ),
            Column(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: pkToneSoft(entry.tone),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: PkShadow.xs,
                  ),
                  child: Icon(entry.icon, size: 17, color: color),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: PkColors.line,
                        borderRadius: PkRadius.pillRadius,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: PkSpacing.md),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : PkSpacing.lg),
                child: Container(
                  padding: const EdgeInsets.all(PkSpacing.md),
                  decoration: BoxDecoration(
                    color: PkColors.surfaceSoft,
                    borderRadius: PkRadius.smRadius,
                    border: Border.all(color: PkColors.line),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              entry.title,
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: PkColors.text,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                          ),
                          const SizedBox(width: PkSpacing.sm),
                          PkBadge(label: entry.metaLabel, tone: entry.tone),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        entry.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: PkColors.text2,
                              height: 1.5,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
