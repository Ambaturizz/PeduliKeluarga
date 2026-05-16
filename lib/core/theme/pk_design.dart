import 'package:flutter/material.dart';

final class PkColors {
  const PkColors._();

  static const Color bg = Color(0xFFF5F8F7);
  static const Color bg2 = Color(0xFFEEF6F4);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSoft = Color(0xFFF9FBFB);
  static const Color surfaceTint = Color(0xFFF0FBF7);

  static const Color text = Color(0xFF10201D);
  static const Color text2 = Color(0xFF4E625D);
  static const Color muted = Color(0xFF7D8C88);

  static const Color brand = Color(0xFF08746B);
  static const Color brand2 = Color(0xFF15A58E);
  static const Color brand3 = Color(0xFF70D3BF);
  static const Color brandSoft = Color(0xFFE6F6F2);

  static const Color blue = Color(0xFF2867B2);
  static const Color blueSoft = Color(0xFFEAF2FF);

  static const Color amber = Color(0xFFC77B16);
  static const Color amberSoft = Color(0xFFFFF4DD);

  static const Color red = Color(0xFFC33D3D);
  static const Color redSoft = Color(0xFFFFF0F0);

  static const Color purple = Color(0xFF6656D9);
  static const Color purpleSoft = Color(0xFFF0EDFF);

  static const Color green = Color(0xFF2F9A64);
  static const Color greenSoft = Color(0xFFE9F8EF);

  static Color get line => const Color(0xFF102420).withValues(alpha: 0.10);

  static Color get lineStrong =>
      const Color(0xFF102420).withValues(alpha: 0.16);
}

final class PkRadius {
  const PkRadius._();

  static const double xs = 10;
  static const double sm = 14;
  static const double md = 20;
  static const double lg = 28;
  static const double pill = 999;

  static const BorderRadius xsRadius = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius smRadius = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdRadius = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgRadius = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius pillRadius =
      BorderRadius.all(Radius.circular(pill));
}

final class PkSpacing {
  const PkSpacing._();

  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 40;
}

final class PkShadow {
  const PkShadow._();

  static List<BoxShadow> get xs {
    return [
      BoxShadow(
        color: const Color(0xFF122824).withValues(alpha: 0.06),
        blurRadius: 2,
        offset: const Offset(0, 1),
      ),
    ];
  }

  static List<BoxShadow> get sm {
    return [
      BoxShadow(
        color: const Color(0xFF15342E).withValues(alpha: 0.08),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
    ];
  }

  static List<BoxShadow> get md {
    return [
      BoxShadow(
        color: const Color(0xFF15342E).withValues(alpha: 0.12),
        blurRadius: 48,
        offset: const Offset(0, 18),
      ),
    ];
  }
}

enum PkTone {
  brand,
  blue,
  amber,
  red,
  purple,
  green,
  gray,
}

Color pkToneColor(PkTone tone) {
  return switch (tone) {
    PkTone.brand => PkColors.brand,
    PkTone.blue => PkColors.blue,
    PkTone.amber => PkColors.amber,
    PkTone.red => PkColors.red,
    PkTone.purple => PkColors.purple,
    PkTone.green => PkColors.green,
    PkTone.gray => PkColors.text2,
  };
}

Color pkToneSoft(PkTone tone) {
  return switch (tone) {
    PkTone.brand => PkColors.brandSoft,
    PkTone.blue => PkColors.blueSoft,
    PkTone.amber => PkColors.amberSoft,
    PkTone.red => PkColors.redSoft,
    PkTone.purple => PkColors.purpleSoft,
    PkTone.green => PkColors.greenSoft,
    PkTone.gray => const Color(0xFFEEF2F1),
  };
}

class PkGradientBackground extends StatelessWidget {
  const PkGradientBackground({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: PkColors.bg,
        gradient: RadialGradient(
          center: Alignment(-0.92, -0.95),
          radius: 1.1,
          colors: [
            Color(0x6670D3BF),
            Color(0x00FFFFFF),
          ],
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.92, -0.92),
            radius: 1.15,
            colors: [
              PkColors.blue.withValues(alpha: 0.13),
              Colors.transparent,
            ],
          ),
        ),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFBFDFC),
                PkColors.bg,
                Color(0xFFF7FAF9),
              ],
              stops: [0, 0.48, 1],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class PkCard extends StatelessWidget {
  const PkCard({
    required this.child,
    this.padding = const EdgeInsets.all(PkSpacing.xl),
    this.soft = false,
    this.clean = false,
    this.tint,
    this.borderColor,
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool soft;
  final bool clean;
  final Color? tint;
  final Color? borderColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: tint ?? PkColors.surface.withValues(alpha: 0.88),
      borderRadius: PkRadius.mdRadius,
      border: Border.all(color: borderColor ?? PkColors.line),
      boxShadow: clean ? PkShadow.xs : PkShadow.sm,
      gradient: soft
          ? LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                PkColors.surface.withValues(alpha: 0.94),
                PkColors.surfaceSoft.withValues(alpha: 0.94),
              ],
            )
          : null,
    );

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: padding,
      decoration: decoration,
      child: child,
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: PkRadius.mdRadius,
        onTap: onTap,
        child: card,
      ),
    );
  }
}

class PkBadge extends StatelessWidget {
  const PkBadge({
    required this.label,
    this.tone = PkTone.brand,
    this.icon,
    super.key,
  });

  final String label;
  final PkTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final color = pkToneColor(tone);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: pkToneSoft(tone),
        borderRadius: PkRadius.pillRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
          ),
        ],
      ),
    );
  }
}

class PkIconBox extends StatelessWidget {
  const PkIconBox({
    required this.icon,
    this.tone = PkTone.brand,
    this.size = 42,
    this.iconSize = 22,
    this.backgroundColor,
    this.iconColor,
    super.key,
  });

  final IconData icon;
  final PkTone tone;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor ?? pkToneSoft(tone),
        borderRadius: BorderRadius.circular(size * 0.36),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.04),
        ),
      ),
      child: Icon(
        icon,
        color: iconColor ?? pkToneColor(tone),
        size: iconSize,
      ),
    );
  }
}

class PkSectionTitle extends StatelessWidget {
  const PkSectionTitle({
    required this.title,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 26,
        bottom: 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: PkColors.text,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.4,
                  ),
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: PkColors.muted,
                    fontWeight: FontWeight.w700,
                  ),
            ),
        ],
      ),
    );
  }
}
