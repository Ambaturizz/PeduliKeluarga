import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/pk_design.dart';
import '../../../../state/providers/app_mode_provider.dart';
import '../../data/home_dummy_data.dart';
import '../../providers/home_dashboard_provider.dart';
import '../widgets/gojek_style_feature_grid.dart';
import '../widgets/gojek_style_header.dart';
import '../widgets/home_dashboard_widgets.dart';
import '../widgets/peduli_poin_card.dart';
import '../../../promo/presentation/widgets/promo_carousel.dart';

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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: GojekStyleHeader(isElder: data.isElder),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: PeduliPoinCard(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 22),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: data.isElder
                                    ? [const Color(0xFF0F766E), const Color(0xFF0D9488), const Color(0xFF14B8A6)]
                                    : [const Color(0xFF1E3A8A), const Color(0xFF2563EB), const Color(0xFF3B82F6)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: (data.isElder ? const Color(0xFF0F766E) : const Color(0xFF2563EB))
                                      .withValues(alpha: 0.25),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(22),
                              child: Stack(
                                children: [
                                  // Background subtle circle graphic decorative accent
                                  Positioned(
                                    right: -20,
                                    bottom: -20,
                                    child: Container(
                                      width: 110,
                                      height: 110,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withValues(alpha: 0.08),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 40,
                                    top: -30,
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withValues(alpha: 0.05),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(18),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.18),
                                            borderRadius: BorderRadius.circular(14),
                                            border: Border.all(
                                              color: Colors.white.withValues(alpha: 0.3),
                                              width: 1,
                                            ),
                                          ),
                                          child: Icon(
                                            data.isElder ? Icons.elderly_rounded : Icons.verified_user_rounded,
                                            color: Colors.white,
                                            size: 26,
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    data.isElder ? 'MODE LANSIA' : 'MODE ANAK',
                                                    style: TextStyle(
                                                      color: Colors.white.withValues(alpha: 0.85),
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Container(
                                                    width: 4,
                                                    height: 4,
                                                    decoration: const BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    data.isElder ? 'PeduliDiri' : 'PeduliPenuh',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                data.heroTitle,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () => context.go(AppRoutes.profilePath),
                                          borderRadius: BorderRadius.circular(20),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withValues(alpha: 0.1),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Profil',
                                                  style: TextStyle(
                                                    color: data.isElder
                                                        ? const Color(0xFF0F766E)
                                                        : const Color(0xFF1E3A8A),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Icon(
                                                  Icons.chevron_right_rounded,
                                                  size: 16,
                                                  color: data.isElder
                                                      ? const Color(0xFF0F766E)
                                                      : const Color(0xFF1E3A8A),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: GojekStyleFeatureGrid(
                            actions: data.quickActions,
                            onTap: (action) {
                              context.push(_routeFor(action));
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        const PromoCarousel(),
                        const SizedBox(height: 14),
                        const SizedBox(height: 22),
                        AlertStack(items: data.alerts),
                        const PkSectionTitle(
                          title: 'Ringkasan Hari Ini',
                          subtitle: 'Data dicatat manual',
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
                        const SizedBox(height: 16),
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
      HomeActionTarget.peduliKonsul => AppRoutes.peduliKonsulPath,
      HomeActionTarget.familyChat => AppRoutes.familyChatPath,
      HomeActionTarget.peduliPantau => AppRoutes.peduliPantauPath,
      HomeActionTarget.peduliLiterasi => AppRoutes.peduliLiterasiPath,
      HomeActionTarget.peduliAmbulans => AppRoutes.peduliAmbulansPath,
      HomeActionTarget.aiPeduli => AppRoutes.aiInsightPath,
    };
  }
}
