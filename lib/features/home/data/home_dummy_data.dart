import 'package:flutter/material.dart';

import '../../../core/theme/pk_design.dart';
import '../../../state/providers/app_mode_provider.dart';

enum HomeActionTarget {
  peduliCek,
  peduliObat,
  peduliRiwayat,
  familyAlert,
  ahliPeduli,
  peduliAntar,
  notifications,
  profile,
}

class HomeHeroStat {
  const HomeHeroStat({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;
}

class HomeMetric {
  const HomeMetric({
    required this.label,
    required this.value,
    required this.note,
    required this.icon,
    required this.tone,
    this.unit,
    this.progress,
  });

  final String label;
  final String value;
  final String? unit;
  final String note;
  final IconData icon;
  final PkTone tone;
  final double? progress;
}

class HomeAlert {
  const HomeAlert({
    required this.title,
    required this.copy,
    required this.time,
    required this.icon,
    required this.tone,
  });

  final String title;
  final String copy;
  final String time;
  final IconData icon;
  final PkTone tone;
}

class HomeMedicine {
  const HomeMedicine({
    required this.name,
    required this.dose,
    required this.time,
    required this.status,
    required this.progress,
    required this.tone,
    this.lowStock = false,
  });

  final String name;
  final String dose;
  final String time;
  final String status;
  final int progress;
  final PkTone tone;
  final bool lowStock;
}

class HomeQuickAction {
  const HomeQuickAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tone,
    required this.target,
    this.badge,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final PkTone tone;
  final HomeActionTarget target;
  final String? badge;
}

class HomeHistoryItem {
  const HomeHistoryItem({
    required this.title,
    required this.copy,
    required this.time,
    required this.tone,
  });

  final String title;
  final String copy;
  final String time;
  final PkTone tone;
}

class HomeDashboardData {
  const HomeDashboardData({
    required this.mode,
    required this.kicker,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.liveLabel,
    required this.heroStats,
    required this.primaryButton,
    required this.secondaryButton,
    required this.summaryTitle,
    required this.summarySubtitle,
    required this.metrics,
    required this.alerts,
    required this.medicines,
    required this.quickActions,
    required this.history,
    required this.aiEyebrow,
    required this.aiTitle,
    required this.aiCopy,
    required this.aiBadge,
    required this.emergencyTitle,
    required this.emergencyCopy,
  });

  final AppUserMode mode;
  final String kicker;
  final String heroTitle;
  final String heroSubtitle;
  final String liveLabel;
  final List<HomeHeroStat> heroStats;
  final String primaryButton;
  final String secondaryButton;
  final String summaryTitle;
  final String summarySubtitle;
  final List<HomeMetric> metrics;
  final List<HomeAlert> alerts;
  final List<HomeMedicine> medicines;
  final List<HomeQuickAction> quickActions;
  final List<HomeHistoryItem> history;
  final String aiEyebrow;
  final String aiTitle;
  final String aiCopy;
  final String aiBadge;
  final String emergencyTitle;
  final String emergencyCopy;

  bool get isElder => mode == AppUserMode.elder;
}

final class HomeDummyData {
  const HomeDummyData._();

  static HomeDashboardData byMode({
    required AppUserMode mode,
    required DateTime now,
  }) {
    return switch (mode) {
      AppUserMode.elder => _elder(now),
      AppUserMode.caregiver => _caregiver(now),
    };
  }

  static HomeDashboardData _elder(DateTime now) {
    final pulse = 78 + (now.second % 4);
    final sugar = 122 + (now.second % 5);
    final oxygen = 97 + (now.second % 2);

    return HomeDashboardData(
      mode: AppUserMode.elder,
      kicker: 'Mode Lansia — PeduliDiri',
      heroTitle: 'Bapak Purwanto',
      heroSubtitle:
          '68 tahun · Hipertensi · Diabetes Tipe 2 · Kolesterol. Dashboard harian untuk menjaga rutinitas kesehatan tetap tenang, jelas, dan mudah diikuti.',
      liveLabel: 'Live sync · ${_clock(now)}',
      primaryButton: 'Mulai cek harian',
      secondaryButton: 'Lihat obat hari ini',
      heroStats: [
        const HomeHeroStat(
          value: '94%',
          label: 'Kepatuhan obat',
          icon: Icons.medication_outlined,
        ),
        HomeHeroStat(
          value: '$pulse',
          label: 'BPM sekarang',
          icon: Icons.favorite_border_rounded,
        ),
        const HomeHeroStat(
          value: 'Low',
          label: 'Risk score',
          icon: Icons.shield_outlined,
        ),
      ],
      summaryTitle: 'Hari ini terlihat cukup stabil',
      summarySubtitle:
          'Namun PeduliCek belum diisi dan stok Simvastatin perlu diperhatikan.',
      metrics: [
        const HomeMetric(
          label: 'Tekanan darah',
          value: '138/88',
          unit: 'mmHg',
          note: 'Sedikit lebih tinggi dari rata-rata minggu lalu.',
          icon: Icons.monitor_heart_outlined,
          tone: PkTone.amber,
          progress: 0.72,
        ),
        HomeMetric(
          label: 'Gula darah',
          value: '$sugar',
          unit: 'mg/dL',
          note: 'Cenderung stabil di rentang target.',
          icon: Icons.bloodtype_outlined,
          tone: PkTone.brand,
          progress: 0.61,
        ),
        HomeMetric(
          label: 'Oksigen',
          value: '$oxygen',
          unit: '%',
          note: 'Terukur baik pada simulasi realtime.',
          icon: Icons.air_rounded,
          tone: PkTone.blue,
          progress: 0.88,
        ),
      ],
      alerts: const [
        HomeAlert(
          title: 'PeduliCek belum diisi',
          copy:
              'Isi cek harian supaya Reza tahu kondisi Bapak hari ini.',
          time: '08:15',
          icon: Icons.fact_check_outlined,
          tone: PkTone.amber,
        ),
        HomeAlert(
          title: 'Obat pagi sudah diminum',
          copy: 'Amlodipin dan Metformin tercatat pukul 07:32.',
          time: '07:32',
          icon: Icons.check_circle_outline_rounded,
          tone: PkTone.green,
        ),
        HomeAlert(
          title: 'Simvastatin hampir habis',
          copy: 'Sisa 5 tablet. Disarankan pesan ulang hari ini.',
          time: 'Kemarin',
          icon: Icons.inventory_2_outlined,
          tone: PkTone.amber,
        ),
      ],
      medicines: const [
        HomeMedicine(
          name: 'Amlodipin',
          dose: '5mg · tekanan darah',
          time: '07:00',
          status: 'Selesai',
          progress: 100,
          tone: PkTone.green,
        ),
        HomeMedicine(
          name: 'Metformin',
          dose: '500mg · setelah makan',
          time: '07:30',
          status: 'Selesai',
          progress: 100,
          tone: PkTone.green,
        ),
        HomeMedicine(
          name: 'Simvastatin',
          dose: '20mg · malam hari · sisa 5 tablet',
          time: '19:00',
          status: 'Pesan ulang',
          progress: 26,
          tone: PkTone.red,
          lowStock: true,
        ),
      ],
      quickActions: const [
        HomeQuickAction(
          title: 'PeduliCek',
          subtitle: 'Cek harian adaptif',
          icon: Icons.medical_services_outlined,
          tone: PkTone.brand,
          target: HomeActionTarget.peduliCek,
          badge: 'Belum diisi',
        ),
        HomeQuickAction(
          title: 'PeduliObat',
          subtitle: 'Jadwal dan stok',
          icon: Icons.medication_outlined,
          tone: PkTone.green,
          target: HomeActionTarget.peduliObat,
          badge: 'Pagi ✓',
        ),
        HomeQuickAction(
          title: 'Family Alert',
          subtitle: 'Bantuan darurat',
          icon: Icons.emergency_outlined,
          tone: PkTone.red,
          target: HomeActionTarget.familyAlert,
        ),
        HomeQuickAction(
          title: 'PeduliRiwayat',
          subtitle: 'Tren kesehatan',
          icon: Icons.assignment_outlined,
          tone: PkTone.blue,
          target: HomeActionTarget.peduliRiwayat,
        ),
      ],
      history: const [
        HomeHistoryItem(
          title: 'PeduliCek selesai',
          copy: 'TD 138/88 · GD 124 · mood baik',
          time: 'Hari ini 07:42',
          tone: PkTone.green,
        ),
        HomeHistoryItem(
          title: 'Simvastatin hampir habis',
          copy: 'Sisa 5 tablet, disarankan pesan ulang',
          time: 'Kemarin',
          tone: PkTone.amber,
        ),
        HomeHistoryItem(
          title: 'Metformin siang terlewat',
          copy: 'Reminder terkirim ke Bapak dan Reza',
          time: '2 hari lalu',
          tone: PkTone.red,
        ),
      ],
      aiEyebrow: 'AI insight card',
      aiTitle: 'Pola tekanan darah perlu dipantau ringan',
      aiCopy:
          'Tekanan darah 7 hari terakhir sedikit naik. Isi PeduliCek hari ini dan tandai untuk konsultasi dokter bila tren naik berulang. Saat ini status belum darurat.',
      aiBadge: 'Monitor',
      emergencyTitle: 'Butuh bantuan sekarang?',
      emergencyCopy:
          'Satu tombol untuk menghubungi keluarga dan tim AhliPeduli.',
    );
  }

  static HomeDashboardData _caregiver(DateTime now) {
    final alertCount = 5 + (now.second % 2);

    return HomeDashboardData(
      mode: AppUserMode.caregiver,
      kicker: 'Mode Anak — PeduliPenuh',
      heroTitle: 'Reza Dwi Putra',
      heroSubtitle:
          'Memantau Bapak Purwanto dari jauh dengan ringkasan kesehatan, stok obat, Family Alert, dan rekomendasi AI yang bisa langsung ditindaklanjuti.',
      liveLabel: 'Live family sync · ${_clock(now)}',
      primaryButton: 'Lihat riwayat Bapak',
      secondaryButton: 'Atur obat',
      heroStats: [
        const HomeHeroStat(
          value: 'Low',
          label: 'Risk score',
          icon: Icons.shield_outlined,
        ),
        const HomeHeroStat(
          value: '94%',
          label: 'Adherence',
          icon: Icons.medication_outlined,
        ),
        HomeHeroStat(
          value: '$alertCount',
          label: 'Alert aktif',
          icon: Icons.notifications_active_outlined,
        ),
      ],
      summaryTitle: 'Bapak aman, ada 2 hal yang perlu dibantu hari ini',
      summarySubtitle:
          'Fokus pada notifikasi, stok obat, dan tren kesehatan yang berubah.',
      metrics: const [
        HomeMetric(
          label: 'Risk score',
          value: 'Low',
          note: 'Tidak ada tanda darurat.',
          icon: Icons.shield_outlined,
          tone: PkTone.green,
          progress: 0.28,
        ),
        HomeMetric(
          label: 'Adherence',
          value: '94',
          unit: '%',
          note: 'Kepatuhan obat 30 hari.',
          icon: Icons.medication_outlined,
          tone: PkTone.brand,
          progress: 0.94,
        ),
        HomeMetric(
          label: 'Alert',
          value: '5',
          note: '2 butuh tindakan.',
          icon: Icons.notifications_active_outlined,
          tone: PkTone.amber,
          progress: 0.55,
        ),
      ],
      alerts: const [
        HomeAlert(
          title: 'PeduliCek belum diisi',
          copy: 'Kirim pengingat lembut agar data kesehatan hari ini lengkap.',
          time: '08:15',
          icon: Icons.pending_actions_outlined,
          tone: PkTone.amber,
        ),
        HomeAlert(
          title: 'Simvastatin hampir habis',
          copy: 'Sisa 5 tablet. Pesankan melalui PeduliAntar hari ini.',
          time: 'Kemarin',
          icon: Icons.inventory_2_outlined,
          tone: PkTone.red,
        ),
        HomeAlert(
          title: 'Obat pagi selesai',
          copy: 'Amlodipin dan Metformin tercatat diminum.',
          time: '07:32',
          icon: Icons.check_circle_outline_rounded,
          tone: PkTone.green,
        ),
      ],
      medicines: const [
        HomeMedicine(
          name: 'Amlodipin',
          dose: 'Bapak · 5mg',
          time: '07:00',
          status: 'Selesai',
          progress: 100,
          tone: PkTone.green,
        ),
        HomeMedicine(
          name: 'Metformin',
          dose: 'Bapak · 500mg · 2x sehari',
          time: '07:30',
          status: 'Pagi selesai',
          progress: 55,
          tone: PkTone.brand,
        ),
        HomeMedicine(
          name: 'Simvastatin',
          dose: 'Bapak · 20mg · stok rendah',
          time: '19:00',
          status: 'Pesan sekarang',
          progress: 22,
          tone: PkTone.red,
          lowStock: true,
        ),
      ],
      quickActions: const [
        HomeQuickAction(
          title: 'PeduliRiwayat',
          subtitle: 'Tren kesehatan',
          icon: Icons.assignment_outlined,
          tone: PkTone.blue,
          target: HomeActionTarget.peduliRiwayat,
          badge: '12 catatan',
        ),
        HomeQuickAction(
          title: 'PeduliObat',
          subtitle: 'Atur jadwal',
          icon: Icons.medication_outlined,
          tone: PkTone.brand,
          target: HomeActionTarget.peduliObat,
          badge: 'Stok rendah',
        ),
        HomeQuickAction(
          title: 'PeduliAntar',
          subtitle: 'Pesan obat',
          icon: Icons.local_shipping_outlined,
          tone: PkTone.amber,
          target: HomeActionTarget.peduliAntar,
        ),
        HomeQuickAction(
          title: 'AhliPeduli',
          subtitle: 'Dokter & homecare',
          icon: Icons.health_and_safety_outlined,
          tone: PkTone.purple,
          target: HomeActionTarget.ahliPeduli,
        ),
      ],
      history: const [
        HomeHistoryItem(
          title: 'Obat pagi sudah diminum',
          copy: 'Amlodipin dan Metformin selesai pukul 07:32.',
          time: '07:32',
          tone: PkTone.green,
        ),
        HomeHistoryItem(
          title: 'PeduliCek belum diisi',
          copy: 'Belum ada input cek kesehatan hari ini.',
          time: '08:15',
          tone: PkTone.amber,
        ),
        HomeHistoryItem(
          title: 'Stok Simvastatin rendah',
          copy: 'Sisa 5 tablet, disarankan pesan ulang.',
          time: 'Kemarin',
          tone: PkTone.red,
        ),
      ],
      aiEyebrow: 'AI insight card',
      aiTitle: 'Saran tindak lanjut untuk Reza',
      aiCopy:
          'Pesankan Simvastatin hari ini karena stok tinggal 5 tablet. Minta Bapak isi PeduliCek untuk melengkapi tren tekanan darah minggu ini.',
      aiBadge: 'Medium',
      emergencyTitle: 'Pantau Family Alert',
      emergencyCopy:
          'Jika tombol darurat ditekan, notifikasi keluarga dan AhliPeduli akan aktif otomatis.',
    );
  }

  static String _clock(DateTime value) {
    final h = value.hour.toString().padLeft(2, '0');
    final m = value.minute.toString().padLeft(2, '0');
    final s = value.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}