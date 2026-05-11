import 'package:flutter/material.dart';

import '../../../core/theme/pk_design.dart';

enum EmergencyStatus {
  standby,
  active,
  dispatching,
  notified,
  resolved,
  cancelled;

  String get label {
    return switch (this) {
      EmergencyStatus.standby => 'Standby',
      EmergencyStatus.active => 'Aktif',
      EmergencyStatus.dispatching => 'Mengirim bantuan',
      EmergencyStatus.notified => 'Keluarga diberi tahu',
      EmergencyStatus.resolved => 'Selesai',
      EmergencyStatus.cancelled => 'Dibatalkan',
    };
  }

  String get description {
    return switch (this) {
      EmergencyStatus.standby => 'Sistem siap digunakan kapan saja.',
      EmergencyStatus.active => 'Alert sedang aktif. Countdown berjalan.',
      EmergencyStatus.dispatching => 'Notifikasi dan dispatch sedang diproses.',
      EmergencyStatus.notified => 'Kontak darurat sudah menerima simulasi alert.',
      EmergencyStatus.resolved => 'Kejadian darurat sudah ditandai selesai.',
      EmergencyStatus.cancelled => 'Alert dibatalkan sebelum dispatch penuh.',
    };
  }

  PkTone get tone {
    return switch (this) {
      EmergencyStatus.standby => PkTone.brand,
      EmergencyStatus.active => PkTone.red,
      EmergencyStatus.dispatching => PkTone.amber,
      EmergencyStatus.notified => PkTone.blue,
      EmergencyStatus.resolved => PkTone.green,
      EmergencyStatus.cancelled => PkTone.gray,
    };
  }

  IconData get icon {
    return switch (this) {
      EmergencyStatus.standby => Icons.health_and_safety_outlined,
      EmergencyStatus.active => Icons.emergency_outlined,
      EmergencyStatus.dispatching => Icons.local_shipping_outlined,
      EmergencyStatus.notified => Icons.notifications_active_outlined,
      EmergencyStatus.resolved => Icons.check_circle_outline_rounded,
      EmergencyStatus.cancelled => Icons.cancel_outlined,
    };
  }
}

class EmergencyContact {
  const EmergencyContact({
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

  EmergencyContact copyWith({
    bool? notified,
  }) {
    return EmergencyContact(
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

class EmergencyTimelineEvent {
  const EmergencyTimelineEvent({
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

class EmergencyMedicalSummary {
  const EmergencyMedicalSummary({
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

class EmergencyDispatchStep {
  const EmergencyDispatchStep({
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

final class EmergencyMockData {
  const EmergencyMockData._();

  static const contacts = [
    EmergencyContact(
      id: 'reza',
      name: 'Reza Dwi Putra',
      role: 'Anak utama',
      phone: '+62 812 6615 223',
      responseTime: '± 2 menit',
      icon: Icons.family_restroom_rounded,
      tone: PkTone.brand,
    ),
    EmergencyContact(
      id: 'nina',
      name: 'Nina Putri',
      role: 'Anak kedua',
      phone: '+62 813 4400 119',
      responseTime: '± 5 menit',
      icon: Icons.person_outline_rounded,
      tone: PkTone.blue,
    ),
    EmergencyContact(
      id: 'ahli',
      name: 'AhliPeduli Siaga',
      role: 'Homecare partner',
      phone: '1500-921',
      responseTime: '± 10 menit',
      icon: Icons.health_and_safety_outlined,
      tone: PkTone.red,
    ),
  ];

  static const medicalSummary = EmergencyMedicalSummary(
    name: 'Bapak Purwanto',
    age: 68,
    conditions: [
      'Hipertensi',
      'Diabetes Tipe 2',
      'Kolesterol',
    ],
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
    EmergencyDispatchStep(
      title: 'Alert dibuat',
      subtitle: 'Sinyal darurat diterima sistem PeduliKeluarga.',
      icon: Icons.emergency_outlined,
      tone: PkTone.red,
    ),
    EmergencyDispatchStep(
      title: 'Keluarga dihubungi',
      subtitle: 'Reza dan Nina menerima simulasi notifikasi.',
      icon: Icons.notifications_active_outlined,
      tone: PkTone.amber,
    ),
    EmergencyDispatchStep(
      title: 'AhliPeduli standby',
      subtitle: 'Partner homecare melihat ringkasan medis.',
      icon: Icons.health_and_safety_outlined,
      tone: PkTone.blue,
    ),
    EmergencyDispatchStep(
      title: 'Pemantauan aktif',
      subtitle: 'Status emergency dapat diselesaikan atau dibatalkan.',
      icon: Icons.timeline_outlined,
      tone: PkTone.green,
    ),
  ];

  static EmergencyTimelineEvent initialTimelineEvent() {
    return EmergencyTimelineEvent(
      id: 'ready',
      title: 'Emergency system standby',
      description: 'Kontak darurat, ringkasan medis, dan dispatch siap.',
      time: _clock(DateTime.now()),
      tone: PkTone.brand,
      icon: Icons.health_and_safety_outlined,
    );
  }

  static EmergencyTimelineEvent event({
    required String title,
    required String description,
    required PkTone tone,
    required IconData icon,
  }) {
    return EmergencyTimelineEvent(
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