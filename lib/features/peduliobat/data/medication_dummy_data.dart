import 'package:flutter/material.dart';

import '../../../core/theme/pk_design.dart';

enum MedicationCategory {
  hypertension,
  diabetes,
  cholesterol,
  supplement;

  String get label {
    return switch (this) {
      MedicationCategory.hypertension => 'Hipertensi',
      MedicationCategory.diabetes => 'Diabetes',
      MedicationCategory.cholesterol => 'Kolesterol',
      MedicationCategory.supplement => 'Suplemen',
    };
  }

  PkTone get tone {
    return switch (this) {
      MedicationCategory.hypertension => PkTone.brand,
      MedicationCategory.diabetes => PkTone.blue,
      MedicationCategory.cholesterol => PkTone.red,
      MedicationCategory.supplement => PkTone.green,
    };
  }
}

class MedicationModel {
  const MedicationModel({
    required this.id,
    required this.name,
    required this.dose,
    required this.detail,
    required this.category,
    required this.stockTablets,
    required this.stockDays,
    required this.maxStockTablets,
    required this.lowStockThresholdDays,
    required this.instructions,
  });

  final String id;
  final String name;
  final String dose;
  final String detail;
  final MedicationCategory category;
  final int stockTablets;
  final int stockDays;
  final int maxStockTablets;
  final int lowStockThresholdDays;
  final String instructions;

  bool get isLowStock => stockDays <= lowStockThresholdDays;

  int get stockPercent {
    final value = (stockTablets / maxStockTablets * 100).round();
    return value.clamp(0, 100);
  }

  String get stockLabel => '$stockTablets tablet · $stockDays hari';

  PkTone get stockTone {
    if (isLowStock) return PkTone.red;
    if (stockPercent <= 45) return PkTone.amber;
    return PkTone.green;
  }

  MedicationModel copyWith({
    int? stockTablets,
    int? stockDays,
  }) {
    return MedicationModel(
      id: id,
      name: name,
      dose: dose,
      detail: detail,
      category: category,
      stockTablets: stockTablets ?? this.stockTablets,
      stockDays: stockDays ?? this.stockDays,
      maxStockTablets: maxStockTablets,
      lowStockThresholdDays: lowStockThresholdDays,
      instructions: instructions,
    );
  }
}

class MedicationScheduleModel {
  const MedicationScheduleModel({
    required this.id,
    required this.time,
    required this.title,
    required this.copy,
    required this.medicationIds,
    required this.initialTaken,
    required this.isNext,
  });

  final String id;
  final String time;
  final String title;
  final String copy;
  final List<String> medicationIds;
  final bool initialTaken;
  final bool isNext;
}

class MedicationLogModel {
  const MedicationLogModel({
    required this.id,
    required this.title,
    required this.copy,
    required this.time,
    required this.tone,
  });

  final String id;
  final String title;
  final String copy;
  final String time;
  final PkTone tone;
}

class MedicationReminderModel {
  const MedicationReminderModel({
    required this.title,
    required this.copy,
    required this.time,
    required this.tone,
    required this.icon,
  });

  final String title;
  final String copy;
  final String time;
  final PkTone tone;
  final IconData icon;
}

class MedicationPrescriptionPreset {
  const MedicationPrescriptionPreset({
    required this.medicationId,
    required this.disease,
    required this.times,
    required this.durationDays,
    required this.tabletsPerDose,
    required this.instruction,
  });

  final String medicationId;
  final String disease;
  final List<String> times;
  final int durationDays;
  final int tabletsPerDose;
  final String instruction;
}

class GeneratedMedicationEntry {
  const GeneratedMedicationEntry({
    required this.id,
    required this.date,
    required this.time,
    required this.medicationId,
    required this.medicationName,
    required this.dose,
    required this.disease,
    required this.instruction,
    required this.tabletsPerDose,
  });

  final String id;
  final DateTime date;
  final String time;
  final String medicationId;
  final String medicationName;
  final String dose;
  final String disease;
  final String instruction;
  final int tabletsPerDose;
}

final class MedicationDummyData {
  const MedicationDummyData._();

  static const List<MedicationModel> medications = [
    MedicationModel(
      id: 'amlodipin',
      name: 'Amlodipin',
      dose: '5mg',
      detail: 'Pagi · sesudah sarapan',
      category: MedicationCategory.hypertension,
      stockTablets: 28,
      stockDays: 28,
      maxStockTablets: 30,
      lowStockThresholdDays: 7,
      instructions: 'Minum 1 tablet sesudah sarapan.',
    ),
    MedicationModel(
      id: 'metformin',
      name: 'Metformin',
      dose: '500mg',
      detail: 'Pagi, siang, malam · sesudah makan',
      category: MedicationCategory.diabetes,
      stockTablets: 72,
      stockDays: 24,
      maxStockTablets: 90,
      lowStockThresholdDays: 7,
      instructions: 'Minum 1 tablet setiap sesudah makan.',
    ),
    MedicationModel(
      id: 'simvastatin',
      name: 'Simvastatin',
      dose: '20mg',
      detail: 'Malam · sesudah makan',
      category: MedicationCategory.cholesterol,
      stockTablets: 5,
      stockDays: 5,
      maxStockTablets: 30,
      lowStockThresholdDays: 7,
      instructions: 'Minum 1 tablet pada malam hari.',
    ),
  ];

  static const List<MedicationPrescriptionPreset> diseasePrescriptionDataset = [
    MedicationPrescriptionPreset(
      medicationId: 'amlodipin',
      disease: 'Hipertensi',
      times: ['07:00'],
      durationDays: 30,
      tabletsPerDose: 1,
      instruction: 'Sesudah sarapan sesuai resep dokter.',
    ),
    MedicationPrescriptionPreset(
      medicationId: 'metformin',
      disease: 'Diabetes',
      times: ['07:00', '13:00', '19:00'],
      durationDays: 30,
      tabletsPerDose: 1,
      instruction: 'Sesudah makan pagi, siang, dan malam.',
    ),
    MedicationPrescriptionPreset(
      medicationId: 'simvastatin',
      disease: 'Kolesterol',
      times: ['19:00'],
      durationDays: 30,
      tabletsPerDose: 1,
      instruction: 'Malam hari sesudah makan.',
    ),
  ];

  static List<GeneratedMedicationEntry> generateMonthlySchedule({
    required DateTime startDate,
    int days = 30,
  }) {
    final normalizedStart = DateTime(startDate.year, startDate.month, startDate.day);
    final entries = <GeneratedMedicationEntry>[];

    for (var dayIndex = 0; dayIndex < days; dayIndex++) {
      final date = normalizedStart.add(Duration(days: dayIndex));

      for (final preset in diseasePrescriptionDataset) {
        final medication = medications.firstWhere(
          (item) => item.id == preset.medicationId,
        );

        for (final time in preset.times) {
          final dateKey =
              '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';

          entries.add(
            GeneratedMedicationEntry(
              id: "generated-$dateKey-${time.replaceAll(':', '')}-${medication.id}",
              date: date,
              time: time,
              medicationId: medication.id,
              medicationName: medication.name,
              dose: medication.dose,
              disease: preset.disease,
              instruction: preset.instruction,
              tabletsPerDose: preset.tabletsPerDose,
            ),
          );
        }
      }
    }

    entries.sort((a, b) {
      final dateCompare = a.date.compareTo(b.date);
      if (dateCompare != 0) return dateCompare;
      return a.time.compareTo(b.time);
    });

    return entries;
  }

  static const List<MedicationScheduleModel> schedules = [
    MedicationScheduleModel(
      id: 'morning',
      time: '07:00',
      title: 'Amlodipin 5mg + Metformin 500mg',
      copy: 'Sesudah sarapan · 2 tablet',
      medicationIds: ['amlodipin', 'metformin'],
      initialTaken: true,
      isNext: false,
    ),
    MedicationScheduleModel(
      id: 'afternoon',
      time: '13:00',
      title: 'Metformin 500mg',
      copy: 'Sesudah makan siang · 1 tablet',
      medicationIds: ['metformin'],
      initialTaken: false,
      isNext: true,
    ),
    MedicationScheduleModel(
      id: 'night',
      time: '19:00',
      title: 'Simvastatin 20mg + Metformin 500mg',
      copy: 'Sesudah makan malam · 2 tablet',
      medicationIds: ['simvastatin', 'metformin'],
      initialTaken: false,
      isNext: false,
    ),
  ];

  static const List<MedicationLogModel> logs = [
    MedicationLogModel(
      id: 'log-1',
      title: 'Obat pagi sudah diminum',
      copy: 'Amlodipin dan Metformin tercatat pukul 07:32.',
      time: '07:32',
      tone: PkTone.green,
    ),
    MedicationLogModel(
      id: 'log-2',
      title: 'Simvastatin hampir habis',
      copy: 'Sisa 5 tablet. Disarankan pesan ulang hari ini.',
      time: 'Kemarin',
      tone: PkTone.red,
    ),
    MedicationLogModel(
      id: 'log-3',
      title: 'Metformin siang pernah terlambat',
      copy: 'Reminder terkirim ke Bapak dan Reza.',
      time: '2 hari lalu',
      tone: PkTone.amber,
    ),
  ];

  static const List<MedicationReminderModel> reminders = [
    MedicationReminderModel(
      title: 'Reminder berikutnya',
      copy: 'Metformin 500mg sesudah makan siang.',
      time: '13:00',
      tone: PkTone.amber,
      icon: Icons.notifications_active_outlined,
    ),
    MedicationReminderModel(
      title: 'Reminder malam',
      copy: 'Simvastatin 20mg dan Metformin 500mg.',
      time: '19:00',
      tone: PkTone.brand,
      icon: Icons.alarm_outlined,
    ),
  ];
}
