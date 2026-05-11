import 'package:flutter/material.dart';

import '../../../../core/theme/pk_design.dart';

class ExportMedicalSummaryCard extends StatelessWidget {
  const ExportMedicalSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return PkCard(
      padding: const EdgeInsets.all(PkSpacing.lg),
      tint: PkColors.surfaceTint,
      borderColor: PkColors.brand.withValues(alpha: 0.18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const PkIconBox(icon: Icons.description_outlined, tone: PkTone.brand),
              const SizedBox(width: PkSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Export medical summary UI',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: PkColors.text,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.35,
                          ),
                    ),
                    Text(
                      'Siapkan ringkasan 7/30 hari untuk dokter atau keluarga.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: PkColors.text2),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: PkSpacing.lg),
          const _ExportOption(label: 'Tekanan darah + gula darah', icon: Icons.monitor_heart_outlined),
          const SizedBox(height: 8),
          const _ExportOption(label: 'Log kesehatan dan kepatuhan obat', icon: Icons.fact_check_outlined),
          const SizedBox(height: 8),
          const _ExportOption(label: 'AI trend analysis dan rekomendasi', icon: Icons.auto_awesome_outlined),
          const SizedBox(height: PkSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.visibility_outlined),
                  label: const Text('Preview'),
                ),
              ),
              const SizedBox(width: PkSpacing.sm),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.ios_share_rounded),
                  label: const Text('Export PDF'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExportOption extends StatelessWidget {
  const _ExportOption({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: PkColors.brand),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: PkColors.text2,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        const Icon(Icons.check_circle_rounded, size: 18, color: PkColors.green),
      ],
    );
  }
}
