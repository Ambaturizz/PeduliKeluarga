import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/cards/app_card.dart';
import '../../../../shared/layouts/page_shell.dart';

class PeduliObatPage extends StatelessWidget {
  const PeduliObatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageShell(
      title: 'PeduliObat',
      subtitle: 'Jadwal, reminder, dan stok obat.',
      icon: Icons.medication_outlined,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jadwal hari ini',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              const _MedicationRow(
                time: '07:00',
                name: 'Amlodipin 5mg + Metformin 500mg',
                status: 'Sudah',
              ),
              const _MedicationRow(
                time: '13:00',
                name: 'Metformin 500mg',
                status: 'Menunggu',
              ),
              const _MedicationRow(
                time: '19:00',
                name: 'Simvastatin 20mg + Metformin 500mg',
                status: 'Menunggu',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MedicationRow extends StatelessWidget {
  const _MedicationRow({
    required this.time,
    required this.name,
    required this.status,
  });

  final String time;
  final String name;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: Text(
              time,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          Expanded(
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Chip(label: Text(status)),
        ],
      ),
    );
  }
}