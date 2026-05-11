import 'package:flutter/material.dart';

import '../../core/theme/pk_design.dart';

class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    required this.children,
    this.minItemWidth = 280,
    this.spacing = PkSpacing.lg,
    this.runSpacing = PkSpacing.lg,
    this.itemAspectRatio,
    super.key,
  });

  final List<Widget> children;
  final double minItemWidth;
  final double spacing;
  final double runSpacing;
  final double? itemAspectRatio;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.maxWidth / minItemWidth).floor().clamp(1, 6);
        if (itemAspectRatio == null) {
          return Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            children: children
                .map(
                  (child) => SizedBox(
                    width: (constraints.maxWidth - spacing * (columns - 1)) / columns,
                    child: child,
                  ),
                )
                .toList(),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: runSpacing,
            childAspectRatio: itemAspectRatio!,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
}

class AdaptiveTwoPane extends StatelessWidget {
  const AdaptiveTwoPane({
    required this.primary,
    required this.secondary,
    this.breakpoint = 860,
    this.spacing = PkSpacing.lg,
    this.primaryFlex = 7,
    this.secondaryFlex = 5,
    super.key,
  });

  final Widget primary;
  final Widget secondary;
  final double breakpoint;
  final double spacing;
  final int primaryFlex;
  final int secondaryFlex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < breakpoint) {
          return Column(
            children: [
              primary,
              SizedBox(height: spacing),
              secondary,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: primaryFlex, child: primary),
            SizedBox(width: spacing),
            Expanded(flex: secondaryFlex, child: secondary),
          ],
        );
      },
    );
  }
}
