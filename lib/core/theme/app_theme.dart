import 'package:flutter/material.dart';

import '../animations/app_motion.dart';
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
    final scaffold = isLight ? AppColors.grayBg : AppColors.darkScaffold;
    final surface = isLight ? AppColors.grayCard : AppColors.darkSurface;
    final border = isLight ? AppColors.grayBorder : AppColors.darkBorder;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      visualDensity: VisualDensity.standard,
      scaffoldBackgroundColor: scaffold,
      canvasColor: scaffold,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _PeduliPageTransitionsBuilder(),
          TargetPlatform.iOS: _PeduliPageTransitionsBuilder(),
          TargetPlatform.macOS: _PeduliPageTransitionsBuilder(),
          TargetPlatform.windows: _PeduliPageTransitionsBuilder(),
          TargetPlatform.linux: _PeduliPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: surface,
        foregroundColor: isLight ? AppColors.textPrimary : AppColors.white,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.medium,
          side: BorderSide(color: border),
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
        side: BorderSide(color: border),
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
          shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
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
          side: BorderSide(color: isLight ? AppColors.teal200 : AppColors.teal100),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: isLight ? AppColors.teal : AppColors.teal100,
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: isLight ? AppColors.textSecondary : AppColors.white.withValues(alpha: 0.76),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.small),
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
          borderSide: BorderSide(color: isLight ? AppColors.grayBorder2 : AppColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.small,
          borderSide: BorderSide(color: isLight ? AppColors.grayBorder2 : AppColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.small,
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.small,
          borderSide: BorderSide(color: AppColors.redMid),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.small,
          borderSide: BorderSide(color: AppColors.redMid, width: 1.5),
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
        iconColor: isLight ? AppColors.textSecondary : AppColors.white.withValues(alpha: 0.76),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 72,
        backgroundColor: surface,
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
        backgroundColor: surface,
        indicatorColor: isLight ? AppColors.tealLight : AppColors.darkSurfaceVariant,
        selectedIconTheme: IconThemeData(color: colorScheme.primary),
        unselectedIconTheme: IconThemeData(
          color: isLight ? AppColors.textSecondary : AppColors.white.withValues(alpha: 0.70),
        ),
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(color: colorScheme.primary),
        unselectedLabelTextStyle: textTheme.labelMedium,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        modalBackgroundColor: surface,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.large),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isLight ? AppColors.textPrimary : AppColors.darkSurfaceVariant,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: AppColors.white),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.medium),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isLight ? AppColors.textPrimary : AppColors.darkSurfaceVariant,
          borderRadius: AppRadius.small,
        ),
        textStyle: textTheme.labelSmall?.copyWith(color: AppColors.white),
      ),
      scrollbarTheme: ScrollbarThemeData(
        radius: const Radius.circular(AppRadius.pill),
        thickness: WidgetStateProperty.all(6),
        thumbVisibility: WidgetStateProperty.all(false),
        thumbColor: WidgetStateProperty.all(
          isLight ? AppColors.textMuted.withValues(alpha: 0.32) : AppColors.white.withValues(alpha: 0.18),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.teal,
        linearTrackColor: isLight ? AppColors.grayBg : AppColors.darkSurfaceVariant,
        borderRadius: AppRadius.extraSmall,
      ),
      dividerTheme: DividerThemeData(
        color: border,
        thickness: 1,
      ),
    );
  }
}

class _PeduliPageTransitionsBuilder extends PageTransitionsBuilder {
  const _PeduliPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (route.settings.name == null || MediaQuery.disableAnimationsOf(context)) {
      return child;
    }

    final curved = CurvedAnimation(
      parent: animation,
      curve: AppMotion.standard,
      reverseCurve: AppMotion.exit,
    );

    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.018),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}
