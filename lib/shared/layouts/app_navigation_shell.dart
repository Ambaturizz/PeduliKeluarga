
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


import '../../core/routing/app_navigation_destination.dart';
import '../../core/utils/responsive.dart';
import '../../state/providers/app_mode_provider.dart';
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

    final body = navigationShell;

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
    );
  }
}