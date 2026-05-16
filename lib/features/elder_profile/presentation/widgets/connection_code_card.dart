import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/theme/pk_design.dart';
import '../../domain/elder_profile.dart';

class ConnectionCodeCard extends StatelessWidget {
  const ConnectionCodeCard({
    required this.profile,
    this.compact = false,
    super.key,
  });

  final ElderProfile profile;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      soft: true,
      padding: const EdgeInsets.all(PkSpacing.lg),
      borderColor: PkColors.brand.withValues(alpha: 0.18),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final narrow = compact || constraints.maxWidth < 560;
          final qr = _QrBox(profile: profile);
          final content = _CodeContent(profile: profile);

          if (narrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                content,
                const SizedBox(height: PkSpacing.lg),
                Center(child: qr),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: content),
              const SizedBox(width: PkSpacing.xl),
              qr,
            ],
          );
        },
      ),
    );
  }
}

class _CodeContent extends StatelessWidget {
  const _CodeContent({required this.profile});

  final ElderProfile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CardTitleRow(
          eyebrow: 'Hubungkan Keluarga',
          title: 'Kode keluarga siap dibagikan',
          subtitle: 'Berikan kode ini kepada anak atau pendamping agar mereka bisa terhubung.',
          icon: Icons.family_restroom_rounded,
          tone: PkTone.brand,
        ),
        const SizedBox(height: PkSpacing.lg),
        SelectableText(
          profile.connectionCode,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: PkColors.brand,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.8,
              ),
        ),
        const SizedBox(height: PkSpacing.md),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: profile.connectionCode));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kode keluarga berhasil disalin.')),
              );
            },
            icon: const Icon(Icons.copy_rounded),
            label: const Text('Salin Kode'),
          ),
        ),
      ],
    );
  }
}

class _QrBox extends StatelessWidget {
  const _QrBox({required this.profile});

  final ElderProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 168,
      padding: const EdgeInsets.all(PkSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: PkRadius.mdRadius,
        border: Border.all(color: PkColors.lineStrong),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          QrImageView(
            data: profile.qrPayload,
            version: QrVersions.auto,
            size: 132,
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: PkSpacing.sm),
          Text(
            'QR Keluarga',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: PkColors.text2,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class CardTitleRow extends StatelessWidget {
  const CardTitleRow({
    required this.eyebrow,
    required this.title,
    required this.icon,
    required this.tone,
    this.subtitle,
    super.key,
  });

  final String eyebrow;
  final String title;
  final String? subtitle;
  final IconData icon;
  final PkTone tone;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PkIconBox(icon: icon, tone: tone),
        const SizedBox(width: PkSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: pkToneColor(tone),
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: PkSpacing.xs),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: PkColors.text,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: PkSpacing.xs),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: PkColors.text2,
                        height: 1.5,
                      ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
