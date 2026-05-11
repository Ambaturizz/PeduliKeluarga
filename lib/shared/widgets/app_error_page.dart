import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_routes.dart';
import '../../core/theme/app_spacing.dart';
import '../layouts/page_shell.dart';

class AppErrorPage extends StatelessWidget {
  const AppErrorPage({
    required this.title,
    required this.message,
    super.key,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return PageShell(
      title: title,
      subtitle: message,
      icon: Icons.error_outline,
      children: [
        FilledButton.icon(
          onPressed: () => context.go(AppRoutes.homePath),
          icon: const Icon(Icons.home_outlined),
          label: const Text('Kembali ke Beranda'),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}