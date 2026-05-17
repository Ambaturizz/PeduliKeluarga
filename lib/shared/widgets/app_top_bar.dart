import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/routing/navigation_helper.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../state/providers/app_mode_provider.dart';
import 'app_logo.dart';

class AppTopBar extends ConsumerWidget implements PreferredSizeWidget {
  const AppTopBar({
    this.showMenuButton = false,
    super.key,
  });

  final bool showMenuButton;

  @override
  Size get preferredSize => const Size.fromHeight(74);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(appModeControllerProvider);

    return AppBar(
      automaticallyImplyLeading: showMenuButton,
      titleSpacing: AppSpacing.lg,
      title: Row(
        children: [
          const AppLogo(size: 120),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              'PeduliKeluarga',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.teal,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.4,
                  ),
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: _ModeSwitcher(
            mode: mode,
            onChanged: (newMode) {
              ref.read(appModeControllerProvider.notifier).setMode(newMode);
              context.goInitialForMode(newMode);
            },
          ),
        ),
        IconButton(
          tooltip: 'Notifikasi',
          onPressed: context.goNotifications,
          icon: const Icon(Icons.notifications_outlined),
        ),
        IconButton(
          tooltip: 'Profil',
          onPressed: context.goProfile,
          icon: const Icon(Icons.account_circle_outlined),
        ),
        const SizedBox(width: AppSpacing.xs),
      ],
    );
  }
}

class _ModeSwitcher extends StatelessWidget {
  const _ModeSwitcher({
    required this.mode,
    required this.onChanged,
  });

  final AppUserMode mode;
  final ValueChanged<AppUserMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<AppUserMode>(
      showSelectedIcon: false,
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        ),
      ),
      segments: const [
        ButtonSegment<AppUserMode>(
          value: AppUserMode.elder,
          label: Text('Lansia'),
          icon: Icon(Icons.volunteer_activism_outlined),
        ),
        ButtonSegment<AppUserMode>(
          value: AppUserMode.caregiver,
          label: Text('Anak'),
          icon: Icon(Icons.groups_outlined),
        ),
      ],
      selected: {mode},
      onSelectionChanged: (selection) {
        if (selection.isEmpty) return;
        onChanged(selection.first);
      },
    );
  }
}
