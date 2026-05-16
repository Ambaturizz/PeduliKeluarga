import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../state/providers/app_mode_provider.dart';
import 'app_route.dart';

extension NavigationHelper on BuildContext {
  void goToRoute(AppRoute route) {
    goNamed(route.name);
  }

  Future<T?> pushRoute<T extends Object?>(AppRoute route) {
    return pushNamed<T>(route.name);
  }

  void replaceRoute(AppRoute route) {
    replaceNamed(route.name);
  }

  void goHome() {
    goNamed(AppRoute.home.name);
  }

  void goLogin() {
    goNamed(AppRoute.login.name);
  }

  void goRegister() {
    goNamed(AppRoute.register.name);
  }

  void goProfile() {
    goNamed(AppRoute.profile.name);
  }

  void goNotifications() {
    goNamed(AppRoute.notifications.name);
  }

  void goPeduliKonsul() {
    goNamed(AppRoute.peduliKonsul.name);
  }

  void goInitialForMode(AppUserMode mode) {
    switch (mode) {
      case AppUserMode.elder:
        goNamed(AppRoute.home.name);
      case AppUserMode.caregiver:
        goNamed(AppRoute.home.name);
    }
  }
}
