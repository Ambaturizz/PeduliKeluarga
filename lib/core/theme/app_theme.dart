import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

final class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.teal,
      brightness: Brightness.light,
      primary: AppColors.teal,
      secondary: AppColors.blue,
      error: AppColors.redMid,
      surface: AppColors.grayCard,
    );

    return _baseTheme(
      brightness: Brightness.light,
      colorScheme: colorScheme,
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.teal,
      brightness: Brightness.dark,
      primary: AppColors.teal100,
      secondary: AppColors.blueLight,
      error: AppColors.red,
      surface: AppColors.darkSurface,
    );

    return _baseTheme(
      brightness: Brightness.dark,
      colorScheme: colorScheme,
    );
  }

  static ThemeData _baseTheme({
    required Brightness brightness,
    required ColorScheme colorScheme,
  }) {
    final isLight = brightness == Brightness.light;
    final textTheme = AppTypography.textTheme(brightness);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: isLight
          ? AppColors.grayBg
          : AppColors.darkScaffold,
      canvasColor: isLight ? AppColors.grayBg : AppColors.darkScaffold,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: isLight ? AppColors.grayCard : AppColors.darkSurface,
        foregroundColor: isLight ? AppColors.textPrimary : AppColors.white,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: isLight ? AppColors.grayCard : AppColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.medium,
          side: BorderSide(
            color: isLight ? AppColors.grayBorder : AppColors.darkBorder,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        elevation: 0,
        pressElevation: 0,
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        shape: const StadiumBorder(),
        labelStyle: textTheme.labelSmall,
        side: BorderSide(
          color: isLight ? AppColors.grayBorder : AppColors.darkBorder,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          backgroundColor: AppColors.teal,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.textMuted.withValues(alpha: 0.26),
          disabledForegroundColor: AppColors.white.withValues(alpha: 0.70),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.small,
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          foregroundColor: isLight ? AppColors.teal : AppColors.teal100,
          side: BorderSide(
            color: isLight ? AppColors.teal200 : AppColors.teal100,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.small,
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: isLight ? AppColors.teal : AppColors.teal100,
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.small,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight ? AppColors.white : AppColors.darkSurfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        labelStyle: textTheme.bodySmall,
        hintStyle: textTheme.bodySmall?.copyWith(
          color: isLight ? AppColors.textMuted : AppColors.white.withValues(alpha: 0.45),
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.small,
          borderSide: BorderSide(
            color: isLight ? AppColors.grayBorder2 : AppColors.darkBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.small,
          borderSide: BorderSide(
            color: isLight ? AppColors.grayBorder2 : AppColors.darkBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.small,
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1.5,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.small,
          borderSide: BorderSide(
            color: AppColors.redMid,
          ),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.small,
          borderSide: BorderSide(
            color: AppColors.redMid,
            width: 1.5,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 72,
        backgroundColor: isLight ? AppColors.grayCard : AppColors.darkSurface,
        indicatorColor: isLight ? AppColors.tealLight : AppColors.darkSurfaceVariant,
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelSmall),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.primary);
          }

          return IconThemeData(
            color: isLight ? AppColors.textSecondary : AppColors.white.withValues(alpha: 0.70),
          );
        }),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: isLight ? AppColors.grayCard : AppColors.darkSurface,
        indicatorColor: isLight ? AppColors.tealLight : AppColors.darkSurfaceVariant,
        selectedIconTheme: IconThemeData(color: colorScheme.primary),
        unselectedIconTheme: IconThemeData(
          color: isLight ? AppColors.textSecondary : AppColors.white.withValues(alpha: 0.70),
        ),
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.primary,
        ),
        unselectedLabelTextStyle: textTheme.labelMedium,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isLight ? AppColors.white : AppColors.darkSurface,
        modalBackgroundColor: isLight ? AppColors.white : AppColors.darkSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isLight ? AppColors.white : AppColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.large,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.teal,
        linearTrackColor: isLight ? AppColors.grayBg : AppColors.darkSurfaceVariant,
        borderRadius: AppRadius.extraSmall,
      ),
      dividerTheme: DividerThemeData(
        color: isLight ? AppColors.grayBorder : AppColors.darkBorder,
        thickness: 1,
      ),
    );
  }
}