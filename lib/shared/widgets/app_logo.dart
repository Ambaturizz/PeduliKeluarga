import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/pk_design.dart';

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
    final logo = ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.22),
      child: Image.asset(
        AppAssets.logoPeduliKeluarga,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: PkColors.brandSoft,
              borderRadius: BorderRadius.circular(size * 0.22),
              border: Border.all(color: AppColors.teal.withValues(alpha: 0.18)),
            ),
            child: Icon(
              Icons.family_restroom_rounded,
              color: AppColors.teal,
              size: size * 0.58,
            ),
          );
        },
      ),
    );

    final child = withBackground
        ? Container(
            width: size,
            height: size,
            padding: EdgeInsets.all(size * 0.10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(size * 0.28),
              border: Border.all(color: AppColors.teal.withValues(alpha: 0.14)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.teal.withValues(alpha: 0.16),
                  blurRadius: size * 0.22,
                  offset: Offset(0, size * 0.08),
                ),
              ],
            ),
            child: logo,
          )
        : logo;

    return Semantics(
      image: true,
      label: semanticLabel,
      child: child,
    );
  }
}
