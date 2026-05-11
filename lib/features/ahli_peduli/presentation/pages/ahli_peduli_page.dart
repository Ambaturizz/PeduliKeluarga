import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/cards/app_card.dart';
import '../../../../shared/layouts/page_shell.dart';

class AhliPeduliPage extends StatelessWidget {
  const AhliPeduliPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageShell(
      title: 'AhliPeduli',
      subtitle: 'Direktori dokter, perawat, klinik, dan layanan darurat.',
      icon: Icons.health_and_safety_outlined,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mitra aktif',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Data provider masih dummy. Integrasi lokasi, booking, dan rating bisa ditambahkan setelah domain model matang.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}