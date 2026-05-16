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
    if (destinations.isEmpty) return const SizedBox.shrink();

    final selectedIndex = _selectedIndex;
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final unselected = theme.colorScheme.onSurface.withValues(alpha: 0.62);

    return SizedBox(
      height: 78,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < destinations.length; index++)
            Expanded(
              child: _BottomNavItem(
                destination: destinations[index],
                selected: index == selectedIndex,
                selectedColor: primary,
                unselectedColor: unselected,
                onTap: () {
                  final destination = destinations[index];

                  navigationShell.goBranch(
                    destination.branchIndex,
                    initialLocation: destination.branchIndex == navigationShell.currentIndex,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  int get _selectedIndex {
    final index = destinations.indexWhere(
      (item) => item.branchIndex == navigationShell.currentIndex,
    );

    return index < 0 ? 0 : index;
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.destination,
    required this.selected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTap,
  });

  final AppNavigationDestination destination;
  final bool selected;
  final Color selectedColor;
  final Color unselectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor = selected ? selectedColor : unselectedColor;
    final textStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
          color: iconColor,
          fontWeight: selected ? FontWeight.w900 : FontWeight.w800,
          letterSpacing: -0.15,
          height: 1.05,
        );

    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: Tooltip(
        message: destination.label,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  width: selected ? 56 : 46,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? selectedColor.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    selected ? destination.selectedIcon : destination.icon,
                    color: iconColor,
                    size: selected ? 26 : 24,
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        destination.label,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.visible,
                        style: textStyle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
