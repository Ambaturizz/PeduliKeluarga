import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_navigation_destination.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/responsive.dart';

class AppNavigationRail extends StatelessWidget {
  const AppNavigationRail({
    required this.navigationShell,
    required this.destinations,
    super.key,
  });

  final StatefulNavigationShell navigationShell;
  final List<AppNavigationDestination> destinations;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _selectedIndex;
    final extended = context.breakpoint == AppBreakpoint.large;

    return NavigationRail(
      extended: extended,
      selectedIndex: selectedIndex,
      minExtendedWidth: 236,
      leading: const Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        child: _NavigationBrand(),
      ),
      onDestinationSelected: (index) {
        final destination = destinations[index];

        navigationShell.goBranch(
          destination.branchIndex,
          initialLocation: destination.branchIndex == navigationShell.currentIndex,
        );
      },
      destinations: [
        for (final destination in destinations)
          NavigationRailDestination(
            icon: Icon(destination.icon),
            selectedIcon: Icon(destination.selectedIcon),
            label: Text(destination.label),
          ),
      ],
    );
  }

  int get _selectedIndex {
    final index = destinations.indexWhere(
      (item) => item.branchIndex == navigationShell.currentIndex,
    );

    return index < 0 ? 0 : index;
  }
}

class _NavigationBrand extends StatelessWidget {
  const _NavigationBrand();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.volunteer_activism,
          color: AppColors.teal,
        ),
        if (context.breakpoint == AppBreakpoint.large) ...[
          const SizedBox(width: AppSpacing.sm),
          Text(
            'PeduliKeluarga',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.teal,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ],
    );
  }
}