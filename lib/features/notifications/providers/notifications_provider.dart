import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/pk_design.dart';
import '../../../state/providers/app_mode_provider.dart';
import '../../ahli_peduli/providers/ahli_peduli_booking_provider.dart';
import '../../caregiver_profile/providers/caregiver_profile_provider.dart';
import '../../elder_profile/providers/elder_profile_provider.dart';
import '../../peduli_antar/providers/peduli_antar_provider.dart';

class AppNotificationItem {
  AppNotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timeLabel,
    required this.icon,
    required this.tone,
    required this.routePath,
  });

  final String id;
  final String title;
  final String message;
  final String timeLabel;
  final IconData icon;
  final PkTone tone;
  final String routePath;
}

final notificationsProvider = Provider<List<AppNotificationItem>>((ref) {
  final mode = ref.watch(appModeControllerProvider);
  final profile = ref.watch(elderProfileProvider);
  final pendamping = ref.watch(caregiverProfileProvider);
  final orderState = ref.watch(peduliAntarProvider);
  final bookingState = ref.watch(ahliPeduliBookingProvider);

  if (mode == AppUserMode.caregiver) {
    final hasWaitingOrder = orderState.waitingOrders.isNotEmpty;
    final latestOrder = orderState.latestOrder;
    final hasBooking = bookingState.bookings.isNotEmpty;

    return [
      AppNotificationItem(
        id: 'caregiver-link-status',
        title: pendamping.hasLinkedElder ? 'Akun keluarga sudah terhubung' : 'Belum ada lansia terhubung',
        message: pendamping.hasLinkedElder
            ? 'Anda memantau ${profile.displayName}. Kode koneksi: ${pendamping.displayConnectionCode}.'
            : 'Masukkan kode atau pindai QR Code dari akun PeduliDiri.',
        timeLabel: pendamping.displayConnectedAt,
        icon: Icons.family_restroom_rounded,
        tone: pendamping.hasLinkedElder ? PkTone.green : PkTone.amber,
        routePath: AppRoutes.profilePath,
      ),
      AppNotificationItem(
        id: 'low-stock-simvastatin',
        title: 'Obat Simvastatin hampir habis',
        message: 'Sisa 5 tablet. Buka PeduliObat untuk melihat detail stok.',
        timeLabel: 'Kemarin',
        icon: Icons.inventory_2_outlined,
        tone: PkTone.red,
        routePath: AppRoutes.peduliObatPath,
      ),
      AppNotificationItem(
        id: 'order-waiting-confirmation',
        title: hasWaitingOrder ? 'Permintaan pembelian obat menunggu konfirmasi' : 'Permintaan PeduliAntar tersedia',
        message: hasWaitingOrder
            ? 'Periksa nama obat, apotek, biaya, dan alamat sebelum konfirmasi.'
            : (latestOrder == null ? 'Belum ada pesanan aktif. Pesanan dari PeduliObat akan muncul di PeduliAntar.' : 'Status pesanan: ${latestOrder.status.label}.'),
        timeLabel: hasWaitingOrder ? 'Perlu aksi' : 'Terbaru',
        icon: Icons.local_shipping_outlined,
        tone: hasWaitingOrder ? PkTone.amber : PkTone.blue,
        routePath: AppRoutes.peduliAntarPath,
      ),
      AppNotificationItem(
        id: 'daily-check-parent',
        title: 'Cek harian orang tua belum diisi',
        message: 'Kirim pengingat lembut agar data kesehatan hari ini lengkap.',
        timeLabel: '08:15',
        icon: Icons.fact_check_outlined,
        tone: PkTone.amber,
        routePath: AppRoutes.homePath,
      ),
      AppNotificationItem(
        id: 'weekly-summary-caregiver',
        title: 'Ringkasan kesehatan mingguan tersedia',
        message: 'Lihat tren tekanan darah, gula darah, obat, dan catatan keluhan.',
        timeLabel: 'Minggu ini',
        icon: Icons.assignment_outlined,
        tone: PkTone.blue,
        routePath: AppRoutes.peduliRiwayatPath,
      ),
      AppNotificationItem(
        id: 'new-complaint-note',
        title: 'Ada catatan keluhan baru',
        message: 'Keluhan ringan tercatat. Pantau perubahan dan gunakan PeduliKonsul bila perlu.',
        timeLabel: '2 hari lalu',
        icon: Icons.note_alt_outlined,
        tone: PkTone.purple,
        routePath: AppRoutes.peduliRiwayatPath,
      ),
      AppNotificationItem(
        id: 'booking-success',
        title: hasBooking ? 'Booking AhliPeduli berhasil' : 'Jadwal PeduliKonsul tersedia',
        message: hasBooking
            ? 'Booking terakhir: ${bookingState.bookings.first.providerName}, slot ${bookingState.bookings.first.selectedSlot}.'
            : 'Gunakan PeduliKonsul untuk konsultasi awal sebelum AhliPeduli.',
        timeLabel: hasBooking ? 'Baru' : 'Tersedia',
        icon: hasBooking ? Icons.health_and_safety_outlined : Icons.chat_bubble_outline_rounded,
        tone: hasBooking ? PkTone.green : PkTone.purple,
        routePath: hasBooking ? AppRoutes.ahliPeduliPath : AppRoutes.peduliKonsulPath,
      ),
    ];
  }

  return [
    AppNotificationItem(
      id: 'medication-morning',
      title: 'Waktunya minum obat pagi',
      message: 'Jangan lupa minum obat sesuai jadwal.',
      timeLabel: '07:00',
      icon: Icons.medication_outlined,
      tone: PkTone.green,
      routePath: AppRoutes.peduliObatPath,
    ),
    AppNotificationItem(
      id: 'daily-check',
      title: 'Cek harian belum diisi',
      message: 'Isi PeduliCek agar keluarga tahu kondisi hari ini.',
      timeLabel: '08:15',
      icon: Icons.fact_check_outlined,
      tone: PkTone.amber,
      routePath: AppRoutes.peduliCekPath,
    ),
    AppNotificationItem(
      id: 'weekly-summary',
      title: 'Ringkasan kesehatan mingguan tersedia',
      message: 'Lihat ringkasan di PeduliRiwayat.',
      timeLabel: 'Minggu ini',
      icon: Icons.assignment_outlined,
      tone: PkTone.blue,
      routePath: AppRoutes.peduliRiwayatPath,
    ),
    AppNotificationItem(
      id: 'consult',
      title: 'Jadwal PeduliKonsul tersedia',
      message: 'Buka PeduliKonsul jika ada keluhan atau pertanyaan ringan.',
      timeLabel: 'Tersedia',
      icon: Icons.chat_bubble_outline_rounded,
      tone: PkTone.purple,
      routePath: AppRoutes.peduliKonsulPath,
    ),
  ];
});
