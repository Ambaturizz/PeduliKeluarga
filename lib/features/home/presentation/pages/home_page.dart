import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/layouts/page_shell.dart';
import '../../../../state/providers/app_mode_provider.dart';
import '../../data/home_dummy_data.dart';
import '../../providers/home_dashboard_provider.dart';
import '../widgets/home_dashboard_widgets.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(appModeControllerProvider);
    final dashboard = ref.watch(homeDashboardProvider);

    return PageShell(
      title: 'Beranda',
      subtitle: '${mode.label} — ${mode.description}',
      icon: Icons.home_outlined,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: HomeModeSwitcher(
            mode: mode,
            onChanged: (newMode) {
              ref.read(appModeControllerProvider.notifier).setMode(newMode);
            },
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeOutCubic,
          child: Column(
            key: ValueKey(dashboard.mode),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HomeDashboardHero(
                data: dashboard,
                onPrimaryPressed: () {
                  if (dashboard.isElder) {
                    context.go(AppRoutes.peduliCekPath);
                  } else {
                    context.go(AppRoutes.peduliRiwayatPath);
                  }
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              for (final alert in dashboard.alerts)
                DashboardAlertCard(alert: alert),
              const DashboardSectionTitle(title: 'Menu cepat'),
              HomeQuickActionMenu(
                actions: dashboard.quickActions,
                onActionTap: (action) {
                  context.go(_routeForAction(action.target));
                },
              ),
              const DashboardSectionTitle(title: 'Overview'),
              DashboardResponsiveColumns(
                left: [
                  HomeHealthStatusWidget(data: dashboard),
                  const SizedBox(height: AppSpacing.lg),
                  HomeHealthSummaryCard(
                    metrics: dashboard.healthMetrics,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  HomeAIInsightCard(data: dashboard),
                  const SizedBox(height: AppSpacing.lg),
                ],
                right: [
                  HomeMedicationProgressCard(
                    medications: dashboard.medications,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  HomeNotificationSummaryCard(
                    notifications: dashboard.notifications,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  HomeTimelineCard(items: dashboard.timeline),
                  const SizedBox(height: AppSpacing.lg),
                  HomeEmergencyCTA(
                    data: dashboard,
                    onPressed: () => context.go(AppRoutes.familyAlertPath),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _routeForAction(HomeActionTarget target) {
    return switch (target) {
      HomeActionTarget.peduliCek => AppRoutes.peduliCekPath,
      HomeActionTarget.peduliObat => AppRoutes.peduliObatPath,
      HomeActionTarget.peduliRiwayat => AppRoutes.peduliRiwayatPath,
      HomeActionTarget.familyAlert => AppRoutes.familyAlertPath,
      HomeActionTarget.ahliPeduli => AppRoutes.ahliPeduliPath,
      HomeActionTarget.peduliAntar => AppRoutes.peduliAntarPath,
      HomeActionTarget.notifications => AppRoutes.notificationsPath,
      HomeActionTarget.profile => AppRoutes.profilePath,
    };
  }
}