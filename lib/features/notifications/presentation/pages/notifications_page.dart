import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/pk_design.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../state/providers/app_mode_provider.dart';
import '../../providers/notifications_provider.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(notificationsProvider);
    final mode = ref.watch(appModeControllerProvider);
    final isCaregiver = mode == AppUserMode.caregiver;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        leading: IconButton(
          tooltip: 'Kembali',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.homePath);
            }
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: PkGradientBackground(
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: context.horizontalPagePadding,
              vertical: PkSpacing.xxl,
            ),
            child: ResponsiveCenter(
              maxWidth: 840,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pusat Notifikasi',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: PkColors.text,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: PkSpacing.sm),
                  Text(
                    isCaregiver
                        ? 'Pengingat penting untuk PeduliPenuh dan pantauan orang tua.'
                        : 'Pengingat penting untuk PeduliDiri.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: PkColors.text2),
                  ),
                  const SizedBox(height: PkSpacing.xl),
                  for (final item in items) ...[
                    _NotificationCard(
                      item: item,
                      onTap: () => context.go(item.routePath),
                    ),
                    const SizedBox(height: PkSpacing.md),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.item, required this.onTap});

  final AppNotificationItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      clean: true,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PkIconBox(icon: item.icon, tone: item.tone),
          const SizedBox(width: PkSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: PkColors.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: PkSpacing.xs),
                Text(
                  item.message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: PkColors.text2,
                        height: 1.5,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: PkSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.timeLabel,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: PkColors.muted,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 8),
              const Icon(Icons.chevron_right_rounded, color: PkColors.muted),
            ],
          ),
        ],
      ),
    );
  }
}
