import 'package:flutter/widgets.dart';

final class AppConstants {
  const AppConstants._();

  static const String appName = 'PeduliKeluarga';
  static const String appTagline = 'Rawat keluarga dengan lebih tenang';

  static const Locale defaultLocale = Locale('id', 'ID');

  static const List<Locale> supportedLocales = [
    Locale('id', 'ID'),
    Locale('en', 'US'),
  ];

  static const double maxContentWidth = 840;
  static const double desktopNavigationWidth = 280;

  static const Duration shortAnimationDuration = Duration(milliseconds: 160);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 260);
  static const Duration longAnimationDuration = Duration(milliseconds: 420);
}
