import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/ahli_peduli/presentation/pages/ahli_peduli_page.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/family_alert/presentation/pages/family_alert_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/peduli_antar/presentation/pages/peduli_antar_page.dart';
import '../../features/pedulicek/presentation/pages/peduli_cek_page.dart';
import '../../features/peduliobat/presentation/pages/peduli_obat_page.dart';
import '../../features/peduliriwayat/presentation/pages/peduli_riwayat_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../shared/layouts/app_navigation_shell.dart';
import '../../shared/widgets/app_error_page.dart';
import '../../state/providers/app_config_provider.dart';
import 'app_route.dart';
import 'route_transitions.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'rootNavigator',
);

final _homeNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'homeNavigator',
);

final _peduliCekNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'peduliCekNavigator',
);

final _peduliObatNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'peduliObatNavigator',
);

final _familyAlertNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'familyAlertNavigator',
);

final _ahliPeduliNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'ahliPeduliNavigator',
);

final _peduliRiwayatNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'peduliRiwayatNavigator',
);

final appRouterProvider = Provider<GoRouter>((ref) {
  final config = ref.watch(appConfigProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoute.onboarding.path,
    debugLogDiagnostics: config.enableRouterLogs,
    errorBuilder: (context, state) {
      return AppErrorPage(
        title: 'Halaman tidak ditemukan',
        message: state.error?.message ?? 'Rute yang diminta tidak tersedia.',
      );
    },
    routes: [
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoute.onboarding.path,
        name: AppRoute.onboarding.name,
        pageBuilder: (context, state) {
          return RouteTransitions.fade(
            key: state.pageKey,
            child: const OnboardingPage(),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoute.login.path,
        name: AppRoute.login.name,
        pageBuilder: (context, state) {
          return RouteTransitions.fade(
            key: state.pageKey,
            child: const LoginPage(),
          );
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppNavigationShell(
            navigationShell: navigationShell,
            currentLocation: state.uri.path,
          );
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoute.home.path,
                name: AppRoute.home.name,
                pageBuilder: (context, state) {
                  return RouteTransitions.fade(
                    key: state.pageKey,
                    child: const HomePage(),
                  );
                },
                routes: [
                  GoRoute(
                    parentNavigatorKey: _rootNavigatorKey,
                    path: AppRoute.peduliAntar.path.substring(1),
                    name: AppRoute.peduliAntar.name,
                    pageBuilder: (context, state) {
                      return RouteTransitions.slideFade(
                        key: state.pageKey,
                        child: const PeduliAntarPage(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _peduliCekNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoute.peduliCek.path,
                name: AppRoute.peduliCek.name,
                pageBuilder: (context, state) {
                  return RouteTransitions.fade(
                    key: state.pageKey,
                    child: const PeduliCekPage(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _peduliObatNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoute.peduliObat.path,
                name: AppRoute.peduliObat.name,
                pageBuilder: (context, state) {
                  return RouteTransitions.fade(
                    key: state.pageKey,
                    child: const PeduliObatPage(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _familyAlertNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoute.familyAlert.path,
                name: AppRoute.familyAlert.name,
                pageBuilder: (context, state) {
                  return RouteTransitions.fade(
                    key: state.pageKey,
                    child: const FamilyAlertPage(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _ahliPeduliNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoute.ahliPeduli.path,
                name: AppRoute.ahliPeduli.name,
                pageBuilder: (context, state) {
                  return RouteTransitions.fade(
                    key: state.pageKey,
                    child: const AhliPeduliPage(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _peduliRiwayatNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoute.peduliRiwayat.path,
                name: AppRoute.peduliRiwayat.name,
                pageBuilder: (context, state) {
                  return RouteTransitions.fade(
                    key: state.pageKey,
                    child: const PeduliRiwayatPage(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoute.notifications.path,
        name: AppRoute.notifications.name,
        pageBuilder: (context, state) {
          return RouteTransitions.slideFade(
            key: state.pageKey,
            child: const NotificationsPage(),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoute.profile.path,
        name: AppRoute.profile.name,
        pageBuilder: (context, state) {
          return RouteTransitions.slideFade(
            key: state.pageKey,
            child: const ProfilePage(),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: AppRoute.settings.path,
        name: AppRoute.settings.name,
        pageBuilder: (context, state) {
          return RouteTransitions.slideFade(
            key: state.pageKey,
            child: const SettingsPage(),
          );
        },
      ),
    ],
  );
});