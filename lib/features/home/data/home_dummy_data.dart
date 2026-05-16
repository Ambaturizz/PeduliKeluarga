import 'package:flutter/material.dart';

import '../../../core/theme/pk_design.dart';
import '../../../state/providers/app_mode_provider.dart';
import '../../caregiver_profile/domain/caregiver_profile.dart';
import '../../elder_profile/domain/elder_profile.dart';

enum HomeActionTarget {
  peduliCek,
  peduliObat,
  peduliRiwayat,
  familyAlert,
  ahliPeduli,
  peduliAntar,
  notifications,
  profile,
  peduliKonsul,
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
    ElderProfile? elderProfile,
    CaregiverProfile? caregiverProfile,
  }) {
    return switch (mode) {
      AppUserMode.elder => _elder(now, elderProfile, caregiverProfile),
      AppUserMode.caregiver => _caregiver(now, elderProfile, caregiverProfile),
    };
  }

  static HomeDashboardData _elder(
    DateTime now,
    ElderProfile? profile,
    CaregiverProfile? caregiver,
  ) {
    final elder = profile;
    final name = elder?.displayName ?? 'Belum diisi';
    final age = elder?.displayAge ?? 'Belum diisi';
    final weight = elder?.displayWeight ?? 'Belum diisi';
    final gender = elder?.displayGender ?? 'Belum diisi';
    final history = elder?.medicalHistoryLabel ?? 'Belum diisi';
    final caregiverName = caregiver?.displayName ?? 'Belum diisi';

    return HomeDashboardData(
      mode: AppUserMode.elder,
      kicker: 'Mode Lansia — PeduliDiri',
      heroTitle: name,
      heroSubtitle:
          '$age · $gender · BB: $weight · Anak/Pendamping: $caregiverName. Riwayat: $history. Data ini dapat diperbarui dari profil.',
      liveLabel: 'Diperbarui ${_clock(now)}',
      primaryButton: 'Cek Hari Ini',
      secondaryButton: 'Minum Obat',
      heroStats: [
        const HomeHeroStat(
          value: '13:00',
          label: 'Obat berikutnya',
          icon: Icons.medication_outlined,
        ),
        const HomeHeroStat(
          value: 'Belum',
          label: 'Cek harian',
          icon: Icons.fact_check_outlined,
        ),
        HomeHeroStat(
          value: weight,
          label: 'Berat badan',
          icon: Icons.monitor_weight_outlined,
        ),
      ],
      summaryTitle: 'Kondisi umum hari ini cukup baik',
      summarySubtitle: 'Semua data kesehatan dicatat manual oleh pengguna atau keluarga.',
      metrics: const [
        HomeMetric(
          label: 'Kondisi umum',
          value: 'Baik',
          note: 'Belum ada keluhan berat hari ini.',
          icon: Icons.sentiment_satisfied_alt_rounded,
          tone: PkTone.green,
          progress: 0.78,
        ),
        HomeMetric(
          label: 'Tekanan darah',
          value: 'Belum dicatat',
          note: 'Cek cukup 1 kali seminggu, kecuali dokter meminta lebih sering.',
          icon: Icons.monitor_heart_outlined,
          tone: PkTone.amber,
          progress: 0.45,
        ),
        HomeMetric(
          label: 'Gula darah',
          value: 'Stabil',
          note: 'Terakhir dicatat: Hari ini. Dicatat manual oleh pengguna.',
          icon: Icons.bloodtype_outlined,
          tone: PkTone.green,
          progress: 0.72,
        ),
      ],
      alerts: const [
        HomeAlert(
          title: 'Cek harian belum diisi',
          copy: 'Isi PeduliCek agar keluarga tahu kondisi hari ini.',
          time: '08:15',
          icon: Icons.fact_check_outlined,
          tone: PkTone.amber,
        ),
        HomeAlert(
          title: 'Simvastatin hampir habis',
          copy: 'Tekan Pesan Sekarang untuk meminta konfirmasi keluarga.',
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
          dose: '500mg · sesudah makan',
          time: '13:00',
          status: 'Berikutnya',
          progress: 55,
          tone: PkTone.brand,
        ),
        HomeMedicine(
          name: 'Simvastatin',
          dose: '20mg · malam hari · sisa 5 tablet',
          time: '19:00',
          status: 'Perlu dibeli',
          progress: 26,
          tone: PkTone.red,
          lowStock: true,
        ),
      ],
      quickActions: const [
        HomeQuickAction(
          title: 'PeduliCek',
          subtitle: 'Cek hari ini',
          icon: Icons.medical_services_outlined,
          tone: PkTone.brand,
          target: HomeActionTarget.peduliCek,
          badge: 'Belum diisi',
        ),
        HomeQuickAction(
          title: 'PeduliObat',
          subtitle: 'Jadwal obat',
          icon: Icons.medication_outlined,
          tone: PkTone.green,
          target: HomeActionTarget.peduliObat,
          badge: '13:00',
        ),
        HomeQuickAction(
          title: 'PeduliDarurat',
          subtitle: 'Bantuan cepat',
          icon: Icons.emergency_outlined,
          tone: PkTone.red,
          target: HomeActionTarget.familyAlert,
        ),
        HomeQuickAction(
          title: 'PeduliKonsul',
          subtitle: 'Konsultasi',
          icon: Icons.chat_bubble_outline_rounded,
          tone: PkTone.purple,
          target: HomeActionTarget.peduliKonsul,
        ),
        HomeQuickAction(
          title: 'PeduliRiwayat',
          subtitle: 'Riwayat sehat',
          icon: Icons.assignment_outlined,
          tone: PkTone.blue,
          target: HomeActionTarget.peduliRiwayat,
        ),
      ],
      history: const [
        HomeHistoryItem(
          title: 'PeduliCek belum diisi',
          copy: 'Belum ada catatan hari ini.',
          time: 'Hari ini',
          tone: PkTone.amber,
        ),
        HomeHistoryItem(
          title: 'Permintaan obat siap dibuat',
          copy: 'Simvastatin tinggal 5 tablet.',
          time: 'Kemarin',
          tone: PkTone.amber,
        ),
        HomeHistoryItem(
          title: 'Catatan keluhan terakhir',
          copy: 'Tidak ada keluhan berat.',
          time: '2 hari lalu',
          tone: PkTone.green,
        ),
      ],
      aiEyebrow: 'AIPeduli',
      aiTitle: 'Ringkasan awal hari ini',
      aiCopy:
          'Kondisi umum terlihat cukup baik. Cek harian belum diisi. Tekanan darah cukup dicek 1 kali seminggu, kecuali dokter meminta lebih sering.',
      aiBadge: 'Aman',
      emergencyTitle: 'Butuh bantuan sekarang?',
      emergencyCopy: 'Tekan PeduliDarurat untuk meminta bantuan keluarga.',
    );
  }

  static HomeDashboardData _caregiver(
    DateTime now,
    ElderProfile? profile,
    CaregiverProfile? caregiver,
  ) {
    final caregiverName = caregiver?.displayName ?? 'Belum diisi';
    final elderNameFromProfile = profile?.name.trim() ?? '';
    final elderNameFromCaregiver = caregiver?.elderName.trim() ?? '';
    final elderName = elderNameFromProfile.isNotEmpty
        ? elderNameFromProfile
        : elderNameFromCaregiver.isNotEmpty
            ? elderNameFromCaregiver
            : 'Belum diisi';
    final elderAge = profile?.displayAge ?? 'Belum diisi';
    final elderWeight = profile?.displayWeight ?? 'Belum diisi';
    final elderHistory = profile?.medicalHistoryLabel ?? 'Belum diisi';
    final relation = caregiver?.displayRelationship ?? 'Anak atau pendamping';

    return HomeDashboardData(
      mode: AppUserMode.caregiver,
      kicker: 'Mode Anak — PeduliPenuh',
      heroTitle: 'Halo, $caregiverName',
      heroSubtitle: 'Anda memantau $elderName sebagai $relation. Umur: $elderAge. BB: $elderWeight. Riwayat: $elderHistory. Data ini berasal dari profil keluarga.',
      liveLabel: 'Diperbarui ${_clock(now)}',
      primaryButton: 'Lihat Riwayat',
      secondaryButton: 'Atur Obat',
      heroStats: const [
        HomeHeroStat(value: '3', label: 'Perlu perhatian', icon: Icons.notifications_active_outlined),
        HomeHeroStat(value: '94%', label: 'Kepatuhan obat', icon: Icons.medication_outlined),
        HomeHeroStat(value: '1', label: 'Permintaan obat', icon: Icons.local_shipping_outlined),
      ],
      summaryTitle: 'Ringkasan $elderName',
      summarySubtitle: 'Kondisi umum, cek harian, obat, dan catatan keluhan orang tua.',
      metrics: const [
        HomeMetric(
          label: 'Cek harian',
          value: 'Belum',
          note: 'Kirim pengingat lembut.',
          icon: Icons.fact_check_outlined,
          tone: PkTone.amber,
          progress: 0.4,
        ),
        HomeMetric(
          label: 'Kepatuhan obat',
          value: '94',
          unit: '%',
          note: 'Kepatuhan obat 30 hari.',
          icon: Icons.medication_outlined,
          tone: PkTone.brand,
          progress: 0.94,
        ),
        HomeMetric(
          label: 'Permintaan obat',
          value: '1',
          note: 'Menunggu konfirmasi pendamping.',
          icon: Icons.local_shipping_outlined,
          tone: PkTone.amber,
          progress: 0.55,
        ),
      ],
      alerts: const [
        HomeAlert(
          title: 'Cek harian belum diisi',
          copy: 'Kirim pengingat agar data kesehatan hari ini lengkap.',
          time: '08:15',
          icon: Icons.pending_actions_outlined,
          tone: PkTone.amber,
        ),
        HomeAlert(
          title: 'Simvastatin hampir habis',
          copy: 'Sisa 5 tablet. Konfirmasi pembelian melalui PeduliAntar.',
          time: 'Kemarin',
          icon: Icons.inventory_2_outlined,
          tone: PkTone.red,
        ),
      ],
      medicines: const [
        HomeMedicine(name: 'Amlodipin', dose: '5mg', time: '07:00', status: 'Selesai', progress: 100, tone: PkTone.green),
        HomeMedicine(name: 'Metformin', dose: '500mg', time: '13:00', status: 'Berikutnya', progress: 55, tone: PkTone.brand),
        HomeMedicine(name: 'Simvastatin', dose: '20mg · stok rendah', time: '19:00', status: 'Konfirmasi', progress: 22, tone: PkTone.red, lowStock: true),
      ],
      quickActions: const [
        HomeQuickAction(title: 'PeduliRiwayat', subtitle: 'Riwayat sehat', icon: Icons.assignment_outlined, tone: PkTone.blue, target: HomeActionTarget.peduliRiwayat),
        HomeQuickAction(title: 'PeduliObat', subtitle: 'Atur jadwal', icon: Icons.medication_outlined, tone: PkTone.brand, target: HomeActionTarget.peduliObat),
        HomeQuickAction(title: 'PeduliAntar', subtitle: 'Antar obat', icon: Icons.local_shipping_outlined, tone: PkTone.amber, target: HomeActionTarget.peduliAntar),
        HomeQuickAction(title: 'AhliPeduli', subtitle: 'Tenaga medis', icon: Icons.health_and_safety_outlined, tone: PkTone.purple, target: HomeActionTarget.ahliPeduli),
        HomeQuickAction(title: 'PeduliDarurat', subtitle: 'Darurat', icon: Icons.emergency_outlined, tone: PkTone.red, target: HomeActionTarget.familyAlert),
        HomeQuickAction(title: 'PeduliKonsul', subtitle: 'Konsultasi', icon: Icons.chat_bubble_outline_rounded, tone: PkTone.purple, target: HomeActionTarget.peduliKonsul),
      ],
      history: const [
        HomeHistoryItem(title: 'Obat pagi sudah diminum', copy: 'Amlodipin dan Metformin selesai.', time: '07:32', tone: PkTone.green),
        HomeHistoryItem(title: 'PeduliCek belum diisi', copy: 'Belum ada input cek kesehatan hari ini.', time: '08:15', tone: PkTone.amber),
      ],
      aiEyebrow: 'AIPeduli',
      aiTitle: 'Ringkasan cepat untuk $elderName',
      aiCopy: 'Halo $caregiverName, kondisi umum $elderName hari ini cukup stabil. Cek harian belum diisi, Simvastatin hampir habis, gula darah terakhir stabil, dan tekanan darah terakhir dicatat manual. Konfirmasi pesanan obat lewat PeduliAntar bila data sudah sesuai.',
      aiBadge: 'Pantau',
      emergencyTitle: 'Pantau PeduliDarurat',
      emergencyCopy: 'Jika tombol darurat ditekan, keluarga akan mendapat notifikasi.',
    );
  }

  static String _clock(DateTime value) {
    final h = value.hour.toString().padLeft(2, '0');
    final m = value.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
