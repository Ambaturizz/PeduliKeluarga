import 'package:flutter/material.dart';

import '../../../core/theme/pk_design.dart';

enum DaruratStatus {
  standby,
  active,
  dispatching,
  notified,
  resolved,
  cancelled;

  String get label {
    return switch (this) {
      DaruratStatus.standby => 'Siaga',
      DaruratStatus.active => 'Aktif',
      DaruratStatus.dispatching => 'Mengirim bantuan',
      DaruratStatus.notified => 'Keluarga diberi tahu',
      DaruratStatus.resolved => 'Selesai',
      DaruratStatus.cancelled => 'Dibatalkan',
    };
  }

  String get description {
    return switch (this) {
      DaruratStatus.standby => 'Sistem siap digunakan kapan saja.',
      DaruratStatus.active =>
        'PeduliDarurat sedang aktif. Hitungan mundur berjalan.',
      DaruratStatus.dispatching =>
        'Notifikasi dan bantuan sedang diproses.',
      DaruratStatus.notified =>
        'Kontak darurat sudah menerima notifikasi.',
      DaruratStatus.resolved =>
        'Kejadian darurat sudah ditandai selesai.',
      DaruratStatus.cancelled =>
        'PeduliDarurat dibatalkan sebelum bantuan dikirim.',
    };
  }

  PkTone get tone {
    return switch (this) {
      DaruratStatus.standby => PkTone.brand,
      DaruratStatus.active => PkTone.red,
      DaruratStatus.dispatching => PkTone.amber,
      DaruratStatus.notified => PkTone.blue,
      DaruratStatus.resolved => PkTone.green,
      DaruratStatus.cancelled => PkTone.gray,
    };
  }

  IconData get icon {
    return switch (this) {
      DaruratStatus.standby => Icons.health_and_safety_outlined,
      DaruratStatus.active => Icons.emergency_outlined,
      DaruratStatus.dispatching => Icons.local_shipping_outlined,
      DaruratStatus.notified => Icons.notifications_active_outlined,
      DaruratStatus.resolved => Icons.check_circle_outline_rounded,
      DaruratStatus.cancelled => Icons.cancel_outlined,
    };
  }
}

class DaruratContact {
  const DaruratContact({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
    required this.responseTime,
    required this.icon,
    required this.tone,
    this.notified = false,
  });

  final String id;
  final String name;
  final String role;
  final String phone;
  final String responseTime;
  final IconData icon;
  final PkTone tone;
  final bool notified;

  DaruratContact copyWith({bool? notified}) {
    return DaruratContact(
      id: id,
      name: name,
      role: role,
      phone: phone,
      responseTime: responseTime,
      icon: icon,
      tone: tone,
      notified: notified ?? this.notified,
    );
  }
}

class DaruratTimelineEvent {
  const DaruratTimelineEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.tone,
    required this.icon,
  });

  final String id;
  final String title;
  final String description;
  final String time;
  final PkTone tone;
  final IconData icon;
}

class DaruratMedicalSummary {
  const DaruratMedicalSummary({
    required this.name,
    required this.age,
    required this.conditions,
    required this.allergies,
    required this.lastCheck,
    required this.bloodPressure,
    required this.bloodSugar,
    required this.currentMedications,
  });

  final String name;
  final int age;
  final List<String> conditions;
  final String allergies;
  final String lastCheck;
  final String bloodPressure;
  final String bloodSugar;
  final List<String> currentMedications;
}

class DaruratDispatchStep {
  const DaruratDispatchStep({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tone,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final PkTone tone;
}

final class DaruratMockData {
  const DaruratMockData._();

  static const contacts = [
    DaruratContact(
      id: 'reza',
      name: 'Reza Dwi Putra',
      role: 'Anak utama',
      phone: '+62 812 6615 223',
      responseTime: '± 2 menit',
      icon: Icons.family_restroom_rounded,
      tone: PkTone.brand,
    ),
    DaruratContact(
      id: 'nina',
      name: 'Nina Putri',
      role: 'Anak kedua',
      phone: '+62 813 4400 119',
      responseTime: '± 5 menit',
      icon: Icons.person_outline_rounded,
      tone: PkTone.blue,
    ),
    DaruratContact(
      id: 'ahli',
      name: 'AhliPeduli Siaga',
      role: 'Mitra perawatan rumah',
      phone: '1500-921',
      responseTime: '± 10 menit',
      icon: Icons.health_and_safety_outlined,
      tone: PkTone.red,
    ),
  ];

  static const medicalSummary = DaruratMedicalSummary(
    name: 'Bapak Purwanto',
    age: 68,
    conditions: ['Hipertensi', 'Diabetes Tipe 2', 'Kolesterol'],
    allergies: 'Tidak ada alergi obat yang tercatat',
    lastCheck: 'Hari ini 07:42',
    bloodPressure: '138/88 mmHg',
    bloodSugar: '124 mg/dL',
    currentMedications: [
      'Amlodipin 5mg',
      'Metformin 500mg',
      'Simvastatin 20mg',
    ],
  );

  static const dispatchSteps = [
    DaruratDispatchStep(
      title: 'PeduliDarurat dibuat',
      subtitle: 'Sinyal darurat diterima sistem PeduliKeluarga.',
      icon: Icons.emergency_outlined,
      tone: PkTone.red,
    ),
    DaruratDispatchStep(
      title: 'Keluarga dihubungi',
      subtitle: 'Keluarga menerima simulasi notifikasi.',
      icon: Icons.notifications_active_outlined,
      tone: PkTone.amber,
    ),
    DaruratDispatchStep(
      title: 'AhliPeduli siaga',
      subtitle: 'Partner perawat melihat ringkasan medis.',
      icon: Icons.health_and_safety_outlined,
      tone: PkTone.blue,
    ),
    DaruratDispatchStep(
      title: 'Pemantauan aktif',
      subtitle: 'Status PeduliDarurat dapat diselesaikan atau dibatalkan.',
      icon: Icons.timeline_outlined,
      tone: PkTone.green,
    ),
  ];

  static DaruratTimelineEvent initialTimelineEvent() {
    return DaruratTimelineEvent(
      id: 'ready',
      title: 'PeduliDarurat siaga',
      description: 'Kontak darurat, ringkasan medis, dan bantuan siap.',
      time: _clock(DateTime.now()),
      tone: PkTone.brand,
      icon: Icons.health_and_safety_outlined,
    );
  }

  static DaruratTimelineEvent event({
    required String title,
    required String description,
    required PkTone tone,
    required IconData icon,
  }) {
    return DaruratTimelineEvent(
      id: 'event-${DateTime.now().microsecondsSinceEpoch}',
      title: title,
      description: description,
      time: _clock(DateTime.now()),
      tone: tone,
      icon: icon,
    );
  }

  static String _clock(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    final second = value.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }
}
