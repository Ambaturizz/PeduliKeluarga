import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../animations/app_motion.dart';
import '../constants/app_constants.dart';

final class RouteTransitions {
  const RouteTransitions._();

  static CustomTransitionPage<void> fade({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: key,
      transitionDuration: AppConstants.shortAnimationDuration,
      reverseTransitionDuration: AppConstants.shortAnimationDuration,
      child: RepaintBoundary(child: child),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: AppMotion.standard,
          reverseCurve: AppMotion.exit,
        );
        return FadeTransition(opacity: curved, child: child);
      },
    );
  }

  static CustomTransitionPage<void> slideFade({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: key,
      transitionDuration: AppConstants.mediumAnimationDuration,
      reverseTransitionDuration: AppConstants.shortAnimationDuration,
      child: RepaintBoundary(child: child),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return AppFadeSlideTransition(
          animation: animation,
          beginOffset: const Offset(0.035, 0),
          child: child,
        );
      },
    );
  }
}
