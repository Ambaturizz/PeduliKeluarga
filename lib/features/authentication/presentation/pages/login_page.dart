import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/layouts/page_shell.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageShell(
      title: 'Masuk',
      subtitle: 'Placeholder autentikasi. Backend belum dibuat.',
      icon: Icons.lock_outline,
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: 'Nomor HP atau Email',
            prefixIcon: Icon(Icons.person_outline),
          ),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Kata sandi',
            prefixIcon: Icon(Icons.lock_outline),
          ),
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: AppSpacing.xl),
        FilledButton(
          onPressed: () => context.go(AppRoutes.homePath),
          child: const Text('Masuk Demo'),
        ),
      ],
    );
  }
}