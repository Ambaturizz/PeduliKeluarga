import 'package:flutter/material.dart';

import '../../state/providers/app_mode_provider.dart';
import 'app_route.dart';

class AppNavigationDestination {
  const AppNavigationDestination({
    required this.route,
    required this.branchIndex,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.allowedModes,
  });

  final AppRoute route;
  final int branchIndex;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final Set<AppUserMode> allowedModes;

  bool isAllowedFor(AppUserMode mode) {
    return allowedModes.contains(mode);
  }
}

final class AppNavigationDestinations {
  const AppNavigationDestinations._();

  static const List<AppNavigationDestination> primary = [
    AppNavigationDestination(
      route: AppRoute.home,
      branchIndex: 0,
      label: 'Beranda',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      allowedModes: {
        AppUserMode.elder,
        AppUserMode.caregiver,
      },
    ),
    AppNavigationDestination(
      route: AppRoute.peduliCek,
      branchIndex: 1,
      label: 'PeduliCek',
      icon: Icons.medical_services_outlined,
      selectedIcon: Icons.medical_services,
      allowedModes: {
        AppUserMode.elder,
      },
    ),
    AppNavigationDestination(
      route: AppRoute.peduliObat,
      branchIndex: 2,
      label: 'PeduliObat',
      icon: Icons.medication_outlined,
      selectedIcon: Icons.medication,
      allowedModes: {
        AppUserMode.elder,
        AppUserMode.caregiver,
      },
    ),
    AppNavigationDestination(
      route: AppRoute.familyAlert,
      branchIndex: 3,
      label: 'Alert',
      icon: Icons.emergency_outlined,
      selectedIcon: Icons.emergency,
      allowedModes: {
        AppUserMode.elder,
        AppUserMode.caregiver,
      },
    ),
    AppNavigationDestination(
      route: AppRoute.ahliPeduli,
      branchIndex: 4,
      label: 'AhliPeduli',
      icon: Icons.health_and_safety_outlined,
      selectedIcon: Icons.health_and_safety,
      allowedModes: {
        AppUserMode.caregiver,
      },
    ),
    AppNavigationDestination(
      route: AppRoute.peduliRiwayat,
      branchIndex: 5,
      label: 'Riwayat',
      icon: Icons.assignment_outlined,
      selectedIcon: Icons.assignment,
      allowedModes: {
        AppUserMode.elder,
        AppUserMode.caregiver,
      },
    ),
  ];

  static List<AppNavigationDestination> forMode(AppUserMode mode) {
    final filtered = primary.where((item) => item.isAllowedFor(mode)).toList();

    if (mode == AppUserMode.caregiver) {
      filtered.sort((a, b) {
        final order = <AppRoute>[
          AppRoute.home,
          AppRoute.peduliRiwayat,
          AppRoute.peduliObat,
          AppRoute.ahliPeduli,
          AppRoute.familyAlert,
        ];

        return order.indexOf(a.route).compareTo(order.indexOf(b.route));
      });
    }

    return filtered;
  }

  static AppNavigationDestination byBranchIndex(int branchIndex) {
    return primary.firstWhere(
      (item) => item.branchIndex == branchIndex,
      orElse: () => primary.first,
    );
  }
}