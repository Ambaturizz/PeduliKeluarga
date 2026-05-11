import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/app_navigation_destination.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    required this.navigationShell,
    required this.destinations,
    super.key,
  });

  final StatefulNavigationShell navigationShell;
  final List<AppNavigationDestination> destinations;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _selectedIndex;

    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        final destination = destinations[index];

        navigationShell.goBranch(
          destination.branchIndex,
          initialLocation: destination.branchIndex == navigationShell.currentIndex,
        );
      },
      destinations: [
        for (final destination in destinations)
          NavigationDestination(
            icon: Icon(destination.icon),
            selectedIcon: Icon(destination.selectedIcon),
            label: destination.label,
            tooltip: destination.label,
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