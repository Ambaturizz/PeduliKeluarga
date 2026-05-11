import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/cards/app_card.dart';
import '../../../../shared/layouts/page_shell.dart';

class FamilyAlertPage extends StatelessWidget {
  const FamilyAlertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageShell(
      title: 'Family Alert',
      subtitle: 'Tombol darurat untuk menghubungi keluarga.',
      icon: Icons.emergency_outlined,
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.redMid,
              padding: const EdgeInsets.all(AppSpacing.xxl),
            ),
            onPressed: () {},
            icon: const Icon(Icons.emergency_outlined),
            label: const Text('Tekan untuk Darurat'),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        AppCard(
          child: Text(
            'Kontak darurat, timeline alert, dan dispatch AhliPeduli akan dibuat pada tahap fitur.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}