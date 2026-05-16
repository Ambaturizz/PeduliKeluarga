import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/pk_design.dart';
import '../../../elder_profile/domain/elder_profile.dart';
import '../../../elder_profile/providers/elder_profile_provider.dart';
import '../../providers/peduli_cek_provider.dart';
import '../widgets/peduli_cek_widgets.dart';

class PeduliCekPage extends ConsumerStatefulWidget {
  const PeduliCekPage({super.key});

  @override
  ConsumerState<PeduliCekPage> createState() => _PeduliCekPageState();
}

class _PeduliCekPageState extends ConsumerState<PeduliCekPage> {
  late final TextEditingController _systolicController;
  late final TextEditingController _diastolicController;
  late final TextEditingController _glucoseController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();

    _systolicController = TextEditingController();
    _diastolicController = TextEditingController();
    _glucoseController = TextEditingController();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _glucoseController.dispose();
    _noteController.dispose();

    super.dispose();
  }

  int? _parseNumber(String value) {
    final clean = value.trim();
    if (clean.isEmpty) return null;
    return int.tryParse(clean);
  }

  void _submit() {
    final success = ref.read(peduliCekProvider.notifier).submit();

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Lengkapi tekanan darah, gula darah, obat, nyeri, dan gejala terlebih dahulu.',
          ),
        ),
      );
    }
  }

  void _reset() {
    _systolicController.clear();
    _diastolicController.clear();
    _glucoseController.clear();
    _noteController.clear();

    ref.read(peduliCekProvider.notifier).reset();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(peduliCekProvider);
    final notifier = ref.read(peduliCekProvider.notifier);
    final elderProfile = ref.watch(elderProfileProvider);

    return PkGradientBackground(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              _horizontalPadding(context),
              26,
              _horizontalPadding(context),
              72,
            ),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeOutCubic,
                    child: state.submitted
                        ? _ResultView(
                            key: const ValueKey('result'),
                            state: state,
                            onReset: _reset,
                          )
                        : _FormView(
                            key: const ValueKey('form'),
                            state: state,
                            notifier: notifier,
                            profile: elderProfile,
                            systolicController: _systolicController,
                            diastolicController: _diastolicController,
                            glucoseController: _glucoseController,
                            noteController: _noteController,
                            parseNumber: _parseNumber,
                            onSubmit: _submit,
                            onReset: _reset,
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 640) return 16;
    if (width < 920) return 20;
    return 24;
  }
}

class _FormView extends StatelessWidget {
  const _FormView({
    required this.state,
    required this.notifier,
    required this.profile,
    required this.systolicController,
    required this.diastolicController,
    required this.glucoseController,
    required this.noteController,
    required this.parseNumber,
    required this.onSubmit,
    required this.onReset,
    super.key,
  });

  final PeduliCekState state;
  final PeduliCekController notifier;
  final ElderProfile profile;
  final TextEditingController systolicController;
  final TextEditingController diastolicController;
  final TextEditingController glucoseController;
  final TextEditingController noteController;
  final int? Function(String value) parseNumber;
  final VoidCallback onSubmit;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CekPageHeader(
          progressPercent: state.progressPercent,
          completed: state.completedRequiredSections,
          total: state.totalRequiredSections,
        ),
        const SizedBox(height: 16),
        CekProgressTracker(
          progress: state.progress,
          progressPercent: state.progressPercent,
        ),
        const SizedBox(height: 16),
        _PeduliCekGuidanceCard(profile: profile),
        const PkSectionTitle(
          title: 'Form kesehatan',
          subtitle: 'Input nyaman untuk lansia',
        ),
        CekFieldCard(
          eyebrow: 'Tekanan darah',
          title: 'Tekanan darah',
          subtitle:
              'Masukkan angka sistolik dan diastolik dari alat tensi. Contoh: 138 / 88.',
          icon: Icons.monitor_heart_outlined,
          tone: PkTone.brand,
          evaluation: state.bloodPressureEvaluation,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 520;

              final fields = [
                Expanded(
                  child: CekLargeNumberField(
                    label: 'Sistolik',
                    hint: '138',
                    unit: 'mmHg',
                    controller: systolicController,
                    onChanged: (value) {
                      notifier.setSystolic(parseNumber(value));
                    },
                  ),
                ),
                const SizedBox(width: 12, height: 12),
                Expanded(
                  child: CekLargeNumberField(
                    label: 'Diastolik',
                    hint: '88',
                    unit: 'mmHg',
                    controller: diastolicController,
                    onChanged: (value) {
                      notifier.setDiastolic(parseNumber(value));
                    },
                  ),
                ),
              ];

              if (compact) {
                return Column(
                  children: [
                    fields[0],
                    fields[1],
                    fields[2],
                  ],
                );
              }

              return Row(children: fields);
            },
          ),
        ),
        const SizedBox(height: 16),
        CekFieldCard(
          eyebrow: 'Gula darah',
          title: 'Gula darah',
          subtitle:
              'Masukkan nilai gula darah terakhir. Sistem akan memberi status otomatis.',
          icon: Icons.bloodtype_outlined,
          tone: PkTone.blue,
          evaluation: state.glucoseEvaluation,
          child: CekLargeNumberField(
            label: 'Gula darah',
            hint: '124',
            unit: 'mg/dL',
            controller: glucoseController,
            onChanged: (value) {
              notifier.setGlucose(parseNumber(value));
            },
          ),
        ),
        const SizedBox(height: 16),
        CekFieldCard(
          eyebrow: 'Minum obat',
          title: 'Kepatuhan obat',
          subtitle: 'Pilih kondisi minum obat hari ini.',
          icon: Icons.medication_outlined,
          tone: PkTone.green,
          evaluation: state.medicationEvaluation,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 720;

              return GridView.count(
                crossAxisCount: compact ? 1 : 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: compact ? 3.4 : 3.1,
                children: [
                  CekChoiceButton(
                    title: 'Sudah semua',
                    subtitle: 'Semua obat diminum sesuai jadwal.',
                    icon: Icons.check_circle_outline_rounded,
                    tone: PkTone.green,
                    selected: state.medicationAdherence == 'Sudah semua',
                    onTap: () {
                      notifier.setMedicationAdherence('Sudah semua');
                    },
                  ),
                  CekChoiceButton(
                    title: 'Ada yang terlambat',
                    subtitle: 'Obat diminum, tetapi tidak tepat waktu.',
                    icon: Icons.schedule_outlined,
                    tone: PkTone.amber,
                    selected:
                        state.medicationAdherence == 'Ada yang terlambat',
                    onTap: () {
                      notifier.setMedicationAdherence('Ada yang terlambat');
                    },
                  ),
                  CekChoiceButton(
                    title: 'Ada yang terlewat',
                    subtitle: 'Satu atau lebih obat belum diminum.',
                    icon: Icons.warning_amber_rounded,
                    tone: PkTone.red,
                    selected: state.medicationAdherence == 'Ada yang terlewat',
                    onTap: () {
                      notifier.setMedicationAdherence('Ada yang terlewat');
                    },
                  ),
                  CekChoiceButton(
                    title: 'Belum minum obat',
                    subtitle: 'Belum minum obat sama sekali hari ini.',
                    icon: Icons.error_outline_rounded,
                    tone: PkTone.red,
                    selected: state.medicationAdherence == 'Belum minum obat',
                    onTap: () {
                      notifier.setMedicationAdherence('Belum minum obat');
                    },
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        CekFieldCard(
          eyebrow: 'Pain scale input',
          title: 'Skala nyeri',
          subtitle:
              'Pilih angka 0 sampai 10. 0 berarti tidak nyeri, 10 berarti sangat nyeri.',
          icon: Icons.sentiment_satisfied_alt_outlined,
          tone: PkTone.amber,
          evaluation: state.painEvaluation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CekPainScaleSelector(
                value: state.painScale,
                onChanged: notifier.setPainScale,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Ringan',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: PkColors.green,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const Spacer(),
                  Text(
                    'Sedang',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: PkColors.amber,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const Spacer(),
                  Text(
                    'Berat',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: PkColors.red,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        CekFieldCard(
          eyebrow: 'Symptom selector',
          title: 'Keluhan hari ini',
          subtitle:
              'Pilih keluhan yang dirasakan. Jika tidak ada, pilih “Tidak ada keluhan”.',
          icon: Icons.sick_outlined,
          tone: PkTone.purple,
          evaluation: state.symptomsEvaluation,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final symptom in peduliCekSymptoms)
                CekSymptomChip(
                  label: symptom,
                  selected: state.symptoms.contains(symptom),
                  onTap: () {
                    notifier.toggleSymptom(symptom);
                  },
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        CekFieldCard(
          eyebrow: 'Health note textarea',
          title: 'Catatan tambahan',
          subtitle:
              'Opsional. Tambahkan cerita singkat agar keluarga lebih memahami kondisi hari ini.',
          icon: Icons.note_alt_outlined,
          tone: PkTone.brand,
          child: CekNoteField(
            controller: noteController,
            onChanged: notifier.setNote,
          ),
        ),
        const SizedBox(height: 16),
        CekSubmitBar(
          canSubmit: state.canSubmit,
          onSubmit: onSubmit,
          onReset: onReset,
        ),
      ],
    );
  }
}


class _PeduliCekGuidanceCard extends StatelessWidget {
  const _PeduliCekGuidanceCard({required this.profile});

  final ElderProfile profile;

  @override
  Widget build(BuildContext context) {
    final diabetesText = profile.hasDiabetes
        ? profile.usesInsulin
            ? 'Karena ada riwayat diabetes dan memakai insulin, cek gula darah minimal 1–2 kali sehari sesuai arahan dokter, misalnya sebelum sarapan dan sebelum tidur.'
            : 'Karena ada riwayat diabetes, cek gula darah perlu lebih rutin. Ikuti jadwal dari dokter.'
        : 'Jika tidak ada riwayat diabetes, catat gula darah sesuai kebutuhan atau saran dokter.';

    return PkCard(
      tint: PkColors.brandSoft,
      borderColor: PkColors.brand.withValues(alpha: 0.16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const PkIconBox(icon: Icons.info_outline_rounded, tone: PkTone.brand),
              const SizedBox(width: PkSpacing.md),
              Expanded(
                child: Text(
                  'Panduan Cek Hari Ini',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: PkColors.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: PkSpacing.md),
          Text(
            'Cek tekanan darah cukup 1 kali seminggu, kecuali dokter meminta lebih sering atau ada keluhan.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: PkColors.text2,
                  height: 1.55,
                ),
          ),
          const SizedBox(height: PkSpacing.sm),
          Text(
            diabetesText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: PkColors.text2,
                  height: 1.55,
                ),
          ),
          const SizedBox(height: PkSpacing.md),
          OutlinedButton.icon(
            onPressed: () => context.go(AppRoutes.peduliKonsulPath),
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            label: const Text('Tanya PeduliKonsul'),
          ),
        ],
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({
    required this.state,
    required this.onReset,
    super.key,
  });

  final PeduliCekState state;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final tone = state.overallLevel.tone;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PkCard(
          padding: const EdgeInsets.all(24),
          soft: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PkBadge(
                label: 'Result summary screen',
                tone: tone,
                icon: Icons.assignment_turned_in_outlined,
              ),
              const SizedBox(height: 14),
              Text(
                state.resultTitle,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: PkColors.text,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.1,
                      height: 1.08,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                state.submittedAt == null
                    ? 'Ringkasan PeduliCek berhasil dibuat.'
                    : 'Ringkasan PeduliCek berhasil dibuat pada ${_formatTime(state.submittedAt!)}.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: PkColors.text2,
                      height: 1.6,
                    ),
              ),
              const SizedBox(height: 18),
              ClipRRect(
                borderRadius: PkRadius.pillRadius,
                child: const LinearProgressIndicator(
                  value: 1,
                  minHeight: 10,
                  color: PkColors.green,
                  backgroundColor: PkColors.greenSoft,
                ),
              ),
            ],
          ),
        ),
        const PkSectionTitle(
          title: 'Ringkasan hasil',
          subtitle: 'Data lokal sementara',
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final count = width >= 920
                ? 3
                : width >= 620
                    ? 2
                    : 1;

            return GridView.count(
              crossAxisCount: count,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: count == 1 ? 2.4 : 1.55,
              children: [
                CekResultMetricTile(
                  label: 'Tekanan darah',
                  value: state.bloodPressureValue,
                  evaluation: state.bloodPressureEvaluation,
                  icon: Icons.monitor_heart_outlined,
                ),
                CekResultMetricTile(
                  label: 'Gula darah',
                  value: state.glucoseValue,
                  evaluation: state.glucoseEvaluation,
                  icon: Icons.bloodtype_outlined,
                ),
                CekResultMetricTile(
                  label: 'Obat',
                  value: state.medicationValue,
                  evaluation: state.medicationEvaluation,
                  icon: Icons.medication_outlined,
                ),
                CekResultMetricTile(
                  label: 'Skala nyeri',
                  value: state.painValue,
                  evaluation: state.painEvaluation,
                  icon: Icons.sentiment_satisfied_alt_outlined,
                ),
                CekResultMetricTile(
                  label: 'Gejala',
                  value: state.symptomValue,
                  evaluation: state.symptomsEvaluation,
                  icon: Icons.sick_outlined,
                ),
              ],
            );
          },
        ),
        if (state.note.trim().isNotEmpty) ...[
          const SizedBox(height: 16),
          PkCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PkBadge(
                  label: 'Catatan kesehatan',
                  tone: PkTone.brand,
                  icon: Icons.note_alt_outlined,
                ),
                const SizedBox(height: 12),
                Text(
                  state.note.trim(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: PkColors.text2,
                        height: 1.6,
                      ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        CekAiAnalysisCard(analysis: state.aiAnalysis),
        const SizedBox(height: 16),
        PkCard(
          clean: true,
          padding: const EdgeInsets.all(14),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 560;

              final reset = OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: PkColors.text2,
                  minimumSize: const Size.fromHeight(58),
                  shape: const StadiumBorder(),
                ),
                onPressed: onReset,
                icon: const Icon(Icons.restart_alt_rounded),
                label: const Text('Isi ulang PeduliCek'),
              );

              final home = FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: PkColors.brand,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(58),
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  context.go(AppRoutes.homePath);
                },
                icon: const Icon(Icons.home_outlined),
                label: const Text('Kembali ke Beranda'),
              );

              if (compact) {
                return Column(
                  children: [
                    home,
                    const SizedBox(height: 10),
                    reset,
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(flex: 2, child: home),
                  const SizedBox(width: 12),
                  Expanded(child: reset),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}
