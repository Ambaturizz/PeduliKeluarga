import 'package:flutter/material.dart';

import '../../core/theme/pk_design.dart';

class AppSkeleton extends StatefulWidget {
  const AppSkeleton({
    this.width,
    this.height = 16,
    this.borderRadius = 12,
    super.key,
  });

  final double? width;
  final double height;
  final double borderRadius;

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final base = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.08)
        : PkColors.line.withValues(alpha: 0.62);
    final highlight = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.15)
        : Colors.white.withValues(alpha: 0.86);

    Widget skeleton(double value) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: const [0.1, 0.45, 0.9],
            colors: [base, Color.lerp(base, highlight, value)!, base],
          ),
        ),
      );
    }

    if (reduceMotion) return skeleton(0.35);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = Curves.easeInOut.transform(_controller.value);
        return skeleton(value);
      },
    );
  }
}

class AppSkeletonCard extends StatelessWidget {
  const AppSkeletonCard({
    this.lines = 4,
    this.height = 160,
    super.key,
  });

  final int lines;
  final double height;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      clean: true,
      padding: const EdgeInsets.all(PkSpacing.lg),
      child: SizedBox(
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                AppSkeleton(width: 48, height: 48, borderRadius: 18),
                SizedBox(width: PkSpacing.md),
                Expanded(child: AppSkeleton(height: 18)),
              ],
            ),
            const SizedBox(height: PkSpacing.lg),
            ...List.generate(lines, (index) {
              final isLast = index == lines - 1;
              return Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : PkSpacing.sm),
                child: FractionallySizedBox(
                  widthFactor: isLast ? 0.62 : 1,
                  child: const AppSkeleton(height: 14),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
