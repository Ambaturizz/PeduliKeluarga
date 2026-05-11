
import 'package:flutter/material.dart';

/// App-level accessibility guardrails.
///
/// Keeps text readable without letting extreme text-scale values break the
/// dashboard layout, enables logical focus order, and removes duplicate scroll
/// glow noise for a calmer healthcare UI.
class AppAccessibility extends StatelessWidget {
  const AppAccessibility({
    required this.child,
    this.label,
    this.minTextScale = 0.90,
    this.maxTextScale = 1.22,
    super.key,
  });

  final Widget child;
  final String? label;
  final double minTextScale;
  final double maxTextScale;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final effectiveScale = MediaQuery.textScalerOf(context)
        .scale(1)
        .clamp(minTextScale, maxTextScale)
        .toDouble();

    return MediaQuery(
      data: mediaQuery.copyWith(textScaler: TextScaler.linear(effectiveScale)),
      child: ScrollConfiguration(
        behavior: const _PeduliScrollBehavior(),
        child: FocusTraversalGroup(
          policy: ReadingOrderTraversalPolicy(),
          child: Semantics(
            container: true,
            label: label,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _PeduliScrollBehavior extends MaterialScrollBehavior {
  const _PeduliScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  Widget buildScrollbar(
  BuildContext context,
  Widget child,
  ScrollableDetails details,
  ) {
    return child;
  }
}
