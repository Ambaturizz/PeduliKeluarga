import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/pk_design.dart';
import '../../../../state/providers/app_mode_provider.dart';
import '../../data/home_dummy_data.dart';
import '../../providers/home_dashboard_provider.dart';
import '../widgets/home_dashboard_widgets.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(appModeControllerProvider);
    final data = ref.watch(homeDashboardProvider);

    return PkGradientBackground(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              _horizontalPadding(context),
              26,
              _horizontalPadding(context),
              72,
            ),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 320),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeOutCubic,
                    child: Column(
                      key: ValueKey(data.mode),
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        PremiumPageHeader(
                          mode: mode,
                          liveLabel: data.liveLabel,
                          onModeChanged: (value) {
                            ref
                                .read(appModeControllerProvider.notifier)
                                .setMode(value);
                          },
                        ),
                        PremiumHomeHero(
                          data: data,
                          onPrimary: () {
                            context.go(
                              data.isElder
                                  ? AppRoutes.peduliCekPath
                                  : AppRoutes.peduliRiwayatPath,
                            );
                          },
                          onSecondary: () {
                            context.go(AppRoutes.peduliObatPath);
                          },
                        ),
                        const SizedBox(height: 22),
                        AlertStack(items: data.alerts),
                        const PkSectionTitle(
                          title: 'Dashboard overview',
                          subtitle: 'Premium healthcare',
                        ),
                        ResponsiveDashboardGrid(
                          left: [
                            PremiumSummaryCard(data: data),
                            const SizedBox(height: 16),
                            PremiumAiCard(data: data),
                            const SizedBox(height: 16),
                            PremiumHistoryCard(items: data.history),
                            const SizedBox(height: 16),
                          ],
                          right: [
                            PremiumMedicineCard(items: data.medicines),
                            const SizedBox(height: 16),
                            PremiumNotificationCard(items: data.alerts),
                            const SizedBox(height: 16),
                            PremiumEmergencyCard(
                              data: data,
                              onPressed: () {
                                context.go(AppRoutes.familyAlertPath);
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                        const PkSectionTitle(
                          title: 'Quick action menu',
                          subtitle: 'Akses utama tanpa bingung',
                        ),
                        PremiumQuickGrid(
                          actions: data.quickActions,
                          onTap: (action) {
                            context.go(_routeFor(action.target));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 640) return 16;
    if (width < 920) return 20;
    return 24;
  }

  String _routeFor(HomeActionTarget target) {
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