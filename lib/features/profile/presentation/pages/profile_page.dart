import 'package:flutter/material.dart';

import '../../../../shared/cards/app_card.dart';
import '../../../../shared/layouts/page_shell.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageShell(
      title: 'Profil',
      subtitle: 'Profil pengguna dan data keluarga.',
      icon: Icons.account_circle_outlined,
      children: [
        AppCard(
          child: Text(
            'Data profil masih placeholder.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}