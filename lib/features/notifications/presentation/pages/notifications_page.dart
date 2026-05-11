import 'package:flutter/material.dart';

import '../../../../shared/cards/app_card.dart';
import '../../../../shared/layouts/page_shell.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageShell(
      title: 'Notifikasi',
      subtitle: 'Pusat notifikasi PeduliKeluarga.',
      icon: Icons.notifications_outlined,
      children: [
        AppCard(
          child: Text(
            'Belum ada notifikasi.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}