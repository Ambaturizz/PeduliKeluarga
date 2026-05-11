
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/pk_design.dart';
import '../data/medication_dummy_data.dart';

class PeduliObatState {
  const PeduliObatState({
    required this.medications,
    required this.schedules,
    required this.logs,
    required this.reminders,
    required this.takenScheduleIds,
    this.reminderEnabled = true,
  });

  final List<MedicationModel> medications;
  final List<MedicationScheduleModel> schedules;
  final List<MedicationLogModel> logs;
  final List<MedicationReminderModel> reminders;
  final Set<String> takenScheduleIds;
  final bool reminderEnabled;

  int get totalSchedules => schedules.length;

  int get completedSchedules => takenScheduleIds.length;

  int get pendingSchedules => totalSchedules - completedSchedules;

  double get dailyProgress {
    if (totalSchedules == 0) return 0;
    return completedSchedules / totalSchedules;
  }

  int get adherencePercent => (dailyProgress * 100).round();

  List<MedicationModel> get lowStockMedications {
    return medications.where((item) => item.isLowStock).toList();
  }

  int get lowStockCount => lowStockMedications.length;

  MedicationScheduleModel? get nextSchedule {
    for (final item in schedules) {
      if (!takenScheduleIds.contains(item.id)) return item;
    }

    return null;
  }

  String get nextScheduleLabel {
    final next = nextSchedule;
    if (next == null) return 'Selesai';
    return next.time;
  }

  String get adherenceLabel {
    if (adherencePercent == 100) return 'Sempurna';
    if (adherencePercent >= 70) return 'Baik';
    if (adherencePercent >= 40) return 'Perlu pantau';
    return 'Rendah';
  }

  PkTone get adherenceTone {
    if (adherencePercent == 100) return PkTone.green;
    if (adherencePercent >= 70) return PkTone.brand;
    if (adherencePercent >= 40) return PkTone.amber;
    return PkTone.red;
  }

  PeduliObatState copyWith({
    List<MedicationModel>? medications,
    List<MedicationScheduleModel>? schedules,
    List<MedicationLogModel>? logs,
    List<MedicationReminderModel>? reminders,
    Set<String>? takenScheduleIds,
    bool? reminderEnabled,
  }) {
    return PeduliObatState(
      medications: medications ?? this.medications,
      schedules: schedules ?? this.schedules,
      logs: logs ?? this.logs,
      reminders: reminders ?? this.reminders,
      takenScheduleIds: takenScheduleIds ?? this.takenScheduleIds,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
    );
  }
}

final peduliObatProvider =
    NotifierProvider<PeduliObatController, PeduliObatState>(
  PeduliObatController.new,
);

class PeduliObatController extends Notifier<PeduliObatState> {
  @override
  PeduliObatState build() {
    final initialTaken = MedicationDummyData.schedules
        .where((item) => item.initialTaken)
        .map((item) => item.id)
        .toSet();

    return PeduliObatState(
      medications: MedicationDummyData.medications,
      schedules: MedicationDummyData.schedules,
      logs: MedicationDummyData.logs,
      reminders: MedicationDummyData.reminders,
      takenScheduleIds: initialTaken,
    );
  }

  void toggleReminder() {
    state = state.copyWith(
      reminderEnabled: !state.reminderEnabled,
    );
  }

  void markScheduleTaken(String scheduleId) {
    if (state.takenScheduleIds.contains(scheduleId)) return;

    final schedule = state.schedules.firstWhere(
      (item) => item.id == scheduleId,
    );

    final nextTaken = {
      ...state.takenScheduleIds,
      scheduleId,
    };

    final nextLogs = [
      MedicationLogModel(
        id: 'log-${DateTime.now().millisecondsSinceEpoch}',
        title: '${schedule.title} ditandai diminum',
        copy: 'Status obat diperbarui melalui PeduliObat.',
        time: _clock(DateTime.now()),
        tone: PkTone.green,
      ),
      ...state.logs,
    ];

    state = state.copyWith(
      takenScheduleIds: nextTaken,
      logs: nextLogs,
    );
  }

  void undoSchedule(String scheduleId) {
    if (!state.takenScheduleIds.contains(scheduleId)) return;

    final schedule = state.schedules.firstWhere(
      (item) => item.id == scheduleId,
    );

    final nextTaken = Set<String>.from(state.takenScheduleIds)
      ..remove(scheduleId);

    final nextLogs = [
      MedicationLogModel(
        id: 'log-${DateTime.now().millisecondsSinceEpoch}',
        title: '${schedule.title} dibatalkan',
        copy: 'Status obat dikembalikan menjadi menunggu.',
        time: _clock(DateTime.now()),
        tone: PkTone.amber,
      ),
      ...state.logs,
    ];

    state = state.copyWith(
      takenScheduleIds: nextTaken,
      logs: nextLogs,
    );
  }

  void reorderMedication(String medicationId) {
    final medication = state.medications.firstWhere(
      (item) => item.id == medicationId,
    );

    final updated = medication.copyWith(
      stockTablets: medication.stockTablets + 30,
      stockDays: medication.stockDays + 30,
    );

    final nextMedications = state.medications.map((item) {
      if (item.id == medicationId) return updated;
      return item;
    }).toList();

    final nextLogs = [
      MedicationLogModel(
        id: 'log-${DateTime.now().millisecondsSinceEpoch}',
        title: '${medication.name} dipesan ulang',
        copy: 'Permintaan reorder via PeduliAntar berhasil dibuat.',
        time: _clock(DateTime.now()),
        tone: PkTone.brand,
      ),
      ...state.logs,
    ];

    state = state.copyWith(
      medications: nextMedications,
      logs: nextLogs,
    );
  }

  void resetDemo() {
    final initialTaken = MedicationDummyData.schedules
        .where((item) => item.initialTaken)
        .map((item) => item.id)
        .toSet();

    state = PeduliObatState(
      medications: MedicationDummyData.medications,
      schedules: MedicationDummyData.schedules,
      logs: MedicationDummyData.logs,
      reminders: MedicationDummyData.reminders,
      takenScheduleIds: initialTaken,
    );
  }

  String _clock(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}
