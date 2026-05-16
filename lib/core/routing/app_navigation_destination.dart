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

  AppNavigationDestination copyWith({String? label}) {
    return AppNavigationDestination(
      route: route,
      branchIndex: branchIndex,
      label: label ?? this.label,
      icon: icon,
      selectedIcon: selectedIcon,
      allowedModes: allowedModes,
    );
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
      route: AppRoute.peduliAntar,
      branchIndex: 3,
      label: 'PeduliAntar',
      icon: Icons.local_shipping_outlined,
      selectedIcon: Icons.local_shipping_rounded,
      allowedModes: {
        AppUserMode.caregiver,
      },
    ),
    AppNavigationDestination(
      route: AppRoute.familyAlert,
      branchIndex: 4,
      label: 'PeduliDarurat',
      icon: Icons.emergency_outlined,
      selectedIcon: Icons.emergency,
      allowedModes: {
        AppUserMode.elder,
        AppUserMode.caregiver,
      },
    ),
    AppNavigationDestination(
      route: AppRoute.ahliPeduli,
      branchIndex: 5,
      label: 'AhliPeduli',
      icon: Icons.health_and_safety_outlined,
      selectedIcon: Icons.health_and_safety,
      allowedModes: {
        AppUserMode.caregiver,
      },
    ),
    AppNavigationDestination(
      route: AppRoute.peduliRiwayat,
      branchIndex: 6,
      label: 'PeduliRiwayat',
      icon: Icons.assignment_outlined,
      selectedIcon: Icons.assignment,
      allowedModes: {
        AppUserMode.elder,
        AppUserMode.caregiver,
      },
    ),
    AppNavigationDestination(
      route: AppRoute.peduliKonsul,
      branchIndex: 7,
      label: 'PeduliKonsul',
      icon: Icons.chat_bubble_outline_rounded,
      selectedIcon: Icons.chat_bubble_rounded,
      allowedModes: {
        AppUserMode.elder,
        AppUserMode.caregiver,
      },
    ),
    AppNavigationDestination(
      route: AppRoute.peduliPantau,
      branchIndex: 9,
      label: 'PeduliPantau',
      icon: Icons.videocam_outlined,
      selectedIcon: Icons.videocam_rounded,
      allowedModes: {
        AppUserMode.caregiver,
      },
    ),
  ];

  static List<AppNavigationDestination> forMode(AppUserMode mode) {
    final filtered = primary
        .where((item) => item.isAllowedFor(mode))
        .map((item) {
          if (mode == AppUserMode.elder && item.route == AppRoute.home) {
            return item.copyWith(label: 'PeduliDiri');
          }
          return item;
        })
        .toList();

    if (mode == AppUserMode.elder) {
      final order = <AppRoute>[
        AppRoute.home,
        AppRoute.peduliCek,
        AppRoute.peduliObat,
        AppRoute.familyAlert,
        AppRoute.peduliKonsul,
        AppRoute.peduliRiwayat,
      ];
      filtered.sort((a, b) => order.indexOf(a.route).compareTo(order.indexOf(b.route)));
    }

    if (mode == AppUserMode.caregiver) {
      final order = <AppRoute>[
        AppRoute.home,
        AppRoute.peduliRiwayat,
        AppRoute.peduliObat,
        AppRoute.peduliPantau,
        AppRoute.peduliAntar,
        AppRoute.ahliPeduli,
        AppRoute.familyAlert,
        AppRoute.peduliKonsul,
      ];
      filtered.sort((a, b) => order.indexOf(a.route).compareTo(order.indexOf(b.route)));
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
