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
                          final compact = constraints.maxWidth < 900;

                          if (compact) {
                            return const Column(
                              children: [
                                _CctvMultiViewPanel(),
                                SizedBox(height: 16),
                                _PantauStatusPanel(),
                              ],
                            );
                          }

                          return const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: _CctvMultiViewPanel(),
                              ),
                              SizedBox(width: 16),
                              Expanded(child: _PantauStatusPanel()),
                            ],
                          );
                        },
                      ),
                      const PkSectionTitle(
                        title: 'Kamera Rumah',
                        subtitle: '4 area CCTV mockup',
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

class _CctvCamera {
  const _CctvCamera({
    required this.roomName,
    required this.status,
    required this.icon,
    required this.tone,
    this.isLive = true,
  });

  final String roomName;
  final String status;
  final IconData icon;
  final PkTone tone;
  final bool isLive;
}

const _cctvCameras = [
  _CctvCamera(
    roomName: 'Ruang Tamu',
    status: 'Online',
    icon: Icons.meeting_room_outlined,
    tone: PkTone.green,
  ),
  _CctvCamera(
    roomName: 'Ruang Makan',
    status: 'Online',
    icon: Icons.restaurant_outlined,
    tone: PkTone.green,
  ),
  _CctvCamera(
    roomName: 'Dapur',
    status: 'Standby',
    icon: Icons.kitchen_outlined,
    tone: PkTone.amber,
    isLive: false,
  ),
  _CctvCamera(
    roomName: 'Teras',
    status: 'Online',
    icon: Icons.home_outlined,
    tone: PkTone.green,
  ),
];

class _CctvMultiViewPanel extends StatelessWidget {
  const _CctvMultiViewPanel();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final singleColumn = constraints.maxWidth < 520;
        final crossAxisCount = singleColumn ? 1 : 2;

        return GridView.builder(
          itemCount: _cctvCameras.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 16 / 9,
          ),
          itemBuilder: (context, index) {
            return _CctvMockFrame(camera: _cctvCameras[index]);
          },
        );
      },
    );
  }
}

class _CctvMockFrame extends StatelessWidget {
  const _CctvMockFrame({
    required this.camera,
  });

  final _CctvCamera camera;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: PkRadius.mdRadius,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 360;
            final centerSize = compact ? 58.0 : 86.0;
            final iconSize = compact ? 28.0 : 42.0;

            return Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: camera.isLive
                            ? const [
                                Color(0xFF071513),
                                Color(0xFF123B36),
                                Color(0xFF071513),
                              ]
                            : const [
                                Color(0xFF19150B),
                                Color(0xFF4A3511),
                                Color(0xFF11100A),
                              ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: CustomPaint(
                    painter: _CctvGridPainter(),
                  ),
                ),
                Positioned(
                  top: compact ? 10 : 14,
                  left: compact ? 10 : 14,
                  right: compact ? 10 : 14,
                  child: Row(
                    children: [
                      Container(
                        width: compact ? 8 : 9,
                        height: compact ? 8 : 9,
                        decoration: BoxDecoration(
                          color: camera.isLive ? PkColors.red : PkColors.amber,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${camera.isLive ? 'LIVE' : 'STANDBY'} · ${camera.roomName}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                      ),
                      if (!compact)
                        Text(
                          _timeLabel(DateTime.now()),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.white70,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                    ],
                  ),
                ),
                Center(
                  child: Container(
                    width: centerSize,
                    height: centerSize,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Icon(
                      camera.icon,
                      color: Colors.white,
                      size: iconSize,
                    ),
                  ),
                ),
                Positioned(
                  left: compact ? 10 : 14,
                  right: compact ? 10 : 14,
                  bottom: compact ? 10 : 14,
                  child: compact
                      ? Row(
                          children: [
                            _CameraControl(
                              icon: camera.isLive
                                  ? Icons.motion_photos_on_outlined
                                  : Icons.pause_circle_outline_rounded,
                              label: camera.isLive ? 'Aman' : 'Standby',
                            ),
                            const Spacer(),
                            PkBadge(label: camera.status, tone: camera.tone),
                          ],
                        )
                      : Row(
                          children: [
                            const _CameraControl(icon: Icons.volume_up_outlined, label: 'Audio'),
                            const SizedBox(width: 8),
                            const _CameraControl(icon: Icons.fullscreen_rounded, label: 'Layar penuh'),
                            const Spacer(),
                            _CameraControl(
                              icon: camera.isLive
                                  ? Icons.motion_photos_on_outlined
                                  : Icons.pause_circle_outline_rounded,
                              label: camera.isLive ? 'Gerak: aman' : 'Mode standby',
                            ),
                          ],
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static String _timeLabel(DateTime value) {
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
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.34),
        borderRadius: PkRadius.pillRadius,
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.white),
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
          const _StatusRow(
            label: 'Koneksi',
            value: 'Online',
            icon: Icons.wifi_rounded,
            tone: PkTone.green,
          ),
          const _StatusRow(
            label: 'Kamera aktif',
            value: '4 area',
            icon: Icons.grid_view_rounded,
            tone: PkTone.brand,
          ),
          const _StatusRow(
            label: 'Deteksi gerak',
            value: 'Tidak ada anomali',
            icon: Icons.sensors_outlined,
            tone: PkTone.blue,
          ),
          const _StatusRow(
            label: 'Privasi',
            value: 'Akses anak disetujui',
            icon: Icons.lock_outline_rounded,
            tone: PkTone.purple,
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Mockup: semua kamera rumah berhasil dimuat.')),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = constraints.maxWidth >= 900
            ? 4
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
            for (final camera in _cctvCameras)
              PkCard(
                clean: true,
                child: Row(
                  children: [
                    PkIconBox(icon: camera.icon, tone: camera.tone, size: 46),
                    const SizedBox(width: PkSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            camera.roomName,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: PkColors.text,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'CCTV ${camera.status.toLowerCase()} · mockup',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: PkColors.text2),
                          ),
                        ],
                      ),
                    ),
                    PkBadge(label: camera.status, tone: camera.tone),
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
