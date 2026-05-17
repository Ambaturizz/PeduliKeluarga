import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    this.size = 200,
    this.withBackground = false,
    this.semanticLabel = 'Logo PeduliKeluarga',
    super.key,
  });

  final double size;

  /// Tetap dipertahankan agar pemanggilan lama seperti:
  /// AppLogo(size: 96, withBackground: true)
  /// tidak error.
  ///
  /// Tetapi background sengaja tidak dipakai lagi,
  /// supaya logo tampil transparan tanpa kotak putih.
  final bool withBackground;

  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: SizedBox(
          width: size,
          height: size,
          child: Image.asset(
            AppAssets.logoPeduliKeluarga,
            width: size,
            height: size,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
            isAntiAlias: true,
            gaplessPlayback: true,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('GAGAL LOAD LOGO: ${AppAssets.logoPeduliKeluarga}');
              debugPrint('DETAIL ERROR: $error');
              return _LogoAssetError(size: size);
            },
          ),
        ),
      ),
    );
  }
}

class _LogoAssetError extends StatelessWidget {
  const _LogoAssetError({
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      padding: EdgeInsets.all(size * 0.10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3F3),
        borderRadius: BorderRadius.circular(size * 0.24),
        border: Border.all(
          color: AppColors.red.withValues(alpha: 0.35),
        ),
      ),
      child: Text(
        'LOGO\nMISSING',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.red,
          fontSize: (size * 0.13).clamp(8, 13).toDouble(),
          fontWeight: FontWeight.w900,
          height: 1.05,
        ),
      ),
    );
  }
}
