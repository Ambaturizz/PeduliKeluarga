import 'package:flutter/material.dart';

import '../../../../shared/cards/app_card.dart';
import '../../../../shared/layouts/page_shell.dart';

class PeduliRiwayatPage extends StatelessWidget {
  const PeduliRiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageShell(
      title: 'PeduliRiwayat',
      subtitle: 'Riwayat dan tren kesehatan keluarga.',
      icon: Icons.assignment_outlined,
      children: [
        AppCard(
          child: Text(
            'Chart, filter tanggal, dan AI insight disiapkan di tahap selanjutnya.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}