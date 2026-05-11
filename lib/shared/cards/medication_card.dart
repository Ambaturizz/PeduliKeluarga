import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../components/app_status.dart';
import '../components/progress_widget.dart';
import '../components/status_badge.dart';

class MedicationCard extends StatelessWidget {
  const MedicationCard({
    required this.name,
    required this.description,
    required this.category,
    required this.stockLabel,
    required this.stockProgress,
    this.status = AppStatus.success,
    this.isWarning = false,
    this.onHistoryPressed,
    this.onSchedulePressed,
    this.onOrderPressed,
    super.key,
  });

  final String name;
  final String description;
  final String category;
  final String stockLabel;
  final double stockProgress;
  final AppStatus status;
  final bool isWarning;
  final VoidCallback? onHistoryPressed;
  final VoidCallback? onSchedulePressed;
  final VoidCallback? onOrderPressed;

  @override
  Widget build(BuildContext context) {
    final borderColor = isWarning ? AppColors.redBorder : AppColors.grayBorder;
    final borderWidth = isWarning ? 2.0 : 1.0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadius.medium,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: status.backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.medication_outlined,
                  color: status.foregroundColor,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    StatusBadge(
                      label: category,
                      status: status,
                      compact: true,
                    ),
                  ],
                ),
              ),
              if (isWarning)
                const StatusBadge(
                  label: 'Hampir habis',
                  status: AppStatus.danger,
                  compact: true,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ProgressWidget(
            label: 'Stok tersisa',
            trailingLabel: stockLabel,
            value: stockProgress,
            status: isWarning ? AppStatus.danger : AppStatus.success,
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              OutlinedButton(
                onPressed: onHistoryPressed,
                child: const Text('Riwayat konsumsi'),
              ),
              OutlinedButton(
                onPressed: onSchedulePressed,
                child: const Text('Ubah jadwal'),
              ),
              FilledButton(
                onPressed: onOrderPressed,
                style: isWarning
                    ? FilledButton.styleFrom(
                        backgroundColor: AppColors.redMid,
                      )
                    : null,
                child: Text(isWarning ? 'Pesan sekarang' : 'Pesan obat'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}