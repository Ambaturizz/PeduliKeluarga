import 'package:flutter/material.dart';

import '../../../../core/animations/app_motion.dart';
import '../../../../core/theme/pk_design.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/charts/vitals_trend_chart.dart';
import '../../../../shared/states/app_state_widgets.dart';
import '../../../../shared/widgets/health_timeline.dart';
import '../../data/peduli_riwayat_mock_data.dart';
import '../../domain/health_history_models.dart';
import '../widgets/ai_trend_analysis_card.dart';
import '../widgets/export_medical_summary_card.dart';
import '../widgets/health_log_card.dart';
import '../widgets/health_summary_card.dart';

class PeduliRiwayatPage extends StatefulWidget {
  const PeduliRiwayatPage({super.key});

  @override
  State<PeduliRiwayatPage> createState() => _PeduliRiwayatPageState();
}

class _PeduliRiwayatPageState extends State<PeduliRiwayatPage> {
  int _selectedRange = 7;

  @override
  Widget build(BuildContext context) {
    final labels = bloodPressureHistory.map((record) => '${record.date.day}/5').toList();

    return PkGradientBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: context.horizontalPagePadding,
            vertical: PkSpacing.xxl,
          ),
          child: ResponsiveCenter(
            maxWidth: 1180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RiwayatHero(selectedRange: _selectedRange, onRangeChanged: (range) => setState(() => _selectedRange = range)),
                const PkSectionTitle(
                  title: 'Ringkasan Kesehatan',
                  subtitle: 'Ringkasan kondisi terbaru',
                ),
                _SummaryGrid(metrics: healthSummaryMetrics),
                const PkSectionTitle(
                  title: 'Grafik Kesehatan',
                  subtitle: 'Tekanan darah dan gula darah',
                ),
                _ChartsGrid(labels: labels),
                const PkSectionTitle(
                  title: 'Analisis dan Ringkasan',
                  subtitle: 'Analisis dan simpan PDF',
                ),
                _InsightExportGrid(),
                const PkSectionTitle(
                  title: 'Catatan Kesehatan',
                  subtitle: 'Linimasa dan catatan kesehatan',
                ),
                _HistoryTimelineAndLogs(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RiwayatHero extends StatelessWidget {
  const _RiwayatHero({required this.selectedRange, required this.onRangeChanged});

  final int selectedRange;
  final ValueChanged<int> onRangeChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: PkRadius.lgRadius,
        boxShadow: PkShadow.md,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF10201D),
            Color(0xFF08746B),
            Color(0xFF2867B2),
          ],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 760;
          final header = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: PkRadius.pillRadius,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.assignment_outlined, color: Colors.white, size: 17),
                    SizedBox(width: 8),
                    Text(
                      'PEDULIRIWAYAT',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Riwayat kesehatan yang rapi dan mudah dibagikan.',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.2,
                      height: 1.02,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Catatan tekanan darah, gula darah, obat, keluhan, dan Ringkasan Kesehatan.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.78),
                      height: 1.7,
                    ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [7, 14, 30]
                    .map(
                      (range) => ChoiceChip(
                        label: Text('$range hari'),
                        selected: selectedRange == range,
                        onSelected: (_) => onRangeChanged(range),
                        selectedColor: Colors.white,
                        labelStyle: TextStyle(
                          color: selectedRange == range ? PkColors.brand : Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                        backgroundColor: Colors.white.withValues(alpha: 0.12),
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
                      ),
                    )
                    .toList(),
              ),
            ],
          );

          final scorePanel = Container(
            padding: const EdgeInsets.all(PkSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: PkRadius.mdRadius,
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite_rounded, color: Colors.white, size: 28),
                    const Spacer(),
                    Text(
                      'Ringkasan terbaru',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.72),
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  '82',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.8,
                      ),
                ),
                Text(
                  'Skor kestabilan kesehatan',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.74),
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: PkRadius.pillRadius,
                  child: LinearProgressIndicator(
                    minHeight: 9,
                    value: 0.82,
                    backgroundColor: Colors.white.withValues(alpha: 0.18),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Expanded(child: _HeroMiniStat(label: 'TD', value: '124/79')),
                    SizedBox(width: 10),
                    Expanded(child: _HeroMiniStat(label: 'Gula', value: '126')),
                    SizedBox(width: 10),
                    Expanded(child: _HeroMiniStat(label: 'Obat', value: '94%')),
                  ],
                ),
              ],
            ),
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [header, const SizedBox(height: 22), scorePanel],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(flex: 6, child: header),
              const SizedBox(width: 28),
              Expanded(flex: 4, child: scorePanel),
            ],
          );
        },
      ),
    );
  }
}

class _HeroMiniStat extends StatelessWidget {
  const _HeroMiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: PkRadius.smRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.65),
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.metrics});

  final List<HealthSummaryMetric> metrics;

  @override
  Widget build(BuildContext context) {
    if (metrics.isEmpty) {
      return const AppEmptyState(
        title: 'Ringkasan belum tersedia',
        message: 'Data ringkasan kesehatan akan muncul setelah pencatatan pertama.',
        icon: Icons.monitor_heart_outlined,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 980 ? 4 : constraints.maxWidth >= 620 ? 2 : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: columns == 1 ? 1.45 : 0.88,
          ),
          itemCount: metrics.length,
          itemBuilder: (context, index) => AppAnimatedEntrance(
            delay: Duration(milliseconds: 32 * index),
            child: HealthSummaryCard(metric: metrics[index]),
          ),
        );
      },
    );
  }
}

class _ChartsGrid extends StatelessWidget {
  const _ChartsGrid({required this.labels});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final bpChart = VitalsTrendChart(
      title: 'Blood pressure history',
      subtitle: 'Sistolik dan diastolik dalam 7 hari terakhir.',
      xLabels: labels,
      series: [
        VitalChartSeries(
          label: 'Sistolik',
          values: bloodPressureHistory.map((record) => record.systolic.toDouble()).toList(),
          color: PkColors.brand,
          unit: '',
        ),
        VitalChartSeries(
          label: 'Diastolik',
          values: bloodPressureHistory.map((record) => record.diastolic.toDouble()).toList(),
          color: PkColors.blue,
          unit: '',
        ),
      ],
    );

    final sugarChart = VitalsTrendChart(
      title: 'Blood sugar history',
      subtitle: 'Gula darah puasa dalam mg/dL.',
      xLabels: labels,
      series: [
        VitalChartSeries(
          label: 'Gula darah',
          values: bloodSugarHistory.map((record) => record.mgdl.toDouble()).toList(),
          color: PkColors.amber,
          unit: '',
        ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 860) {
          return Column(
            children: [
              bpChart,
              const SizedBox(height: PkSpacing.lg),
              sugarChart,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: bpChart),
            const SizedBox(width: PkSpacing.lg),
            Expanded(child: sugarChart),
          ],
        );
      },
    );
  }
}

class _InsightExportGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 860) {
          return Column(
            children: [
              AiTrendAnalysisCard(insights: aiTrendInsights),
              const SizedBox(height: PkSpacing.lg),
              const ExportMedicalSummaryCard(),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 7, child: AiTrendAnalysisCard(insights: aiTrendInsights)),
            const SizedBox(width: PkSpacing.lg),
            const Expanded(flex: 5, child: ExportMedicalSummaryCard()),
          ],
        );
      },
    );
  }
}

class _HistoryTimelineAndLogs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final entries = healthTimelineEvents.map(_toTimelineEntry).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final timeline = HealthTimeline(entries: entries);
        final logs = PkCard(
          soft: true,
          padding: const EdgeInsets.all(PkSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const PkIconBox(icon: Icons.notes_rounded, tone: PkTone.blue),
                  const SizedBox(width: PkSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Catatan kesehatan',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: PkColors.text,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.35,
                              ),
                        ),
                        Text(
                          'Catatan keluarga yang melengkapi data vital.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: PkColors.text2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: PkSpacing.lg),
              ...healthLogs.map(
                (log) => Padding(
                  padding: const EdgeInsets.only(bottom: PkSpacing.md),
                  child: HealthLogCard(log: log),
                ),
              ),
            ],
          ),
        );

        if (constraints.maxWidth < 900) {
          return Column(
            children: [
              timeline,
              const SizedBox(height: PkSpacing.lg),
              logs,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 7, child: timeline),
            const SizedBox(width: PkSpacing.lg),
            Expanded(flex: 5, child: logs),
          ],
        );
      },
    );
  }

  PkTimelineEntry _toTimelineEntry(HealthTimelineEvent event) {
    return PkTimelineEntry(
      timeLabel: _formatDateTime(event.timestamp),
      title: event.title,
      description: event.description,
      metaLabel: event.type.label,
      icon: _iconFor(event.type),
      tone: _toneFor(event.type),
    );
  }

  String _formatDateTime(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '${value.day} Mei\n$hour:$minute';
  }

  IconData _iconFor(TimelineEventType type) {
    return switch (type) {
      TimelineEventType.vital => Icons.monitor_heart_outlined,
      TimelineEventType.medication => Icons.medication_outlined,
      TimelineEventType.consultation => Icons.medical_information_outlined,
      TimelineEventType.lab => Icons.science_outlined,
      TimelineEventType.alert => Icons.emergency_outlined,
      TimelineEventType.note => Icons.notes_rounded,
    };
  }

  PkTone _toneFor(TimelineEventType type) {
    return switch (type) {
      TimelineEventType.vital => PkTone.brand,
      TimelineEventType.medication => PkTone.green,
      TimelineEventType.consultation => PkTone.blue,
      TimelineEventType.lab => PkTone.purple,
      TimelineEventType.alert => PkTone.red,
      TimelineEventType.note => PkTone.gray,
    };
  }
}
