import 'package:flutter/material.dart';

import '../../../../shared/cards/app_card.dart';
import '../../../../shared/layouts/page_shell.dart';

class PeduliAntarPage extends StatelessWidget {
  const PeduliAntarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageShell(
      title: 'PeduliAntar',
      subtitle: 'Pesan dan antar obat ke rumah.',
      icon: Icons.local_shipping_outlined,
      children: [
        AppCard(
          child: Text(
            'Foundation halaman pemesanan obat. Belum ada API atau payment.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}