final class AppAssets {
  const AppAssets._();

  static const String iconsPath = 'lib/assets/icons';
  static const String imagesPath = 'lib/assets/images';

  /// Logo resmi PeduliKeluarga.
  ///
  /// Pastikan file ini ada di:
  /// lib/assets/images/LOGO PeduliKeluarga.png
  ///
  /// dan sudah didaftarkan di pubspec.yaml:
  /// flutter:
  ///   assets:
  ///     - lib/assets/images/LOGO PeduliKeluarga.png
  static const String logoPeduliKeluarga =
      '$imagesPath/LOGO PeduliKeluarga.png';

  static const String illustrationsPath = 'lib/assets/illustrations';
  static const String animationsPath = 'lib/assets/animations';
  static const String soundsPath = 'lib/assets/sounds';
}
