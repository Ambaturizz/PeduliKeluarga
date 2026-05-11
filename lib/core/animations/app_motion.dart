import 'package:flutter/material.dart';

final class AppMotion {
  const AppMotion._();

  static const Duration instant = Duration(milliseconds: 90);
  static const Duration fast = Duration(milliseconds: 160);
  static const Duration normal = Duration(milliseconds: 260);
  static const Duration slow = Duration(milliseconds: 420);

  static const Curve standard = Curves.easeOutCubic;
  static const Curve emphasized = Curves.easeOutQuart;
  static const Curve exit = Curves.easeInCubic;
}

class AppFadeSlideTransition extends StatelessWidget {
  const AppFadeSlideTransition({
    required this.animation,
    required this.child,
    this.beginOffset = const Offset(0, 0.025),
    super.key,
  });

  final Animation<double> animation;
  final Offset beginOffset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: AppMotion.standard,
      reverseCurve: AppMotion.exit,
    );

    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: beginOffset,
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}

class AppAnimatedEntrance extends StatelessWidget {
  const AppAnimatedEntrance({
    required this.child,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 12),
    super.key,
  });

  final Widget child;
  final Duration delay;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (reduceMotion) return child;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: delay + AppMotion.normal,
      curve: AppMotion.standard,
      builder: (context, value, child) {
        final delayedValue = delay == Duration.zero
            ? value
            : Curves.easeOut.transform(
                ((value * (delay + AppMotion.normal).inMilliseconds - delay.inMilliseconds) /
                        AppMotion.normal.inMilliseconds)
                    .clamp(0, 1)
                    .toDouble(),
              );

        return Opacity(
          opacity: delayedValue,
          child: Transform.translate(
            offset: Offset(
              offset.dx * (1 - delayedValue),
              offset.dy * (1 - delayedValue),
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class AppStaggeredList extends StatelessWidget {
  const AppStaggeredList({
    required this.children,
    this.spacing = 12,
    this.delayStep = const Duration(milliseconds: 34),
    super.key,
  });

  final List<Widget> children;
  final double spacing;
  final Duration delayStep;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(children.length, (index) {
        return Padding(
          padding: EdgeInsets.only(bottom: index == children.length - 1 ? 0 : spacing),
          child: AppAnimatedEntrance(
            delay: delayStep * index,
            child: children[index],
          ),
        );
      }),
    );
  }
}

class AppPressable extends StatefulWidget {
  const AppPressable({
    required this.child,
    this.onTap,
    this.semanticLabel,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  State<AppPressable> createState() => _AppPressableState();
}

class _AppPressableState extends State<AppPressable> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final content = Semantics(
      button: widget.onTap != null,
      label: widget.semanticLabel,
      child: AnimatedScale(
        scale: _pressed && !reduceMotion ? 0.985 : 1,
        duration: AppMotion.fast,
        curve: AppMotion.standard,
        child: widget.child,
      ),
    );

    if (widget.onTap == null) return content;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: content,
    );
  }
}
