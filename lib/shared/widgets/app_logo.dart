import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    this.size = 40,
    this.withBackground = false,
    this.semanticLabel = 'Logo PeduliKeluarga',
    super.key,
  });

  final double size;
  final bool withBackground;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final image = ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.24),
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
    );

    final content = SizedBox(
      width: size,
      height: size,
      child: withBackground
          ? DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(size * 0.30),
                border: Border.all(
                  color: AppColors.teal.withValues(alpha: 0.14),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.teal.withValues(alpha: 0.14),
                    blurRadius: size * 0.24,
                    offset: Offset(0, size * 0.08),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(size * 0.10),
                child: image,
              ),
            )
          : image,
    );

    return Semantics(
      image: true,
      label: semanticLabel,
      child: ExcludeSemantics(child: content),
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
        border: Border.all(color: AppColors.red.withValues(alpha: 0.35)),
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