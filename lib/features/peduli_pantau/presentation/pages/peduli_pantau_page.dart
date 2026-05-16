import 'package:flutter/material.dart';

import '../../../../core/theme/pk_design.dart';

class PeduliPantauPage extends StatelessWidget {
  const PeduliPantauPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PkGradientBackground(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              _horizontalPadding(context),
              26,
              _horizontalPadding(context),
              72,
            ),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _PantauHero(),
                      const SizedBox(height: 18),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final compact = constraints.maxWidth < 860;

                          final camera = const _CctvMockFrame();
                          final status = const _PantauStatusPanel();

                          if (compact) {
                            return const Column(
                              children: [
                                _CctvMockFrame(),
                                SizedBox(height: 16),
                                _PantauStatusPanel(),
                              ],
                            );
                          }

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 3, child: camera),
                              const SizedBox(width: 16),
                              Expanded(child: status),
                            ],
                          );
                        },
                      ),
                      const PkSectionTitle(
                        title: 'Kamera Rumah',
                        subtitle: 'Mockup koneksi CCTV',
                      ),
                      const _CameraGrid(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 640) return 16;
    if (width < 920) return 20;
    return 24;
  }
}

class _PantauHero extends StatelessWidget {
  const _PantauHero();

  @override
  Widget build(BuildContext context) {
    return PkCard(
      tint: PkColors.brand,
      borderColor: Colors.white.withValues(alpha: 0.12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PkBadge(
            label: 'PeduliPantau',
            tone: PkTone.brand,
            icon: Icons.videocam_outlined,
          ),
          const SizedBox(height: 14),
          Text(
            'Pantau kondisi rumah lansia dari aplikasi anak.',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.2,
                  height: 1.1,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'Ini mockup kamera CCTV. Pada versi produksi, halaman ini bisa dihubungkan ke perangkat kamera rumah menggunakan sistem autentikasi dan izin keluarga.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.78),
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }
}

class _CctvMockFrame extends StatelessWidget {
  const _CctvMockFrame();

  @override
  Widget build(BuildContext context) {
    return PkCard(
      padding: EdgeInsets.zero,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF071513),
                    Color(0xFF123B36),
                    Color(0xFF071513),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: _CctvGridPainter(),
              ),
            ),
            Positioned(
              top: 18,
              left: 18,
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: PkColors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'LIVE · Ruang Tamu',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 18,
              top: 18,
              child: Text(
                _dateLabel(DateTime.now()),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
            Center(
              child: Container(
                width: 118,
                height: 118,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                ),
                child: const Icon(
                  Icons.videocam_outlined,
                  color: Colors.white,
                  size: 54,
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: Row(
                children: [
                  _CameraControl(icon: Icons.volume_up_outlined, label: 'Audio'),
                  const SizedBox(width: 10),
                  _CameraControl(icon: Icons.fullscreen_rounded, label: 'Layar penuh'),
                  const Spacer(),
                  _CameraControl(icon: Icons.motion_photos_on_outlined, label: 'Gerak: aman'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _dateLabel(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute WIB';
  }
}

class _CameraControl extends StatelessWidget {
  const _CameraControl({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.34),
        borderRadius: PkRadius.pillRadius,
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class _PantauStatusPanel extends StatelessWidget {
  const _PantauStatusPanel();

  @override
  Widget build(BuildContext context) {
    return PkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PkBadge(
            label: 'Mockup aktif',
            tone: PkTone.green,
            icon: Icons.check_circle_outline_rounded,
          ),
          const SizedBox(height: 14),
          Text(
            'Status CCTV',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: PkColors.text,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 14),
          const _StatusRow(label: 'Koneksi', value: 'Online', icon: Icons.wifi_rounded, tone: PkTone.green),
          const _StatusRow(label: 'Kamera', value: 'Ruang Tamu', icon: Icons.meeting_room_outlined, tone: PkTone.brand),
          const _StatusRow(label: 'Deteksi gerak', value: 'Tidak ada anomali', icon: Icons.sensors_outlined, tone: PkTone.blue),
          const _StatusRow(label: 'Privasi', value: 'Akses anak disetujui', icon: Icons.lock_outline_rounded, tone: PkTone.purple),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mockup: koneksi kamera rumah berhasil dimuat.')),
              );
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Refresh CCTV'),
          ),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.tone,
  });

  final String label;
  final String value;
  final IconData icon;
  final PkTone tone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          PkIconBox(icon: icon, tone: tone, size: 38, iconSize: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: PkColors.text2,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: pkToneColor(tone),
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class _CameraGrid extends StatelessWidget {
  const _CameraGrid();

  @override
  Widget build(BuildContext context) {
    const cameras = [
      ('Ruang Tamu', 'Online', Icons.meeting_room_outlined, PkTone.green),
      ('Dapur', 'Standby', Icons.restaurant_outlined, PkTone.amber),
      ('Teras', 'Online', Icons.home_outlined, PkTone.green),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final count = constraints.maxWidth >= 900
            ? 3
            : constraints.maxWidth >= 560
                ? 2
                : 1;

        return GridView.count(
          crossAxisCount: count,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: count == 1 ? 3.1 : 2.1,
          children: [
            for (final camera in cameras)
              PkCard(
                clean: true,
                child: Row(
                  children: [
                    PkIconBox(icon: camera.$3, tone: camera.$4, size: 46),
                    const SizedBox(width: PkSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            camera.$1,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: PkColors.text,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'CCTV ${camera.$2.toLowerCase()} · mockup',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: PkColors.text2),
                          ),
                        ],
                      ),
                    ),
                    PkBadge(label: camera.$2, tone: camera.$4),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CctvGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1;

    const gap = 46.0;

    for (double x = 0; x <= size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y <= size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
