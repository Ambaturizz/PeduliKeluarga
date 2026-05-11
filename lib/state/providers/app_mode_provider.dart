import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppUserMode {
  elder,
  caregiver;

  String get label {
    return switch (this) {
      AppUserMode.elder => 'Lansia',
      AppUserMode.caregiver => 'Anak',
    };
  }

  String get description {
    return switch (this) {
      AppUserMode.elder => 'PeduliDiri',
      AppUserMode.caregiver => 'Pantau Orang Tua',
    };
  }
}

final appModeControllerProvider =
    NotifierProvider<AppModeController, AppUserMode>(
  AppModeController.new,
);

class AppModeController extends Notifier<AppUserMode> {
  @override
  AppUserMode build() {
    return AppUserMode.elder;
  }

  void setMode(AppUserMode mode) {
    state = mode;
  }

  void toggle() {
    state = state == AppUserMode.elder
        ? AppUserMode.caregiver
        : AppUserMode.elder;
  }
}