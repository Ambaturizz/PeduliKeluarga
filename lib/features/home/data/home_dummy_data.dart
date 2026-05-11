import 'package:flutter/material.dart';

import '../../../state/providers/app_mode_provider.dart';

enum DashboardTone {
  teal,
  blue,
  amber,
  red,
  green,
  purple,
  gray,
}

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

class HomeAlertData {
  const HomeAlertData({
    required this.title,
    required this.message,
    required this.icon,
    required this.tone,
  });

  final String title;
  final String message;
  final IconData icon;
  final DashboardTone tone;
}

class HomeHealthMetric {
  const HomeHealthMetric({
    required this.label,
    required this.value,
    required this.unit,
    required this.status,
    required this.trend,
    required this.icon,
    required this.progress,
    required this.tone,
  });

  final String label;
  final String value;
  final String unit;
  final String status;
  final String trend;
  final IconData icon;
  final double progress;
  final DashboardTone tone;
}

class HomeMedicationProgress {
  const HomeMedicationProgress({
    required this.name,
    required this.detail,
    required this.time,
    required this.status,
    required this.progress,
    required this.tone,
    required this.completed,
  });

  final String name;
  final String detail;
  final String time;
  final String status;
  final double progress;
  final DashboardTone tone;
  final bool completed;
}

class HomeNotificationData {
  const HomeNotificationData({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.tone,
  });

  final String title;
  final String message;
  final String time;
  final IconData icon;
  final DashboardTone tone;
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
  final DashboardTone tone;
  final HomeActionTarget target;
  final String? badge;
}

class HomeTimelineItem {
  const HomeTimelineItem({
    required this.title,
    required this.time,
    required this.tone,
  });

  final String title;
  final String time;
  final DashboardTone tone;
}

class HomeDashboardData {
  const HomeDashboardData({
    required this.mode,
    required this.modeBadge,
    required this.name,
    required this.subtitle,
    required this.lastUpdatedLabel,
    required this.overallScore,
    required this.overallStatus,
    required this.overallMessage,
    required this.heroStats,
    required this.alerts,
    required this.healthMetrics,
    required this.medications,
    required this.notifications,
    required this.quickActions,
    required this.timeline,
    required this.aiTitle,
    required this.aiMessage,
    required this.aiConfidence,
    required this.emergencyTitle,
    required this.emergencySubtitle,
    required this.primaryCtaLabel,
  });

  final AppUserMode mode;
  final String modeBadge;
  final String name;
  final String subtitle;
  final String lastUpdatedLabel;
  final int overallScore;
  final String overallStatus;
  final String overallMessage;
  final List<HomeHeroStat> heroStats;
  final List<HomeAlertData> alerts;
  final List<HomeHealthMetric> healthMetrics;
  final List<HomeMedicationProgress> medications;
  final List<HomeNotificationData> notifications;
  final List<HomeQuickAction> quickActions;
  final List<HomeTimelineItem> timeline;
  final String aiTitle;
  final String aiMessage;
  final String aiConfidence;
  final String emergencyTitle;
  final String emergencySubtitle;
  final String primaryCtaLabel;

  bool get isElder => mode == AppUserMode.elder;
}

final class HomeDummyData {
  const HomeDummyData._();

  static HomeDashboardData forMode({
    required AppUserMode mode,
    required DateTime now,
  }) {
    return switch (mode) {
      AppUserMode.elder => _elder(now),
      AppUserMode.caregiver => _caregiver(now),
    };
  }

  static HomeDashboardData _elder(DateTime now) {
    final second = now.second;
    final heartRate = 76 + (second % 5);
    final bloodSugar = 116 + (second % 7);
    final oxygen = 96 + (second % 3);
    final score = 88 + (second % 5);

    return HomeDashboardData(
      mode: AppUserMode.elder,
      modeBadge: 'Mode Lansia — PeduliDiri',
      name: 'Bapak Purwanto, 68 th',
      subtitle: 'Hipertensi · Diabetes Tipe 2 · Kolesterol',
      lastUpdatedLabel: 'Realtime • ${_formatClock(now)}',
      overallScore: score,
      overallStatus: 'Stabil dipantau',
      overallMessage:
          'Kondisi umum baik. Obat pagi sudah diminum, PeduliCek hari ini belum diisi.',
      heroStats: const [
        HomeHeroStat(
          value: '98%',
          label: 'Pantau aktif',
          icon: Icons.sensors_rounded,
        ),
        HomeHeroStat(
          value: '07:30',
          label: 'Cek terakhir',
          icon: Icons.schedule_rounded,
        ),
        HomeHeroStat(
          value: '6/7',
          label: 'Obat diminum',
          icon: Icons.medication_rounded,
        ),
      ],
      alerts: const [
        HomeAlertData(
          title: 'Simvastatin hampir habis',
          message:
              'Sisa 5 tablet. Minta Reza untuk pesan via PeduliAntar sebelum jadwal malam.',
          icon: Icons.medication_liquid_outlined,
          tone: DashboardTone.amber,
        ),
        HomeAlertData(
          title: 'PeduliCek belum diisi',
          message:
              'Isi cek kesehatan singkat agar keluarga mendapat ringkasan terbaru.',
          icon: Icons.medical_services_outlined,
          tone: DashboardTone.teal,
        ),
      ],
      healthMetrics: [
        const HomeHealthMetric(
          label: 'Tekanan darah',
          value: '132/84',
          unit: 'mmHg',
          status: 'Normal tinggi',
          trend: '+2 dari kemarin',
          icon: Icons.monitor_heart_outlined,
          progress: 0.72,
          tone: DashboardTone.amber,
        ),
        HomeHealthMetric(
          label: 'Gula darah',
          value: '$bloodSugar',
          unit: 'mg/dL',
          status: bloodSugar > 120 ? 'Perlu pantau' : 'Aman',
          trend: 'Simulasi realtime',
          icon: Icons.bloodtype_outlined,
          progress: bloodSugar > 120 ? 0.70 : 0.58,
          tone: bloodSugar > 120 ? DashboardTone.amber : DashboardTone.teal,
        ),
        HomeHealthMetric(
          label: 'Detak jantung',
          value: '$heartRate',
          unit: 'bpm',
          status: 'Stabil',
          trend: 'Live pulse',
          icon: Icons.favorite_border_rounded,
          progress: 0.62,
          tone: DashboardTone.green,
        ),
        HomeHealthMetric(
          label: 'Oksigen',
          value: '$oxygen',
          unit: '%',
          status: 'Baik',
          trend: 'Terukur otomatis',
          icon: Icons.air_rounded,
          progress: 0.88,
          tone: DashboardTone.blue,
        ),
      ],
      medications: const [
        HomeMedicationProgress(
          name: 'Amlodipin 5mg',
          detail: 'Tekanan darah · 1 tablet',
          time: '07:30',
          status: 'Sudah diminum',
          progress: 1,
          tone: DashboardTone.green,
          completed: true,
        ),
        HomeMedicationProgress(
          name: 'Metformin 500mg',
          detail: 'Diabetes · setelah makan',
          time: '07:30',
          status: 'Sudah diminum',
          progress: 1,
          tone: DashboardTone.green,
          completed: true,
        ),
        HomeMedicationProgress(
          name: 'Simvastatin 20mg',
          detail: 'Kolesterol · malam hari',
          time: '19:00',
          status: 'Menunggu',
          progress: 0.32,
          tone: DashboardTone.amber,
          completed: false,
        ),
      ],
      notifications: const [
        HomeNotificationData(
          title: 'Obat pagi selesai',
          message: 'Amlodipin dan Metformin ditandai diminum pukul 07:30.',
          time: '07:32',
          icon: Icons.check_circle_outline_rounded,
          tone: DashboardTone.green,
        ),
        HomeNotificationData(
          title: 'Stok obat menipis',
          message: 'Simvastatin tersisa 5 tablet.',
          time: 'Kemarin',
          icon: Icons.inventory_2_outlined,
          tone: DashboardTone.amber,
        ),
        HomeNotificationData(
          title: 'Ringkasan keluarga',
          message: 'Reza menerima update kesehatan terakhir.',
          time: '2 jam lalu',
          icon: Icons.family_restroom_rounded,
          tone: DashboardTone.blue,
        ),
      ],
      quickActions: const [
        HomeQuickAction(
          title: 'PeduliCek',
          subtitle: 'Cek kesehatan harian',
          icon: Icons.medical_services_outlined,
          tone: DashboardTone.teal,
          target: HomeActionTarget.peduliCek,
          badge: 'Belum diisi',
        ),
        HomeQuickAction(
          title: 'PeduliObat',
          subtitle: 'Jadwal & stok obat',
          icon: Icons.medication_outlined,
          tone: DashboardTone.teal,
          target: HomeActionTarget.peduliObat,
          badge: 'Pagi ✓',
        ),
        HomeQuickAction(
          title: 'Family Alert',
          subtitle: 'Hubungi keluarga',
          icon: Icons.emergency_outlined,
          tone: DashboardTone.red,
          target: HomeActionTarget.familyAlert,
        ),
        HomeQuickAction(
          title: 'Riwayat',
          subtitle: 'Lihat tren kesehatan',
          icon: Icons.assignment_outlined,
          tone: DashboardTone.blue,
          target: HomeActionTarget.peduliRiwayat,
        ),
      ],
      timeline: const [
        HomeTimelineItem(
          title: 'Metformin diminum setelah sarapan',
          time: '07:30',
          tone: DashboardTone.green,
        ),
        HomeTimelineItem(
          title: 'Tekanan darah terakhir 132/84',
          time: '07:28',
          tone: DashboardTone.teal,
        ),
        HomeTimelineItem(
          title: 'Simvastatin dijadwalkan malam',
          time: '19:00',
          tone: DashboardTone.amber,
        ),
      ],
      aiTitle: 'AI Insight hari ini',
      aiMessage:
          'Pola tekanan darah cenderung stabil, tetapi gula darah pagi sedikit naik. Disarankan isi PeduliCek sebelum makan siang dan jaga hidrasi.',
      aiConfidence: 'Keyakinan 87%',
      emergencyTitle: 'Family Alert — Tombol Darurat',
      emergencySubtitle: 'Tekan 1x untuk menghubungi keluarga & AhliPeduli.',
      primaryCtaLabel: 'Mulai PeduliCek',
    );
  }

  static HomeDashboardData _caregiver(DateTime now) {
    final second = now.second;
    final score = 84 + (second % 6);
    final responseRate = 91 + (second % 5);
    final alertCount = 3 + (second % 3);

    return HomeDashboardData(
      mode: AppUserMode.caregiver,
      modeBadge: 'Mode Anak — PeduliPenuh',
      name: 'Reza Dwi Putra, 34 th',
      subtitle: 'Memantau: Bapak Purwanto (68 th)',
      lastUpdatedLabel: 'Live family sync • ${_formatClock(now)}',
      overallScore: score,
      overallStatus: 'Butuh perhatian ringan',
      overallMessage:
          'Bapak stabil, tetapi PeduliCek belum diisi dan stok Simvastatin hampir habis.',
      heroStats: [
        const HomeHeroStat(
          value: '87%',
          label: 'Kepatuhan',
          icon: Icons.verified_outlined,
        ),
        HomeHeroStat(
          value: '$alertCount notif',
          label: 'Perlu cek',
          icon: Icons.notifications_active_outlined,
        ),
        const HomeHeroStat(
          value: 'AI ✓',
          label: 'Insight aktif',
          icon: Icons.auto_awesome_outlined,
        ),
      ],
      alerts: const [
        HomeAlertData(
          title: 'Bapak belum mengisi PeduliCek',
          message:
              'Kirim pengingat lembut agar ringkasan kesehatan hari ini lengkap.',
          icon: Icons.fact_check_outlined,
          tone: DashboardTone.amber,
        ),
        HomeAlertData(
          title: 'Simvastatin hampir habis',
          message:
              'Sisa 5 tablet. Anda bisa pesan ulang melalui PeduliAntar.',
          icon: Icons.medication_outlined,
          tone: DashboardTone.red,
        ),
      ],
      healthMetrics: [
        const HomeHealthMetric(
          label: 'Tekanan darah',
          value: '132/84',
          unit: 'mmHg',
          status: 'Normal tinggi',
          trend: 'Dipantau 2 jam lalu',
          icon: Icons.monitor_heart_outlined,
          progress: 0.72,
          tone: DashboardTone.amber,
        ),
        const HomeHealthMetric(
          label: 'Gula darah',
          value: '118',
          unit: 'mg/dL',
          status: 'Aman',
          trend: 'Turun dari kemarin',
          icon: Icons.bloodtype_outlined,
          progress: 0.58,
          tone: DashboardTone.teal,
        ),
        HomeHealthMetric(
          label: 'Respons pantauan',
          value: '$responseRate',
          unit: '%',
          status: 'Aktif',
          trend: 'Simulasi realtime',
          icon: Icons.sensors_rounded,
          progress: responseRate / 100,
          tone: DashboardTone.green,
        ),
        const HomeHealthMetric(
          label: 'Risiko jatuh',
          value: 'Rendah',
          unit: '',
          status: 'Tidak ada alert',
          trend: '7 hari stabil',
          icon: Icons.elderly_rounded,
          progress: 0.28,
          tone: DashboardTone.blue,
        ),
      ],
      medications: const [
        HomeMedicationProgress(
          name: 'Amlodipin 5mg',
          detail: 'Diminum oleh Bapak',
          time: '07:30',
          status: 'Selesai',
          progress: 1,
          tone: DashboardTone.green,
          completed: true,
        ),
        HomeMedicationProgress(
          name: 'Metformin 500mg',
          detail: 'Jadwal pagi dan malam',
          time: '07:30',
          status: 'Pagi selesai',
          progress: 0.55,
          tone: DashboardTone.teal,
          completed: false,
        ),
        HomeMedicationProgress(
          name: 'Simvastatin 20mg',
          detail: 'Stok 5 tablet',
          time: '19:00',
          status: 'Pesan ulang',
          progress: 0.22,
          tone: DashboardTone.red,
          completed: false,
        ),
      ],
      notifications: const [
        HomeNotificationData(
          title: 'Obat pagi sudah diminum',
          message: 'Amlodipin & Metformin ditandai selesai.',
          time: '07:32',
          icon: Icons.check_circle_outline_rounded,
          tone: DashboardTone.green,
        ),
        HomeNotificationData(
          title: 'PeduliCek belum diisi',
          message: 'Belum ada jawaban cek kesehatan hari ini.',
          time: '08:15',
          icon: Icons.pending_actions_outlined,
          tone: DashboardTone.amber,
        ),
        HomeNotificationData(
          title: 'Stok obat menipis',
          message: 'Simvastatin tersisa 5 tablet.',
          time: 'Kemarin',
          icon: Icons.inventory_2_outlined,
          tone: DashboardTone.red,
        ),
      ],
      quickActions: const [
        HomeQuickAction(
          title: 'Riwayat',
          subtitle: 'Tren kesehatan Bapak',
          icon: Icons.assignment_outlined,
          tone: DashboardTone.blue,
          target: HomeActionTarget.peduliRiwayat,
          badge: '12 catatan',
        ),
        HomeQuickAction(
          title: 'PeduliObat',
          subtitle: 'Atur jadwal obat',
          icon: Icons.medication_outlined,
          tone: DashboardTone.teal,
          target: HomeActionTarget.peduliObat,
          badge: 'Stok rendah',
        ),
        HomeQuickAction(
          title: 'PeduliAntar',
          subtitle: 'Pesan obat ke rumah',
          icon: Icons.local_shipping_outlined,
          tone: DashboardTone.amber,
          target: HomeActionTarget.peduliAntar,
        ),
        HomeQuickAction(
          title: 'AhliPeduli',
          subtitle: 'Dokter & homecare',
          icon: Icons.health_and_safety_outlined,
          tone: DashboardTone.red,
          target: HomeActionTarget.ahliPeduli,
        ),
      ],
      timeline: const [
        HomeTimelineItem(
          title: 'Obat pagi ditandai selesai',
          time: '07:32',
          tone: DashboardTone.green,
        ),
        HomeTimelineItem(
          title: 'PeduliCek belum diisi',
          time: '08:15',
          tone: DashboardTone.amber,
        ),
        HomeTimelineItem(
          title: 'Stok Simvastatin hampir habis',
          time: 'Kemarin',
          tone: DashboardTone.red,
        ),
      ],
      aiTitle: 'AI Insight keluarga',
      aiMessage:
          'Tidak ada tanda bahaya akut. Prioritas hari ini: kirim pengingat PeduliCek dan pesan ulang Simvastatin agar tidak terlewat.',
      aiConfidence: 'Keyakinan 91%',
      emergencyTitle: 'Pantau Family Alert',
      emergencySubtitle:
          'Jika tombol darurat ditekan, keluarga dan AhliPeduli akan diberi notifikasi.',
      primaryCtaLabel: 'Lihat Riwayat',
    );
  }

  static String _formatClock(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    final second = value.second.toString().padLeft(2, '0');

    return '$hour:$minute:$second';
  }
}