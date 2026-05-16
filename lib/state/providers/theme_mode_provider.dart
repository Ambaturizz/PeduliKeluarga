import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeControllerProvider =
    NotifierProvider<ThemeModeController, ThemeMode>(
  ThemeModeController.new,
);

class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }

  void useSystemTheme() {
    state = ThemeMode.system;
  }

  void useLightTheme() {
    state = ThemeMode.light;
  }

  void useDarkTheme() {
    state = ThemeMode.dark;
  }
}
