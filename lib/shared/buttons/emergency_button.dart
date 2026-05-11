import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';

class EmergencyButton extends StatelessWidget {
  const EmergencyButton({
    required this.title,
    required this.subtitle,
    required this.onPressed,
    this.icon = Icons.emergency_outlined,
    this.isTriggered = false,
    super.key,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onPressed;
  final IconData icon;
  final bool isTriggered;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isTriggered ? AppColors.tealMid : AppColors.redMid;

    return Semantics(
      button: true,
      liveRegion: true,
      label: '$title. $subtitle',
      child: SizedBox(
        width: double.infinity,
        child: Material(
          color: backgroundColor,
          borderRadius: AppRadius.medium,
          child: InkWell(
            onTap: onPressed,
            borderRadius: AppRadius.medium,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                children: [
                  Icon(
                    icon,
                    size: 40,
                    color: AppColors.white,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.white.withValues(alpha: 0.78),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}