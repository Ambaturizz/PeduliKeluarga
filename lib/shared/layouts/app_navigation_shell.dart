import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/animations/app_motion.dart';
import '../../core/routing/app_navigation_destination.dart';
import '../../core/routing/app_route.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/responsive.dart';
import '../../state/providers/app_mode_provider.dart';
import '../widgets/app_bottom_navigation.dart';
import '../widgets/app_navigation_rail.dart';
import '../widgets/app_top_bar.dart';

class AppNavigationShell extends ConsumerWidget {
  const AppNavigationShell({
    required this.navigationShell,
    required this.currentLocation,
    super.key,
  });

  final StatefulNavigationShell navigationShell;
  final String currentLocation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(appModeControllerProvider);
    final destinations = AppNavigationDestinations.forMode(mode);
    final theme = Theme.of(context);

    final body = AnimatedSwitcher(
      duration: AppMotion.fast,
      switchInCurve: AppMotion.standard,
      switchOutCurve: AppMotion.exit,
      transitionBuilder: (child, animation) {
        return AppFadeSlideTransition(animation: animation, child: child);
      },
      child: KeyedSubtree(
        key: ValueKey<int>(navigationShell.currentIndex),
        child: RepaintBoundary(child: navigationShell),
      ),
    );

    final bottomDestinations = mode == AppUserMode.caregiver
        ? destinations
            .where(
              (item) => const {
                AppRoute.home,
                AppRoute.peduliRiwayat,
                AppRoute.peduliObat,
                AppRoute.peduliPantau,
                AppRoute.peduliAntar,
              }.contains(item.route),
            )
            .toList()
        : destinations;

    if (context.isExpanded) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Row(
          children: [
            AppNavigationRail(
              navigationShell: navigationShell,
              destinations: destinations,
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: Column(
                children: [
                  const AppTopBar(showMenuButton: false),
                  Expanded(child: body),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const AppTopBar(),
      body: body,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.navigationBarTheme.backgroundColor ?? theme.colorScheme.surface,
          border: Border(top: BorderSide(color: theme.dividerColor)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: AppBottomNavigation(
              navigationShell: navigationShell,
              destinations: bottomDestinations,
            ),
          ),
        ),
      ),
    );
  }
}
