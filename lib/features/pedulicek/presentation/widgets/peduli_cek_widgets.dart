
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/pk_design.dart';
import '../../providers/peduli_cek_provider.dart';

class CekPageHeader extends StatelessWidget {
  const CekPageHeader({
    required this.progressPercent,
    required this.completed,
    required this.total,
    super.key,
  });

  final int progressPercent;
  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      padding: const EdgeInsets.all(24),
      soft: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 720;

          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PkBadge(
                label: 'PeduliCek harian',
                tone: PkTone.brand,
                icon: Icons.medical_services_outlined,
              ),
              const SizedBox(height: 14),
              Text(
                'Cek kesehatan singkat yang ramah lansia',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: PkColors.text,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.1,
                      height: 1.05,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                'Isi tekanan darah, gula darah, obat, nyeri, gejala, dan catatan. Hasil akan dirangkum dengan analisis AI.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: PkColors.text2,
                      height: 1.65,
                    ),
              ),
            ],
          );

          final progress = CekProgressRing(
            percent: progressPercent,
            completed: completed,
            total: total,
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                copy,
                const SizedBox(height: 22),
                Center(child: progress),
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: copy),
              const SizedBox(width: 24),
              progress,
            ],
          );
        },
      ),
    );
  }
}

class CekProgressRing extends StatelessWidget {
  const CekProgressRing({
    required this.percent,
    required this.completed,
    required this.total,
    super.key,
  });

  final int percent;
  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 148,
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: percent / 100),
            duration: const Duration(milliseconds: 360),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return SizedBox(
                width: 126,
                height: 126,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: value,
                      strokeWidth: 12,
                      strokeCap: StrokeCap.round,
                      color: PkColors.brand2,
                      backgroundColor: PkColors.brandSoft,
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${(value * 100).round()}%',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: PkColors.brand,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -1,
                                ),
                          ),
                          Text(
                            'selesai',
                            style:
                                Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: PkColors.muted,
                                      fontWeight: FontWeight.w800,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Text(
            '$completed dari $total bagian',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: PkColors.text2,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class CekProgressTracker extends StatelessWidget {
  const CekProgressTracker({
    required this.progress,
    required this.progressPercent,
    super.key,
  });

  final double progress;
  final int progressPercent;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      clean: true,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  progressPercent == 100
                      ? 'PeduliCek selesai'
                      : 'Progress PeduliCek',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: PkColors.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
              PkBadge(
                label: '$progressPercent%',
                tone: progressPercent == 100 ? PkTone.green : PkTone.brand,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: PkRadius.pillRadius,
            child: LinearProgressIndicator(
              value: progress.clamp(0, 1),
              minHeight: 10,
              color: progressPercent == 100 ? PkColors.green : PkColors.brand2,
              backgroundColor: PkColors.line,
            ),
          ),
        ],
      ),
    );
  }
}

class CekFieldCard extends StatelessWidget {
  const CekFieldCard({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tone,
    required this.child,
    this.evaluation,
    super.key,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final IconData icon;
  final PkTone tone;
  final Widget child;
  final CekEvaluation? evaluation;

  @override
  Widget build(BuildContext context) {
    final status = evaluation;

    return PkCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PkIconBox(icon: icon, tone: tone, size: 48, iconSize: 24),
              const SizedBox(width: 14),
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
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: PkColors.text,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: PkColors.text2,
                            height: 1.5,
                          ),
                    ),
                  ],
                ),
              ),
              if (status != null)
                PkBadge(
                  label: status.label,
                  tone: status.level.tone,
                ),
            ],
          ),
          const SizedBox(height: 18),
          child,
          if (status != null && status.level != CekLevel.empty) ...[
            const SizedBox(height: 14),
            CekInlineMessage(evaluation: status),
          ],
        ],
      ),
    );
  }
}

class CekInlineMessage extends StatelessWidget {
  const CekInlineMessage({
    required this.evaluation,
    super.key,
  });

  final CekEvaluation evaluation;

  @override
  Widget build(BuildContext context) {
    final tone = evaluation.level.tone;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: pkToneSoft(tone),
        borderRadius: PkRadius.smRadius,
        border: Border.all(
          color: pkToneColor(tone).withValues(alpha: 0.14),
        ),
      ),
      child: Row(
        children: [
          Icon(
            evaluation.level == CekLevel.ok
                ? Icons.check_circle_outline_rounded
                : Icons.info_outline_rounded,
            color: pkToneColor(tone),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              evaluation.message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: pkToneColor(tone),
                    height: 1.45,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class CekLargeNumberField extends StatelessWidget {
  const CekLargeNumberField({
    required this.label,
    required this.controller,
    required this.onChanged,
    this.unit,
    this.hint,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? unit;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: label,
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(3),
        ],
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: PkColors.text,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.6,
            ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixText: unit,
          filled: true,
          fillColor: PkColors.surfaceSoft,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: PkRadius.smRadius,
            borderSide: BorderSide(color: PkColors.line),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: PkRadius.smRadius,
            borderSide: BorderSide(color: PkColors.line),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: PkRadius.smRadius,
            borderSide: const BorderSide(
              color: PkColors.brand,
              width: 1.6,
            ),
          ),
        ),
      ),
    );
  }
}

class CekChoiceButton extends StatelessWidget {
  const CekChoiceButton({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    required this.tone,
    this.icon,
    super.key,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  final PkTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final color = pkToneColor(tone);

    return Semantics(
      button: true,
      selected: selected,
      label: title,
      hint: subtitle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: selected ? pkToneSoft(tone) : PkColors.surfaceSoft,
          borderRadius: PkRadius.smRadius,
          border: Border.all(
            color: selected ? color : PkColors.line,
            width: selected ? 1.5 : 1,
          ),
          boxShadow: selected ? PkShadow.xs : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: PkRadius.smRadius,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  if (icon != null) ...[
                    PkIconBox(
                      icon: icon!,
                      tone: tone,
                      size: 38,
                      iconSize: 20,
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: selected ? color : PkColors.text,
                                    fontWeight: FontWeight.w900,
                                  ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          subtitle,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: PkColors.text2,
                                    height: 1.4,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    selected
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: selected ? color : PkColors.muted,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CekPainScaleSelector extends StatelessWidget {
  const CekPainScaleSelector({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final int? value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i <= 10; i++)
          _PainButton(
            value: i,
            selected: value == i,
            onTap: () => onChanged(i),
          ),
      ],
    );
  }
}

class _PainButton extends StatelessWidget {
  const _PainButton({
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final int value;
  final bool selected;
  final VoidCallback onTap;

  PkTone get tone {
    if (value >= 7) return PkTone.red;
    if (value >= 4) return PkTone.amber;
    return PkTone.green;
  }

  @override
  Widget build(BuildContext context) {
    final color = pkToneColor(tone);

    return Semantics(
      button: true,
      selected: selected,
      label: 'Skala nyeri $value',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 54,
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? pkToneSoft(tone) : PkColors.surfaceSoft,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? color : PkColors.line,
                width: selected ? 2 : 1,
              ),
            ),
            child: Text(
              '$value',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: selected ? color : PkColors.text2,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class CekSymptomChip extends StatelessWidget {
  const CekSymptomChip({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  bool get isHighRisk => highRiskSymptoms.contains(label);

  PkTone get tone {
    if (label == noSymptomOption) return PkTone.green;
    if (isHighRisk) return PkTone.red;
    return PkTone.brand;
  }

  @override
  Widget build(BuildContext context) {
    final color = pkToneColor(tone);

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: PkRadius.pillRadius,
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              color: selected ? pkToneSoft(tone) : PkColors.surfaceSoft,
              borderRadius: PkRadius.pillRadius,
              border: Border.all(
                color: selected ? color : PkColors.line,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  selected ? Icons.check_rounded : Icons.add_rounded,
                  color: selected ? color : PkColors.muted,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: selected ? color : PkColors.text2,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CekNoteField extends StatelessWidget {
  const CekNoteField({
    required this.controller,
    required this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      minLines: 5,
      maxLines: 7,
      textInputAction: TextInputAction.newline,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: PkColors.text,
            height: 1.45,
          ),
      decoration: InputDecoration(
        hintText:
            'Contoh: Hari ini agak pusing setelah sarapan, sudah minum obat pagi.',
        filled: true,
        fillColor: PkColors.surfaceSoft,
        alignLabelWithHint: true,
        contentPadding: const EdgeInsets.all(18),
        border: OutlineInputBorder(
          borderRadius: PkRadius.smRadius,
          borderSide: BorderSide(color: PkColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: PkRadius.smRadius,
          borderSide: BorderSide(color: PkColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: PkRadius.smRadius,
          borderSide: const BorderSide(
            color: PkColors.brand,
            width: 1.6,
          ),
        ),
      ),
    );
  }
}

class CekResultMetricTile extends StatelessWidget {
  const CekResultMetricTile({
    required this.label,
    required this.value,
    required this.evaluation,
    required this.icon,
    super.key,
  });

  final String label;
  final String value;
  final CekEvaluation evaluation;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final tone = evaluation.level.tone;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: PkColors.surfaceSoft,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: PkColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PkIconBox(
                icon: icon,
                tone: tone,
                size: 38,
                iconSize: 20,
              ),
              const Spacer(),
              PkBadge(label: evaluation.label, tone: tone),
            ],
          ),
          const Spacer(),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: PkColors.muted,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: PkColors.text,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.8,
                ),
          ),
        ],
      ),
    );
  }
}

class CekAiAnalysisCard extends StatelessWidget {
  const CekAiAnalysisCard({
    required this.analysis,
    super.key,
  });

  final CekAiAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      tint: pkToneSoft(analysis.tone),
      borderColor: pkToneColor(analysis.tone).withValues(alpha: 0.16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PkIconBox(
                icon: Icons.auto_awesome_outlined,
                tone: analysis.tone,
                size: 48,
                iconSize: 24,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI ANALYSIS CARD',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: pkToneColor(analysis.tone),
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.1,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      analysis.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: PkColors.text,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.7,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            analysis.message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: PkColors.text2,
                  height: 1.65,
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final item in analysis.recommendations)
                PkBadge(
                  label: item,
                  tone: analysis.tone,
                  icon: Icons.tips_and_updates_outlined,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class CekSubmitBar extends StatelessWidget {
  const CekSubmitBar({
    required this.canSubmit,
    required this.onSubmit,
    required this.onReset,
    super.key,
  });

  final bool canSubmit;
  final VoidCallback onSubmit;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      padding: const EdgeInsets.all(14),
      clean: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 540;

          final submit = FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: PkColors.brand,
              foregroundColor: Colors.white,
              disabledBackgroundColor: PkColors.muted.withValues(alpha: 0.28),
              minimumSize: const Size.fromHeight(58),
              shape: const StadiumBorder(),
            ),
            onPressed: canSubmit ? onSubmit : null,
            icon: const Icon(Icons.send_rounded),
            label: const Text('Kirim PeduliCek'),
          );

          final reset = OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: PkColors.text2,
              minimumSize: const Size.fromHeight(58),
              shape: const StadiumBorder(),
            ),
            onPressed: onReset,
            icon: const Icon(Icons.restart_alt_rounded),
            label: const Text('Reset'),
          );

          if (compact) {
            return Column(
              children: [
                submit,
                const SizedBox(height: 10),
                reset,
              ],
            );
          }

          return Row(
            children: [
              Expanded(flex: 2, child: submit),
              const SizedBox(width: 12),
              Expanded(child: reset),
            ],
          );
        },
      ),
    );
  }
}
