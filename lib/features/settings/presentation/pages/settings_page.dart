import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/pk_design.dart';
import '../../../../shared/cards/app_card.dart';
import '../../../../shared/layouts/page_shell.dart';
import '../../../../state/providers/theme_mode_provider.dart';
import '../../../authentication/providers/auth_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _notifObat = true;
  bool _notifDarurat = true;
  bool _notifCek = false;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeControllerProvider);

    return PageShell(
      title: 'Pengaturan',
      subtitle: 'Preferensi aplikasi PeduliKeluarga.',
      icon: Icons.settings_outlined,
      children: [
        // ── Tampilan ────────────────────────────────────────────
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionTitle('Tampilan'),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: SegmentedButton<ThemeMode>(
                  style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text('Sistem'),
                      icon: Icon(Icons.brightness_auto_outlined),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text('Terang'),
                      icon: Icon(Icons.light_mode_outlined),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text('Gelap'),
                      icon: Icon(Icons.dark_mode_outlined),
                    ),
                  ],
                  selected: {themeMode},
                  onSelectionChanged: (selection) {
                    ref
                        .read(themeModeControllerProvider.notifier)
                        .setThemeMode(selection.first);
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // ── Notifikasi ──────────────────────────────────────────
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionTitle('Notifikasi'),
              const SizedBox(height: AppSpacing.sm),
              _ToggleTile(
                icon: Icons.medication_rounded,
                title: 'Pengingat Obat',
                subtitle: 'Notifikasi jadwal minum obat lansia',
                value: _notifObat,
                onChanged: (v) => setState(() => _notifObat = v),
              ),
              _ToggleTile(
                icon: Icons.emergency_rounded,
                title: 'PeduliDarurat',
                subtitle: 'Notifikasi saat tombol darurat ditekan',
                value: _notifDarurat,
                onChanged: (v) => setState(() => _notifDarurat = v),
              ),
              _ToggleTile(
                icon: Icons.health_and_safety_outlined,
                title: 'Pengingat PeduliCek',
                subtitle: 'Notifikasi rutin cek kesehatan harian',
                value: _notifCek,
                onChanged: (v) => setState(() => _notifCek = v),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // ── Akun ────────────────────────────────────────────────
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionTitle('Akun'),
              const SizedBox(height: AppSpacing.sm),
              _MenuTile(
                icon: Icons.lock_outline_rounded,
                title: 'Ubah Password',
                subtitle: 'Ganti kata sandi akun Anda',
                onTap: () => _showComingSoon(context, 'Ubah Password'),
              ),
              _MenuTile(
                icon: Icons.family_restroom_rounded,
                title: 'Manajemen Keluarga',
                subtitle: 'Kelola anggota keluarga yang terhubung',
                onTap: () => context.go(AppRoutes.familyManagementPath),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // ── Tentang Aplikasi ────────────────────────────────────
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionTitle('Tentang Aplikasi'),
              const SizedBox(height: AppSpacing.sm),
              _MenuTile(
                icon: Icons.info_outline_rounded,
                title: 'Tentang PeduliKeluarga',
                subtitle: 'Versi 1.0.0 • Dibuat untuk lansia Indonesia',
                onTap: () => _showAbout(context),
              ),
              _MenuTile(
                icon: Icons.description_outlined,
                title: 'Syarat dan Ketentuan',
                subtitle: 'Baca kebijakan penggunaan aplikasi',
                onTap: () => context.go(AppRoutes.termsConditionsPath),
              ),
              _MenuTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Kebijakan Privasi',
                subtitle: 'Baca kebijakan perlindungan data',
                onTap: () => context.go(AppRoutes.privacyPolicyPath),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // ── Logout ──────────────────────────────────────────────
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _confirmLogout(context, ref),
            icon: const Icon(Icons.logout_rounded, color: PkColors.red),
            label: const Text(
              'Keluar dari Akun',
              style: TextStyle(color: PkColors.red),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: PkColors.red),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.sm),

        Center(
          child: Text(
            'PeduliKeluarga v1.0.0 • © 2025',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: PkColors.muted,
                ),
          ),
        ),
      ],
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature akan segera hadir.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'PeduliKeluarga',
      applicationVersion: '1.0.0',
      applicationIcon: const PkIconBox(
        icon: Icons.favorite_rounded,
        tone: PkTone.brand,
        size: 48,
      ),
      children: [
        const Text(
          'Aplikasi pendamping kesehatan lansia untuk keluarga Indonesia. '
          'Dirancang untuk memudahkan pemantauan, komunikasi, dan perawatan lansia dari jarak jauh.',
        ),
      ],
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Keluar dari Akun?'),
          content: const Text(
            'Anda akan keluar dari PeduliKeluarga. Pastikan data penting sudah tersimpan.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                ref.read(authControllerProvider.notifier).logout();
              },
              style: FilledButton.styleFrom(
                backgroundColor: PkColors.red,
              ),
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }
}

// ─── Shared Widgets ─────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: PkColors.text,
            fontWeight: FontWeight.w800,
          ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: PkColors.text2),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: PkColors.text,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: PkColors.text2),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 20, color: PkColors.text2),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: PkColors.text,
                              fontWeight: FontWeight.w600,
                            ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: PkColors.text2),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                size: 18, color: PkColors.muted),
          ],
        ),
      ),
    );
  }
}
