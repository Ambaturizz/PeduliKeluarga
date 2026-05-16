import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/pk_design.dart';
import '../../../../shared/layouts/page_shell.dart';
import '../../../../state/providers/app_mode_provider.dart';
import '../../../elder_profile/providers/elder_profile_provider.dart';
import '../../providers/peduli_antar_provider.dart';

class PeduliAntarPage extends ConsumerWidget {
  const PeduliAntarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(peduliAntarProvider);
    final mode = ref.watch(appModeControllerProvider);
    final elder = ref.watch(elderProfileProvider);
    final controller = ref.read(peduliAntarProvider.notifier);
    final isCaregiver = mode == AppUserMode.caregiver;

    return PageShell(
      title: 'PeduliAntar',
      subtitle: isCaregiver
          ? 'Periksa dan konfirmasi pembelian obat untuk orang tua.'
          : 'Permintaan pembelian obat akan dikonfirmasi keluarga terlebih dahulu.',
      icon: Icons.local_shipping_outlined,
      children: [
        _PeduliAntarMapCard(
          address: elder.displayAddress,
          order: state.latestOrder,
        ),
        const SizedBox(height: PkSpacing.lg),
        if (!state.hasOrders)
          PkCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PkIconBox(icon: Icons.local_shipping_outlined, tone: PkTone.amber),
                const SizedBox(height: PkSpacing.md),
                Text(
                  'Belum ada permintaan pembelian obat.',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: PkColors.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: PkSpacing.xs),
                Text(
                  'Pesanan dari PeduliObat akan muncul di sini dan menunggu konfirmasi pendamping.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: PkColors.text2,
                        height: 1.55,
                      ),
                ),
              ],
            ),
          )
        else
          for (final order in state.orders) ...[
            _OrderCard(
              order: order,
              isCaregiver: isCaregiver,
              elderAddress: elder.displayAddress,
              onConfirm: () {
                controller.confirm(order.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pesanan dikonfirmasi. Status berubah menjadi diproses.')),
                );
              },
              onCancel: () {
                controller.cancel(order.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pesanan dibatalkan dan lansia akan mendapat notifikasi.')),
                );
              },
              onAdvance: () {
                controller.advance(order.id);
              },
            ),
            const SizedBox(height: PkSpacing.lg),
          ],
      ],
    );
  }
}

class _PeduliAntarMapCard extends ConsumerStatefulWidget {
  const _PeduliAntarMapCard({
    required this.address,
    required this.order,
  });

  final String address;
  final MedicineOrder? order;

  @override
  ConsumerState<_PeduliAntarMapCard> createState() => _PeduliAntarMapCardState();
}

class _PeduliAntarMapCardState extends ConsumerState<_PeduliAntarMapCard> {
  static final LatLng _defaultCenter = LatLng(-6.178306, 106.631889);
  static final LatLng _dummyDestination = LatLng(-6.176900, 106.634700);

  late final MapController _mapController;
  bool _mapReady = false;
  bool _hasAutoCentered = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(peduliAntarLocationProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(peduliAntarLocationProvider);
    final locationController = ref.read(peduliAntarLocationProvider.notifier);
    final userPosition = locationState.currentPosition;
    final destinationLabel = widget.order == null
        ? 'Contoh tujuan · Apotek terdekat'
        : 'Contoh tujuan · ${widget.order!.pharmacyName}';
    final initialCenter = userPosition ?? _defaultCenter;

    ref.listen<PeduliAntarLocationState>(
      peduliAntarLocationProvider,
      (previous, next) {
        if (!_mapReady || _hasAutoCentered || next.currentPosition == null) return;
        _hasAutoCentered = true;
        _moveMap(next.currentPosition!, zoom: 16);
      },
    );

    return PkCard(
      tint: PkColors.blueSoft,
      borderColor: PkColors.blue.withValues(alpha: 0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MapHeader(
            status: locationState.status,
            isTracking: locationState.isTracking,
          ),
          const SizedBox(height: PkSpacing.lg),
          ClipRRect(
            borderRadius: PkRadius.mdRadius,
            child: SizedBox(
              height: 240,
              width: double.infinity,
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: initialCenter,
                      initialZoom: userPosition == null ? 13 : 16,
                      minZoom: 5,
                      maxZoom: 18,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.drag |
                            InteractiveFlag.pinchZoom |
                            InteractiveFlag.doubleTapZoom,
                      ),
                      onMapReady: () {
                        _mapReady = true;
                        final latestPosition = ref.read(peduliAntarLocationProvider).currentPosition;
                        if (latestPosition != null && !_hasAutoCentered) {
                          _hasAutoCentered = true;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              _moveMap(latestPosition, zoom: 16);
                            }
                          });
                        }
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.pedulikeluarga.app',
                      ),
                      if (userPosition != null)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: [userPosition, _dummyDestination],
                              color: PkColors.brand.withValues(alpha: 0.78),
                              strokeWidth: 4,
                            ),
                          ],
                        ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _dummyDestination,
                            width: 166,
                            height: 58,
                            child: _MapMarkerBubble(
                              label: 'Contoh tujuan',
                              icon: Icons.local_pharmacy_outlined,
                              tone: PkTone.green,
                            ),
                          ),
                          if (userPosition != null)
                            Marker(
                              point: userPosition,
                              width: 150,
                              height: 58,
                              child: const _MapMarkerBubble(
                                label: 'Lokasi saya',
                                icon: Icons.my_location_rounded,
                                tone: PkTone.brand,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    left: PkSpacing.sm,
                    bottom: PkSpacing.sm,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: PkColors.surface.withValues(alpha: 0.92),
                        borderRadius: PkRadius.pillRadius,
                        border: Border.all(color: PkColors.line),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: Text(
                          '© OpenStreetMap contributors',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: PkColors.text2,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: PkSpacing.md),
          _LocationStatusPanel(
            state: locationState,
            onAllowLocation: locationController.requestLocationPermission,
            onOpenAppSettings: locationController.openAppSettings,
            onOpenLocationSettings: locationController.openLocationSettings,
            onRefresh: locationController.refreshPermissionStatus,
          ),
          const SizedBox(height: PkSpacing.md),
          Wrap(
            spacing: PkSpacing.sm,
            runSpacing: PkSpacing.sm,
            children: [
              FilledButton.icon(
                onPressed: () => _centerToUser(locationState),
                icon: const Icon(Icons.my_location_rounded),
                label: const Text('Gunakan Lokasi Saya'),
              ),
              OutlinedButton.icon(
                onPressed: () => _moveMap(_dummyDestination, zoom: 15),
                icon: const Icon(Icons.local_pharmacy_outlined),
                label: const Text('Lihat Contoh Tujuan'),
              ),
            ],
          ),
          const SizedBox(height: PkSpacing.md),
          _InfoRow(icon: Icons.home_outlined, label: 'Alamat tujuan', value: widget.address),
          _InfoRow(
            icon: Icons.place_outlined,
            label: 'Marker tujuan',
            value: '$destinationLabel. Marker ini hanya dummy untuk testing tampilan sebelum data lokasi tujuan dari backend tersedia.',
          ),
        ],
      ),
    );
  }

  void _centerToUser(PeduliAntarLocationState state) {
    final position = state.currentPosition;
    if (position == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lokasi belum tersedia. Izinkan lokasi atau aktifkan GPS terlebih dahulu.')),
      );
      return;
    }

    _moveMap(position, zoom: 16);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Peta diarahkan ke lokasi Anda.')),
    );
  }

  void _moveMap(LatLng point, {required double zoom}) {
    if (!_mapReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Peta masih dimuat. Coba lagi sebentar.')),
      );
      return;
    }

    _mapController.move(point, zoom);
  }
}

class _MapHeader extends StatelessWidget {
  const _MapHeader({
    required this.status,
    required this.isTracking,
  });

  final PeduliAntarLocationStatus status;
  final bool isTracking;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const PkIconBox(icon: Icons.map_outlined, tone: PkTone.blue),
        const SizedBox(width: PkSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Peta pengantaran',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: PkColors.text,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              Text(
                'Map OpenStreetMap tanpa API key dengan marker lokasi realtime.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: PkColors.text2),
              ),
            ],
          ),
        ),
        const SizedBox(width: PkSpacing.sm),
        PkBadge(
          label: isTracking ? 'Realtime' : status.label,
          tone: status.tone,
          icon: isTracking ? Icons.sensors_rounded : status.icon,
        ),
      ],
    );
  }
}

class _LocationStatusPanel extends StatelessWidget {
  const _LocationStatusPanel({
    required this.state,
    required this.onAllowLocation,
    required this.onOpenAppSettings,
    required this.onOpenLocationSettings,
    required this.onRefresh,
  });

  final PeduliAntarLocationState state;
  final VoidCallback onAllowLocation;
  final VoidCallback onOpenAppSettings;
  final VoidCallback onOpenLocationSettings;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final status = state.status;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(PkSpacing.md),
      decoration: BoxDecoration(
        color: PkColors.surface.withValues(alpha: 0.9),
        borderRadius: PkRadius.smRadius,
        border: Border.all(color: PkColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (status == PeduliAntarLocationStatus.loading)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Icon(status.icon, size: 20, color: pkToneColor(status.tone)),
              const SizedBox(width: PkSpacing.sm),
              Expanded(
                child: Text(
                  'Status lokasi: ${status.label}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: PkColors.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: PkSpacing.xs),
          Text(
            state.message ?? status.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: PkColors.text2,
                  height: 1.45,
                ),
          ),
          if (state.currentPosition != null) ...[
            const SizedBox(height: PkSpacing.xs),
            Text(
              'Koordinat: ${state.currentPosition!.latitude.toStringAsFixed(6)}, ${state.currentPosition!.longitude.toStringAsFixed(6)}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: PkColors.muted,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
          if (status == PeduliAntarLocationStatus.denied ||
              status == PeduliAntarLocationStatus.deniedForever ||
              status == PeduliAntarLocationStatus.serviceDisabled ||
              status == PeduliAntarLocationStatus.error) ...[
            const SizedBox(height: PkSpacing.md),
            Wrap(
              spacing: PkSpacing.sm,
              runSpacing: PkSpacing.sm,
              children: [
                if (status == PeduliAntarLocationStatus.denied)
                  FilledButton.icon(
                    onPressed: onAllowLocation,
                    icon: const Icon(Icons.location_on_outlined),
                    label: const Text('Izinkan Lokasi'),
                  ),
                if (status == PeduliAntarLocationStatus.deniedForever)
                  FilledButton.icon(
                    onPressed: onOpenAppSettings,
                    icon: const Icon(Icons.settings_outlined),
                    label: const Text('Buka Pengaturan Aplikasi'),
                  ),
                if (status == PeduliAntarLocationStatus.serviceDisabled)
                  FilledButton.icon(
                    onPressed: onOpenLocationSettings,
                    icon: const Icon(Icons.gps_off_outlined),
                    label: const Text('Buka Pengaturan Lokasi'),
                  ),
                OutlinedButton.icon(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Cek Ulang'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _MapMarkerBubble extends StatelessWidget {
  const _MapMarkerBubble({
    required this.label,
    required this.icon,
    required this.tone,
  });

  final String label;
  final IconData icon;
  final PkTone tone;

  @override
  Widget build(BuildContext context) {
    final color = pkToneColor(tone);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 145),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: PkColors.surface,
            borderRadius: PkRadius.pillRadius,
            border: Border.all(color: color.withValues(alpha: 0.2)),
            boxShadow: PkShadow.xs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: PkColors.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
            ],
          ),
        ),
        Icon(Icons.location_pin, color: color, size: 28),
      ],
    );
  }
}

extension on PeduliAntarLocationStatus {
  String get label {
    return switch (this) {
      PeduliAntarLocationStatus.initial => 'Belum dicek',
      PeduliAntarLocationStatus.loading => 'Loading',
      PeduliAntarLocationStatus.granted => 'Granted',
      PeduliAntarLocationStatus.denied => 'Denied',
      PeduliAntarLocationStatus.deniedForever => 'Denied forever',
      PeduliAntarLocationStatus.serviceDisabled => 'Service disabled',
      PeduliAntarLocationStatus.error => 'Error',
    };
  }

  String get description {
    return switch (this) {
      PeduliAntarLocationStatus.initial => 'Sistem belum mengecek izin lokasi.',
      PeduliAntarLocationStatus.loading => 'Sedang mengecek layanan dan izin lokasi.',
      PeduliAntarLocationStatus.granted => 'Izin lokasi aktif dan marker lokasi bisa ditampilkan.',
      PeduliAntarLocationStatus.denied => 'Izin lokasi belum diberikan. Tekan tombol Izinkan Lokasi.',
      PeduliAntarLocationStatus.deniedForever => 'Izin lokasi ditolak permanen dan harus diaktifkan dari pengaturan aplikasi.',
      PeduliAntarLocationStatus.serviceDisabled => 'Layanan lokasi perangkat belum aktif.',
      PeduliAntarLocationStatus.error => 'Terjadi kendala saat mengambil lokasi.',
    };
  }

  IconData get icon {
    return switch (this) {
      PeduliAntarLocationStatus.initial => Icons.location_searching_rounded,
      PeduliAntarLocationStatus.loading => Icons.sync_rounded,
      PeduliAntarLocationStatus.granted => Icons.check_circle_outline_rounded,
      PeduliAntarLocationStatus.denied => Icons.location_off_outlined,
      PeduliAntarLocationStatus.deniedForever => Icons.settings_outlined,
      PeduliAntarLocationStatus.serviceDisabled => Icons.gps_off_outlined,
      PeduliAntarLocationStatus.error => Icons.error_outline_rounded,
    };
  }

  PkTone get tone {
    return switch (this) {
      PeduliAntarLocationStatus.initial => PkTone.gray,
      PeduliAntarLocationStatus.loading => PkTone.blue,
      PeduliAntarLocationStatus.granted => PkTone.green,
      PeduliAntarLocationStatus.denied => PkTone.amber,
      PeduliAntarLocationStatus.deniedForever => PkTone.red,
      PeduliAntarLocationStatus.serviceDisabled => PkTone.amber,
      PeduliAntarLocationStatus.error => PkTone.red,
    };
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
    required this.isCaregiver,
    required this.elderAddress,
    required this.onConfirm,
    required this.onCancel,
    required this.onAdvance,
  });

  final MedicineOrder order;
  final bool isCaregiver;
  final String elderAddress;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final VoidCallback onAdvance;

  @override
  Widget build(BuildContext context) {
    final waiting = order.status == MedicineOrderStatus.waitingCaregiverConfirmation;
    final cancelled = order.status == MedicineOrderStatus.cancelled;

    return PkCard(
      borderColor: waiting ? PkColors.amber.withValues(alpha: 0.22) : PkColors.green.withValues(alpha: 0.18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PkIconBox(
                icon: cancelled ? Icons.cancel_outlined : waiting ? Icons.hourglass_top_rounded : Icons.local_shipping_outlined,
                tone: cancelled ? PkTone.red : waiting ? PkTone.amber : PkTone.green,
              ),
              const SizedBox(width: PkSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.medicineNames,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: PkColors.text,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 4),
                    PkBadge(
                      label: order.status.label,
                      tone: cancelled ? PkTone.red : waiting ? PkTone.amber : PkTone.green,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: PkSpacing.lg),
          for (final medicine in order.medicines)
            _InfoRow(
              icon: Icons.medication_outlined,
              label: 'Obat dipesan',
              value: '${medicine.name} ${medicine.dose} · ${medicine.quantity} paket · ${medicine.priceLabel}',
            ),
          _InfoRow(icon: Icons.local_pharmacy_outlined, label: 'Apotek', value: order.pharmacyName),
          _InfoRow(icon: Icons.place_outlined, label: 'Lokasi apotek', value: order.pharmacyAddress),
          _InfoRow(icon: Icons.home_outlined, label: 'Alamat pengiriman', value: elderAddress == 'Belum diisi' ? order.deliveryAddress : elderAddress),
          _InfoRow(icon: Icons.timer_outlined, label: 'Estimasi tiba', value: order.etaLabel),
          const Divider(height: PkSpacing.xxl),
          _PriceRow(label: 'Harga obat', value: order.medicinePriceLabel),
          _PriceRow(label: 'Biaya transportasi', value: order.deliveryFeeLabel),
          _PriceRow(label: 'Total pembayaran', value: order.totalPriceLabel, strong: true),
          const SizedBox(height: PkSpacing.lg),
          _StatusStepper(status: order.status),
          if (isCaregiver && waiting) ...[
            const SizedBox(height: PkSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onCancel,
                    icon: const Icon(Icons.close_rounded),
                    label: const Text('Tolak Pesanan'),
                  ),
                ),
                const SizedBox(width: PkSpacing.sm),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onConfirm,
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: const Text('Konfirmasi Pesanan'),
                  ),
                ),
              ],
            ),
          ] else if (isCaregiver && !cancelled && order.status != MedicineOrderStatus.completed) ...[
            const SizedBox(height: PkSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onAdvance,
                icon: const Icon(Icons.update_rounded),
                label: const Text('Perbarui Status Pengantaran'),
              ),
            ),
          ] else ...[
            const SizedBox(height: PkSpacing.lg),
            Text(
              waiting
                  ? 'Permintaan pembelian obat sudah dikirim ke keluarga. Tunggu konfirmasi dari anak atau pendamping.'
                  : 'Status pengantaran akan diperbarui oleh pendamping.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: PkColors.text2, height: 1.55),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusStepper extends StatelessWidget {
  const _StatusStepper({required this.status});

  final MedicineOrderStatus status;

  @override
  Widget build(BuildContext context) {
    final statuses = MedicineOrderStatus.values.where((item) => item != MedicineOrderStatus.cancelled).toList();
    final activeIndex = statuses.indexOf(status).clamp(0, statuses.length - 1);

    if (status == MedicineOrderStatus.cancelled) {
      return const PkBadge(label: 'Pesanan dibatalkan', tone: PkTone.red, icon: Icons.cancel_outlined);
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var index = 0; index < statuses.length; index++)
          PkBadge(
            label: statuses[index].label,
            tone: index <= activeIndex ? PkTone.green : PkTone.gray,
            icon: index <= activeIndex ? Icons.check_circle_outline_rounded : Icons.radio_button_unchecked_rounded,
          ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: PkSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: PkColors.brand),
          const SizedBox(width: PkSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: PkColors.muted, fontWeight: FontWeight.w900)),
                const SizedBox(height: 2),
                Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: PkColors.text, height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.label, required this.value, this.strong = false});

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: PkSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: PkColors.text2)),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: strong ? PkColors.brand : PkColors.text,
                  fontWeight: strong ? FontWeight.w900 : FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
