import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/cards/app_card.dart';
import '../../../../shared/layouts/page_shell.dart';

class PeduliCekPage extends StatelessWidget {
  const PeduliCekPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageShell(
      title: 'PeduliCek',
      subtitle: 'Cek kesehatan harian adaptif untuk lansia.',
      icon: Icons.medical_services_outlined,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Foundation form',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Di tahap berikutnya, komponen pertanyaan, validasi, dan state form bisa dipisah ke controller Riverpod.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}