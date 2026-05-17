import 'package:flutter/material.dart';

import '../../../../core/theme/pk_design.dart';
import '../../data/medication_dummy_data.dart';
import '../../providers/peduli_obat_provider.dart';

class MedicationPageHero extends StatelessWidget {
  const MedicationPageHero({
    required this.state,
    required this.onReset,
    super.key,
  });

  final PeduliObatState state;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.sizeOf(context).width < 640 ? 22 : 34),
      decoration: BoxDecoration(
        borderRadius: PkRadius.lgRadius,
        boxShadow: PkShadow.md,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF064D49),
            PkColors.brand,
            PkColors.brand2,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _MedicationHeroPainter())),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 760;

              final copy = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroBadge(
                    label: 'PeduliObat',
                    icon: Icons.medication_outlined,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Jadwal obat yang jelas dan mudah diikuti',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.8,
                          height: 1.02,
                        ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Pantau jadwal harian, kepatuhan minum obat, stok tersisa, reminder, dan riwayat obat keluarga dalam satu dashboard.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.78),
                          height: 1.7,
                        ),
                  ),
                  const SizedBox(height: 22),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: PkColors.brand,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          shape: const StadiumBorder(),
                        ),
                        onPressed: state.nextSchedule == null ? null : () {},
                        icon: const Icon(Icons.schedule_outlined),
                        label: Text(
                          state.nextSchedule == null
                              ? 'Semua obat hari ini selesai'
                              : 'Berikutnya ${state.nextScheduleLabel}',
                        ),
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.34),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          shape: const StadiumBorder(),
                        ),
                        onPressed: onReset,
                        icon: const Icon(Icons.restart_alt_rounded),
                        label: const Text('Reset data'),
                      ),
                    ],
                  ),
                ],
              );

              final panel = _HeroPanel(state: state);

              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    copy,
                    const SizedBox(height: 24),
                    panel,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(flex: 6, child: copy),
                  const SizedBox(width: 26),
                  Expanded(flex: 4, child: panel),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: PkRadius.pillRadius,
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.92),
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({
    required this.state,
  });

  final PeduliObatState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 42,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Catatan hari ini',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.76),
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
              Text(
                'Mode pratinjau',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.76),
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final narrow = constraints.maxWidth < 340;

              return GridView.count(
                crossAxisCount: narrow ? 1 : 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: narrow ? 4.6 : 1.08,
                children: [
                  _HeroStatTile(
                    value: '${state.adherencePercent}%',
                    label: 'Patuh',
                    icon: Icons.done_all_rounded,
                  ),
                  _HeroStatTile(
                    value: '${state.completedSchedules}/${state.totalSchedules}',
                    label: 'Jadwal selesai',
                    icon: Icons.check_circle_outline_rounded,
                  ),
                  _HeroStatTile(
                    value: state.lowStockCount.toString(),
                    label: 'Stok rendah',
                    icon: Icons.inventory_2_outlined,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HeroStatTile extends StatelessWidget {
  const _HeroStatTile({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.82), size: 20),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.7,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.70),
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class _MedicationHeroPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.055)
      ..strokeWidth = 1;

    const gap = 42.0;

    for (double x = 0; x <= size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (double y = 0; y <= size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: 0.24),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.82, size.height * 0.18),
          radius: 155,
        ),
      );

    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.18),
      155,
      glow,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MedicationGeneratorCard extends StatelessWidget {
  const MedicationGeneratorCard({
    required this.state,
    required this.onGenerate,
    required this.onCopyCalendar,
    super.key,
  });

  final PeduliObatState state;
  final VoidCallback onGenerate;
  final VoidCallback onCopyCalendar;

  @override
  Widget build(BuildContext context) {
    final generatedAt = state.generatedAt;
    final generatedLabel = generatedAt == null
        ? 'Belum dibuat'
        : '${generatedAt.day.toString().padLeft(2, '0')}/${generatedAt.month.toString().padLeft(2, '0')}/${generatedAt.year} ${generatedAt.hour.toString().padLeft(2, '0')}:${generatedAt.minute.toString().padLeft(2, '0')}';

    return PkCard(
      tint: state.hasGeneratedSchedule ? PkColors.greenSoft : PkColors.brandSoft,
      borderColor: (state.hasGeneratedSchedule ? PkColors.green : PkColors.brand)
          .withValues(alpha: 0.16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitleRow(
            eyebrow: 'Generate jadwal',
            title: 'Jadwal obat otomatis 1 bulan',
            subtitle:
                'Obat diambil dari dataset penyakit dan resep dokter. Kalender utama tetap menampilkan jadwal hari ini.',
            icon: Icons.auto_awesome_outlined,
            tone: state.hasGeneratedSchedule ? PkTone.green : PkTone.brand,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              PkBadge(
                label: state.hasGeneratedSchedule
                    ? '${state.generatedDayCount} hari dibuat'
                    : 'Siap generate',
                tone: state.hasGeneratedSchedule ? PkTone.green : PkTone.brand,
                icon: state.hasGeneratedSchedule
                    ? Icons.check_circle_outline_rounded
                    : Icons.calendar_month_outlined,
              ),
              PkBadge(
                label: 'Tampil hari ini: ${state.effectiveSchedules.length} jadwal',
                tone: PkTone.blue,
                icon: Icons.today_outlined,
              ),
              PkBadge(
                label: 'Dibuat: $generatedLabel',
                tone: PkTone.gray,
                icon: Icons.history_outlined,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Integrasi Google Calendar API tidak dipakai agar tidak membutuhkan API key. Alternatifnya, PeduliObat membuat teks kalender standar .ics yang bisa disalin dan diimpor ke kalender.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: PkColors.text2,
                  height: 1.55,
                ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 560;

              final generateButton = FilledButton.icon(
                onPressed: onGenerate,
                icon: const Icon(Icons.auto_awesome_outlined),
                label: Text(state.hasGeneratedSchedule
                    ? 'Generate ulang 1 bulan'
                    : 'Generate Jadwal 1 Bulan'),
              );

              final calendarButton = OutlinedButton.icon(
                onPressed: onCopyCalendar,
                icon: const Icon(Icons.content_copy_outlined),
                label: const Text('Salin kalender .ics'),
              );

              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    generateButton,
                    const SizedBox(height: 10),
                    calendarButton,
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: generateButton),
                  const SizedBox(width: 10),
                  Expanded(child: calendarButton),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class MedicationLowStockWarning extends StatelessWidget {
  const MedicationLowStockWarning({
    required this.items,
    required this.onReorder,
    super.key,
  });

  final List<MedicationModel> items;
  final ValueChanged<MedicationModel> onReorder;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return PkCard(
        clean: true,
        tint: PkColors.greenSoft,
        borderColor: PkColors.green.withValues(alpha: 0.14),
        child: Row(
          children: [
            const PkIconBox(
              icon: Icons.check_circle_outline_rounded,
              tone: PkTone.green,
              size: 44,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                'Semua stok obat masih aman.',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: PkColors.green,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PkCard(
              clean: true,
              tint: PkColors.redSoft,
              borderColor: PkColors.red.withValues(alpha: 0.18),
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 620;

                  final copy = Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PkIconBox(
                        icon: Icons.warning_amber_rounded,
                        tone: PkTone.red,
                        size: 46,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${item.name} hampir habis',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: PkColors.red,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Sisa ${item.stockLabel}. Disarankan pesan ulang sebelum akhir minggu.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: PkColors.red,
                                    height: 1.45,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );

                  final button = FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: PkColors.red,
                      foregroundColor: Colors.white,
                      minimumSize: Size(compact ? double.infinity : 170, 48),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () => onReorder(item),
                    icon: const Icon(Icons.local_shipping_outlined),
                    label: const Text('Pesan Sekarang'),
                  );

                  if (compact) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        copy,
                        const SizedBox(height: 14),
                        button,
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(child: copy),
                      const SizedBox(width: 14),
                      button,
                    ],
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

class MedicationAdherenceCard extends StatelessWidget {
  const MedicationAdherenceCard({
    required this.state,
    super.key,
  });

  final PeduliObatState state;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      soft: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitleRow(
            eyebrow: 'Kepatuhan minum obat',
            title: 'Kepatuhan obat hari ini',
            subtitle: 'Pantau jadwal yang sudah diminum dan yang masih menunggu.',
            icon: Icons.done_all_rounded,
            tone: state.adherenceTone,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _AdherenceRing(
                percent: state.adherencePercent,
                tone: state.adherenceTone,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PkBadge(
                      label: state.adherenceLabel,
                      tone: state.adherenceTone,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${state.completedSchedules} dari ${state.totalSchedules} jadwal sudah ditandai diminum.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: PkColors.text2,
                            height: 1.55,
                          ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: PkRadius.pillRadius,
                      child: LinearProgressIndicator(
                        value: state.dailyProgress.clamp(0, 1),
                        minHeight: 10,
                        color: pkToneColor(state.adherenceTone),
                        backgroundColor: PkColors.line,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdherenceRing extends StatelessWidget {
  const _AdherenceRing({
    required this.percent,
    required this.tone,
  });

  final int percent;
  final PkTone tone;

  @override
  Widget build(BuildContext context) {
    final color = pkToneColor(tone);

    return SizedBox(
      width: 112,
      height: 112,
      child: Stack(
        fit: StackFit.expand,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: percent / 100),
            duration: const Duration(milliseconds: 380),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return CircularProgressIndicator(
                value: value,
                strokeWidth: 11,
                strokeCap: StrokeCap.round,
                color: color,
                backgroundColor: pkToneSoft(tone),
              );
            },
          ),
          Center(
            child: Text(
              '$percent%',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class MedicationScheduleCard extends StatelessWidget {
  const MedicationScheduleCard({
    required this.schedules,
    required this.takenIds,
    required this.onMarkTaken,
    required this.onUndo,
    super.key,
  });

  final List<MedicationScheduleModel> schedules;
  final Set<String> takenIds;
  final ValueChanged<String> onMarkTaken;
  final ValueChanged<String> onUndo;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitleRow(
            eyebrow: 'Jadwal obat',
            title: 'Jadwal obat hari ini',
            subtitle: 'Tombol besar agar mudah digunakan lansia.',
            icon: Icons.schedule_outlined,
            tone: PkTone.brand,
          ),
          const SizedBox(height: 16),
          if (schedules.isEmpty)
            Text(
              'Belum ada jadwal obat hari ini.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: PkColors.text2,
                  ),
            )
          else
            for (final item in schedules)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ScheduleItem(
                  item: item,
                  taken: takenIds.contains(item.id),
                  onMarkTaken: () => onMarkTaken(item.id),
                  onUndo: () => onUndo(item.id),
                ),
              ),
        ],
      ),
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  const _ScheduleItem({
    required this.item,
    required this.taken,
    required this.onMarkTaken,
    required this.onUndo,
  });

  final MedicationScheduleModel item;
  final bool taken;
  final VoidCallback onMarkTaken;
  final VoidCallback onUndo;

  @override
  Widget build(BuildContext context) {
    final tone = taken ? PkTone.green : PkTone.amber;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PkColors.surfaceSoft,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: taken
              ? PkColors.green.withValues(alpha: 0.18)
              : PkColors.line,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 620;

          final content = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 58,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: pkToneSoft(tone),
                  borderRadius: PkRadius.smRadius,
                ),
                child: Text(
                  item.time,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: pkToneColor(tone),
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: PkColors.text,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.3,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.copy,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: PkColors.text2,
                            height: 1.45,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        PkBadge(
                          label: taken
                              ? 'Sudah diminum'
                              : item.isNext
                                  ? 'Berikutnya'
                                  : 'Menunggu',
                          tone: tone,
                          icon: taken
                              ? Icons.check_rounded
                              : Icons.access_time_rounded,
                        ),
                        if (item.isNext && !taken)
                          const PkBadge(
                            label: 'Reminder aktif',
                            tone: PkTone.brand,
                            icon: Icons.notifications_active_outlined,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );

          final action = taken
              ? OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: PkColors.text2,
                    minimumSize: Size(compact ? double.infinity : 138, 48),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: onUndo,
                  icon: const Icon(Icons.undo_rounded),
                  label: const Text('Batal'),
                )
              : FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: PkColors.brand,
                    foregroundColor: Colors.white,
                    minimumSize: Size(compact ? double.infinity : 170, 52),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: onMarkTaken,
                  icon: const Icon(Icons.check_circle_outline_rounded),
                  label: const Text('Tandai diminum'),
                );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                content,
                const SizedBox(height: 14),
                action,
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: content),
              const SizedBox(width: 14),
              action,
            ],
          );
        },
      ),
    );
  }
}

class MedicationStockGrid extends StatelessWidget {
  const MedicationStockGrid({
    required this.medications,
    required this.onReorder,
    super.key,
  });

  final List<MedicationModel> medications;
  final ValueChanged<MedicationModel> onReorder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = constraints.maxWidth >= 980
            ? 3
            : constraints.maxWidth >= 650
                ? 2
                : 1;

        final aspectRatio = switch (count) {
          1 => 1.02,
          2 => 0.96,
          _ => 1.04,
        };

        return GridView.count(
          crossAxisCount: count,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 18,
          crossAxisSpacing: 12,
          childAspectRatio: aspectRatio,
          children: [
            for (final medication in medications)
              MedicationStockCard(
                medication: medication,
                onReorder: () => onReorder(medication),
              ),
          ],
        );
      },
    );
  }
}

class MedicationStockCard extends StatelessWidget {
  const MedicationStockCard({
    required this.medication,
    required this.onReorder,
    super.key,
  });

  final MedicationModel medication;
  final VoidCallback onReorder;

  @override
  Widget build(BuildContext context) {
    final tone = medication.isLowStock
        ? PkTone.red
        : medication.category.tone;

    return PkCard(
      tint: medication.isLowStock ? PkColors.redSoft : null,
      borderColor: medication.isLowStock
          ? PkColors.red.withValues(alpha: 0.22)
          : null,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PkIconBox(
                icon: Icons.medication_outlined,
                tone: tone,
                size: 48,
                iconSize: 25,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${medication.name} ${medication.dose}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: PkColors.text,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.4,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      medication.detail,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: PkColors.text2,
                            height: 1.45,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              PkBadge(
                label: medication.category.label,
                tone: medication.category.tone,
              ),
              if (medication.isLowStock)
                const PkBadge(
                  label: 'Hampir habis',
                  tone: PkTone.red,
                  icon: Icons.warning_amber_rounded,
                ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Stok tersisa',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: PkColors.text2,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              Text(
                medication.stockLabel,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: pkToneColor(medication.stockTone),
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: PkRadius.pillRadius,
            child: LinearProgressIndicator(
              value: medication.stockPercent / 100,
              minHeight: 9,
              color: pkToneColor(medication.stockTone),
              backgroundColor: PkColors.line,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            medication.instructions,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: PkColors.text2,
                  height: 1.45,
                ),
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final compactActions = constraints.maxWidth < 430;

              final historyButton = OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: PkColors.text2,
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Riwayat ${medication.name} belum memiliki catatan tambahan.')),
                  );
                },
                child: const Text('Riwayat'),
              );

              final scheduleButton = OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: PkColors.text2,
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Jadwal ${medication.name} bisa diubah setelah fitur pengaturan obat aktif.')),
                  );
                },
                child: const Text('Ubah jadwal'),
              );

              final reorderButton = FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor:
                      medication.isLowStock ? PkColors.red : PkColors.brand,
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                ),
                onPressed: onReorder,
                icon: const Icon(Icons.local_shipping_outlined),
                label: Text(
                  medication.isLowStock
                      ? 'Pesan Sekarang'
                      : 'Pesan via PeduliAntar',
                ),
              );

              if (compactActions) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(child: historyButton),
                        const SizedBox(width: 8),
                        Expanded(child: scheduleButton),
                      ],
                    ),
                    const SizedBox(height: 8),
                    reorderButton,
                  ],
                );
              }

              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  historyButton,
                  scheduleButton,
                  reorderButton,
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class MedicationReminderCard extends StatelessWidget {
  const MedicationReminderCard({
    required this.reminders,
    required this.enabled,
    required this.onToggle,
    super.key,
  });

  final List<MedicationReminderModel> reminders;
  final bool enabled;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const PkIconBox(
                icon: Icons.notifications_active_outlined,
                tone: PkTone.amber,
                size: 48,
                iconSize: 24,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pengingat obat',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: PkColors.muted,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.1,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Reminder obat',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: PkColors.text,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: enabled,
                activeThumbColor: PkColors.brand,
                activeTrackColor: PkColors.brandSoft,
                onChanged: (_) => onToggle(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: enabled ? 1 : 0.48,
            child: Column(
              children: [
                for (final item in reminders)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ReminderItem(item: item),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderItem extends StatelessWidget {
  const _ReminderItem({
    required this.item,
  });

  final MedicationReminderModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PkColors.surfaceSoft,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: PkColors.line),
      ),
      child: Row(
        children: [
          PkIconBox(
            icon: item.icon,
            tone: item.tone,
            size: 42,
            iconSize: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: PkColors.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.copy,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: PkColors.text2,
                        height: 1.4,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          PkBadge(
            label: item.time,
            tone: item.tone,
          ),
        ],
      ),
    );
  }
}

class MedicationHistoryCard extends StatelessWidget {
  const MedicationHistoryCard({
    required this.logs,
    super.key,
  });

  final List<MedicationLogModel> logs;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitleRow(
            eyebrow: 'Riwayat obat',
            title: 'Riwayat obat',
            subtitle: 'Log minum obat, keterlambatan, dan permintaan pembelian obat.',
            icon: Icons.history_rounded,
            tone: PkTone.blue,
          ),
          const SizedBox(height: 14),
          for (final log in logs.take(6))
            _MedicationLogItem(log: log),
        ],
      ),
    );
  }
}

class _MedicationLogItem extends StatelessWidget {
  const _MedicationLogItem({
    required this.log,
  });

  final MedicationLogModel log;

  @override
  Widget build(BuildContext context) {
    final color = pkToneColor(log.tone);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: PkColors.line)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.16),
                  blurRadius: 0,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: PkColors.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  log.copy,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: PkColors.text2,
                        height: 1.45,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            log.time,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: PkColors.muted,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class MedicationReorderCta extends StatelessWidget {
  const MedicationReorderCta({
    required this.lowStockItems,
    required this.onReorderAll,
    super.key,
  });

  final List<MedicationModel> lowStockItems;
  final VoidCallback onReorderAll;

  @override
  Widget build(BuildContext context) {
    final hasLowStock = lowStockItems.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: PkRadius.mdRadius,
        boxShadow: [
          BoxShadow(
            color: (hasLowStock ? PkColors.red : PkColors.brand)
                .withValues(alpha: 0.18),
            blurRadius: 34,
            offset: const Offset(0, 14),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: hasLowStock
              ? const [
                  Color(0xFFA92F32),
                  Color(0xFFD44848),
                ]
              : const [
                  PkColors.brand,
                  PkColors.brand2,
                ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PkIconBox(
            icon: hasLowStock
                ? Icons.local_shipping_outlined
                : Icons.inventory_2_outlined,
            tone: hasLowStock ? PkTone.red : PkTone.brand,
            backgroundColor: Colors.white.withValues(alpha: 0.18),
            iconColor: Colors.white,
            size: 50,
            iconSize: 26,
          ),
          const SizedBox(height: 16),
          Text(
            hasLowStock ? 'Obat hampir habis' : 'Stok obat aman',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.6,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            hasLowStock
                ? '${lowStockItems.length} obat perlu dipesan ulang agar jadwal tidak terputus.'
                : 'Tidak ada obat yang perlu dipesan ulang hari ini.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.78),
                  height: 1.55,
                ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: hasLowStock ? PkColors.red : PkColors.brand,
                minimumSize: const Size.fromHeight(54),
                shape: const StadiumBorder(),
              ),
              onPressed: hasLowStock ? onReorderAll : null,
              icon: const Icon(Icons.local_shipping_outlined),
              label: const Text('Pesan via PeduliAntar'),
            ),
          ),
        ],
      ),
    );
  }
}

class PeduliObatResponsiveGrid extends StatelessWidget {
  const PeduliObatResponsiveGrid({
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
        final wide = constraints.maxWidth >= 920;

        if (!wide) {
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
            const SizedBox(width: 16),
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

class _CardTitleRow extends StatelessWidget {
  const _CardTitleRow({
    required this.eyebrow,
    required this.title,
    required this.icon,
    required this.tone,
    this.subtitle,
  });

  final String eyebrow;
  final String title;
  final String? subtitle;
  final IconData icon;
  final PkTone tone;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: PkColors.muted,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: PkColors.text,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      height: 1.25,
                    ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: PkColors.text2,
                        height: 1.55,
                      ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 14),
        PkIconBox(icon: icon, tone: tone),
      ],
    );
  }
}