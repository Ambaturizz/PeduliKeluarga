import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/pk_design.dart';
import '../../../../core/utils/responsive.dart';
import '../../../caregiver_profile/domain/caregiver_profile.dart';
import '../../../caregiver_profile/providers/caregiver_profile_provider.dart';
import '../../../elder_profile/domain/elder_profile.dart';
import '../../../elder_profile/providers/elder_profile_provider.dart';

class FamilyManagementPage extends ConsumerWidget {
  const FamilyManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final elder = ref.watch(elderProfileProvider);
    final caregiver = ref.watch(caregiverProfileProvider);

    return PkGradientBackground(
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: context.horizontalPagePadding,
            vertical: PkSpacing.xxl,
          ),
          child: ResponsiveCenter(
            maxWidth: 860,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────────────────────
                _PageHeader(),
                const SizedBox(height: PkSpacing.xl),

                // ── Connection Status ────────────────────────────
                _ConnectionStatusCard(elder: elder, caregiver: caregiver),
                const SizedBox(height: PkSpacing.lg),

                // ── Lansia Card ──────────────────────────────────
                _SectionLabel(
                  icon: Icons.elderly_rounded,
                  label: 'Data Lansia',
                  tone: PkTone.brand,
                ),
                const SizedBox(height: PkSpacing.sm),
                _ElderCard(elder: elder),
                const SizedBox(height: PkSpacing.lg),

                // ── Anak / Pendamping Card ───────────────────────
                _SectionLabel(
                  icon: Icons.groups_outlined,
                  label: 'Data Anak / Pendamping',
                  tone: PkTone.blue,
                ),
                const SizedBox(height: PkSpacing.sm),
                _CaregiverCard(caregiver: caregiver),
                const SizedBox(height: PkSpacing.lg),

                // ── Quick Actions ────────────────────────────────
                _QuickActionsCard(
                  onEditProfile: () => context.go(AppRoutes.profilePath),
                ),
                const SizedBox(height: PkSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Header ────────────────────────────────────────────────────

class _PageHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const PkIconBox(
          icon: Icons.family_restroom_rounded,
          tone: PkTone.brand,
          size: 48,
        ),
        const SizedBox(width: PkSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manajemen Keluarga',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: PkColors.text,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
              ),
              Text(
                'Kelola profil lansia dan anak/pendamping Anda.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: PkColors.text2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Connection Status ──────────────────────────────────────────

class _ConnectionStatusCard extends StatelessWidget {
  const _ConnectionStatusCard({
    required this.elder,
    required this.caregiver,
  });
  final ElderProfile elder;
  final CaregiverProfile caregiver;

  @override
  Widget build(BuildContext context) {
    final isConnected =
        elder.name.isNotEmpty && caregiver.name.isNotEmpty;

    return PkCard(
      tint: isConnected ? PkColors.brandSoft : PkColors.amberSoft,
      borderColor: isConnected
          ? PkColors.brand.withValues(alpha: 0.2)
          : PkColors.amber.withValues(alpha: 0.3),
      child: Row(
        children: [
          Icon(
            isConnected
                ? Icons.link_rounded
                : Icons.link_off_rounded,
            color: isConnected ? PkColors.brand : PkColors.amber,
            size: 28,
          ),
          const SizedBox(width: PkSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isConnected ? 'Keluarga Terhubung' : 'Profil Belum Lengkap',
                  style:
                      Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: isConnected
                                ? PkColors.brand
                                : PkColors.amber,
                            fontWeight: FontWeight.w800,
                          ),
                ),
                Text(
                  isConnected
                      ? '${elder.displayName} ↔ ${caregiver.displayName} telah saling terhubung.'
                      : 'Lengkapi profil lansia dan anak/pendamping agar fitur PeduliKeluarga berjalan optimal.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isConnected ? PkColors.brand : PkColors.amber,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Label ──────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.icon,
    required this.label,
    required this.tone,
  });
  final IconData icon;
  final String label;
  final PkTone tone;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: PkColors.brand),
        const SizedBox(width: PkSpacing.sm),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: PkColors.text,
                fontWeight: FontWeight.w900,
              ),
        ),
      ],
    );
  }
}

// ─── Elder Card ─────────────────────────────────────────────────

class _ElderCard extends StatelessWidget {
  const _ElderCard({required this.elder});
  final ElderProfile elder;

  @override
  Widget build(BuildContext context) {
    final hasData = elder.name.isNotEmpty;

    return PkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundImage:
                    const AssetImage('assets/icons/profillansia.webp'),
              ),
              const SizedBox(width: PkSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasData ? elder.displayName : 'Belum diisi',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: PkColors.text,
                                fontWeight: FontWeight.w900,
                              ),
                    ),
                    Text(
                      hasData
                          ? '${elder.displayAge} • ${elder.displayGender}'
                          : 'Lengkapi profil lansia',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: PkColors.text2),
                    ),
                  ],
                ),
              ),
              if (hasData)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: PkColors.brandSoft,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'PeduliDiri',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: PkColors.brand,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
            ],
          ),
          if (hasData) ...[
            const SizedBox(height: PkSpacing.lg),
            const Divider(),
            const SizedBox(height: PkSpacing.sm),
            _InfoRow(
                icon: Icons.phone_outlined,
                label: 'Nomor HP',
                value: elder.displayPhone),
            _InfoRow(
                icon: Icons.home_outlined,
                label: 'Alamat',
                value: elder.displayAddress),
            if (elder.medicalHistory.isNotEmpty)
              _InfoRow(
                icon: Icons.medical_information_outlined,
                label: 'Riwayat Penyakit',
                value: elder.medicalHistory.join(', '),
              ),
          ],
        ],
      ),
    );
  }
}

// ─── Caregiver Card ─────────────────────────────────────────────

class _CaregiverCard extends StatelessWidget {
  const _CaregiverCard({required this.caregiver});
  final CaregiverProfile caregiver;

  @override
  Widget build(BuildContext context) {
    final hasData = caregiver.name.isNotEmpty;

    return PkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundImage:
                    const AssetImage('assets/icons/profilanak.webp'),
              ),
              const SizedBox(width: PkSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasData ? caregiver.displayName : 'Belum diisi',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: PkColors.text,
                                fontWeight: FontWeight.w900,
                              ),
                    ),
                    Text(
                      hasData
                          ? '${caregiver.displayRelationship} • ${caregiver.displayAddress}'
                          : 'Lengkapi profil anak/pendamping',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: PkColors.text2),
                    ),
                  ],
                ),
              ),
              if (hasData)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: PkColors.blueSoft,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'PeduliPenuh',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: PkColors.blue,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
            ],
          ),
          if (hasData) ...[
            const SizedBox(height: PkSpacing.lg),
            const Divider(),
            const SizedBox(height: PkSpacing.sm),
            _InfoRow(
                icon: Icons.phone_outlined,
                label: 'Nomor HP',
                value: caregiver.displayPhone),
            _InfoRow(
                icon: Icons.home_outlined,
                label: 'Alamat',
                value: caregiver.displayAddress),
            _InfoRow(
                icon: Icons.family_restroom_rounded,
                label: 'Hubungan',
                value: caregiver.displayRelationship),
          ],
        ],
      ),
    );
  }
}

// ─── Quick Actions Card ─────────────────────────────────────────

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard({required this.onEditProfile});
  final VoidCallback onEditProfile;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aksi Cepat',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: PkColors.text,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: PkSpacing.md),
          _ActionTile(
            icon: Icons.edit_note_rounded,
            title: 'Edit Profil Keluarga',
            subtitle: 'Perbarui data lansia dan anak/pendamping',
            tone: PkTone.brand,
            onTap: onEditProfile,
          ),
          const SizedBox(height: PkSpacing.sm),
          _ActionTile(
            icon: Icons.qr_code_scanner_rounded,
            title: 'Hubungkan Perangkat',
            subtitle: 'Scan kode QR untuk menghubungkan akun',
            tone: PkTone.blue,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur koneksi perangkat akan segera hadir.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          const SizedBox(height: PkSpacing.sm),
          _ActionTile(
            icon: Icons.share_outlined,
            title: 'Bagikan Kode Koneksi',
            subtitle: 'Kirim kode ke anggota keluarga lain',
            tone: PkTone.green,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur berbagi kode akan segera hadir.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─── Shared Widgets ─────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: PkColors.muted),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: PkColors.text2,
                  fontWeight: FontWeight.w600,
                ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: PkColors.text,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tone,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final PkTone tone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(PkRadius.sm),
      child: Padding(
        padding: const EdgeInsets.all(PkSpacing.sm),
        child: Row(
          children: [
            PkIconBox(icon: icon, tone: tone),
            const SizedBox(width: PkSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: PkColors.text,
                          fontWeight: FontWeight.w700,
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
            const Icon(Icons.chevron_right_rounded, color: PkColors.muted),
          ],
        ),
      ),
    );
  }
}
