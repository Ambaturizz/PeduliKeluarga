import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

enum AppStatus {
  neutral,
  success,
  info,
  warning,
  danger,
  purple;

  Color get foregroundColor {
    return switch (this) {
      AppStatus.neutral => AppColors.textSecondary,
      AppStatus.success => AppColors.tealDark,
      AppStatus.info => AppColors.blueDark,
      AppStatus.warning => AppColors.amberDark,
      AppStatus.danger => AppColors.redMid,
      AppStatus.purple => AppColors.purpleDark,
    };
  }

  Color get backgroundColor {
    return switch (this) {
      AppStatus.neutral => AppColors.grayBg,
      AppStatus.success => AppColors.tealLight,
      AppStatus.info => AppColors.blueLight,
      AppStatus.warning => AppColors.amberLight,
      AppStatus.danger => AppColors.redLight,
      AppStatus.purple => AppColors.purpleLight,
    };
  }

  Color get borderColor {
    return switch (this) {
      AppStatus.neutral => AppColors.grayBorder,
      AppStatus.success => AppColors.teal100,
      AppStatus.info => AppColors.blueLight,
      AppStatus.warning => AppColors.amberBorder,
      AppStatus.danger => AppColors.redBorder,
      AppStatus.purple => AppColors.purpleLight,
    };
  }

  Color get progressColor {
    return switch (this) {
      AppStatus.neutral => AppColors.textMuted,
      AppStatus.success => AppColors.greenMid,
      AppStatus.info => AppColors.blue,
      AppStatus.warning => AppColors.amber,
      AppStatus.danger => AppColors.red,
      AppStatus.purple => AppColors.purple,
    };
  }

  IconData get defaultIcon {
    return switch (this) {
      AppStatus.neutral => Icons.info_outline,
      AppStatus.success => Icons.check_circle_outline,
      AppStatus.info => Icons.info_outline,
      AppStatus.warning => Icons.warning_amber_rounded,
      AppStatus.danger => Icons.error_outline,
      AppStatus.purple => Icons.auto_awesome_outlined,
    };
  }
}