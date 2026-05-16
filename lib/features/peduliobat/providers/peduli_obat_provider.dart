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
    this.generatedMonthlyEntries = const <GeneratedMedicationEntry>[],
    this.generatedAt,
    this.reminderEnabled = true,
  });

  final List<MedicationModel> medications;
  final List<MedicationScheduleModel> schedules;
  final List<MedicationLogModel> logs;
  final List<MedicationReminderModel> reminders;
  final Set<String> takenScheduleIds;
  final List<GeneratedMedicationEntry> generatedMonthlyEntries;
  final DateTime? generatedAt;
  final bool reminderEnabled;

  bool get hasGeneratedSchedule => generatedMonthlyEntries.isNotEmpty;

  int get generatedDayCount {
    return generatedMonthlyEntries
        .map((item) => _dateKey(item.date))
        .toSet()
        .length;
  }

  List<GeneratedMedicationEntry> get generatedTodayEntries {
    final now = DateTime.now();

    return generatedMonthlyEntries
        .where((item) => _isSameDate(item.date, now))
        .toList();
  }

  List<MedicationScheduleModel> get effectiveSchedules {
    if (!hasGeneratedSchedule) return schedules;

    final todayEntries = generatedTodayEntries;
    if (todayEntries.isEmpty) return schedules;

    return _groupGeneratedEntries(todayEntries, takenScheduleIds);
  }

  int get totalSchedules => effectiveSchedules.length;

  int get completedSchedules {
    final todayIds = effectiveSchedules.map((item) => item.id).toSet();

    return takenScheduleIds.where(todayIds.contains).length;
  }

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
    for (final item in effectiveSchedules) {
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

  String get calendarExportText {
    final entries = generatedMonthlyEntries.isNotEmpty
        ? generatedMonthlyEntries
        : MedicationDummyData.generateMonthlySchedule(
            startDate: DateTime.now(),
          );

    final grouped = <String, List<GeneratedMedicationEntry>>{};

    for (final entry in entries) {
      final key = '${_dateKey(entry.date)}-${entry.time}';
      grouped.putIfAbsent(key, () => <GeneratedMedicationEntry>[]).add(entry);
    }

    final keys = grouped.keys.toList()..sort();
    final buffer = StringBuffer()
      ..writeln('BEGIN:VCALENDAR')
      ..writeln('VERSION:2.0')
      ..writeln('PRODID:-//PeduliKeluarga//PeduliObat//ID')
      ..writeln('CALSCALE:GREGORIAN')
      ..writeln('METHOD:PUBLISH');

    for (final key in keys) {
      final items = grouped[key]!;
      items.sort((a, b) => a.medicationName.compareTo(b.medicationName));

      final first = items.first;
      final start = _entryDateTime(first);
      final end = start.add(const Duration(minutes: 15));
      final title = items.map((item) => '${item.medicationName} ${item.dose}').join(' + ');
      final description = items
          .map((item) => '${item.medicationName} ${item.dose}: ${item.instruction}')
          .join('\\n');

      buffer
        ..writeln('BEGIN:VEVENT')
        ..writeln("UID:${key.replaceAll(':', '')}@pedulikeluarga.local")
        ..writeln('DTSTAMP:${_icsDateTime(DateTime.now())}')
        ..writeln('DTSTART:${_icsDateTime(start)}')
        ..writeln('DTEND:${_icsDateTime(end)}')
        ..writeln('SUMMARY:${_icsEscape('PeduliObat - $title')}')
        ..writeln('DESCRIPTION:${_icsEscape(description)}')
        ..writeln('END:VEVENT');
    }

    buffer.writeln('END:VCALENDAR');
    return buffer.toString();
  }

  PeduliObatState copyWith({
    List<MedicationModel>? medications,
    List<MedicationScheduleModel>? schedules,
    List<MedicationLogModel>? logs,
    List<MedicationReminderModel>? reminders,
    Set<String>? takenScheduleIds,
    List<GeneratedMedicationEntry>? generatedMonthlyEntries,
    DateTime? generatedAt,
    bool? reminderEnabled,
  }) {
    return PeduliObatState(
      medications: medications ?? this.medications,
      schedules: schedules ?? this.schedules,
      logs: logs ?? this.logs,
      reminders: reminders ?? this.reminders,
      takenScheduleIds: takenScheduleIds ?? this.takenScheduleIds,
      generatedMonthlyEntries:
          generatedMonthlyEntries ?? this.generatedMonthlyEntries,
      generatedAt: generatedAt ?? this.generatedAt,
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

  void generateMonthlySchedule() {
    final now = DateTime.now();
    final generated = MedicationDummyData.generateMonthlySchedule(
      startDate: now,
      days: 30,
    );

    final nextLogs = [
      MedicationLogModel(
        id: 'log-${now.millisecondsSinceEpoch}',
        title: 'Jadwal obat 1 bulan berhasil dibuat',
        copy:
            'PeduliObat membuat jadwal dari dataset penyakit dan resep dokter. Tampilan utama tetap menampilkan jadwal hari ini.',
        time: _clock(now),
        tone: PkTone.brand,
      ),
      ...state.logs,
    ];

    state = state.copyWith(
      generatedMonthlyEntries: generated,
      generatedAt: now,
      takenScheduleIds: <String>{},
      logs: nextLogs,
    );
  }

  void toggleReminder() {
    state = state.copyWith(
      reminderEnabled: !state.reminderEnabled,
    );
  }

  void markScheduleTaken(String scheduleId) {
    if (state.takenScheduleIds.contains(scheduleId)) return;

    final schedule = state.effectiveSchedules.firstWhere(
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

    final schedule = state.effectiveSchedules.firstWhere(
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

  void requestMedicationPurchase(String medicationId) {
    final medication = state.medications.firstWhere(
      (item) => item.id == medicationId,
    );

    final nextLogs = [
      MedicationLogModel(
        id: 'log-${DateTime.now().millisecondsSinceEpoch}',
        title: 'Permintaan pembelian ${medication.name} dibuat',
        copy: 'Status: Menunggu konfirmasi pendamping melalui PeduliAntar.',
        time: _clock(DateTime.now()),
        tone: PkTone.amber,
      ),
      ...state.logs,
    ];

    state = state.copyWith(logs: nextLogs);
  }

  void reorderMedication(String medicationId) {
    requestMedicationPurchase(medicationId);
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

List<MedicationScheduleModel> _groupGeneratedEntries(
  List<GeneratedMedicationEntry> entries,
  Set<String> takenScheduleIds,
) {
  final grouped = <String, List<GeneratedMedicationEntry>>{};

  for (final entry in entries) {
    grouped.putIfAbsent(entry.time, () => <GeneratedMedicationEntry>[]).add(entry);
  }

  final times = grouped.keys.toList()..sort();

  String? firstPendingId;

  for (final time in times) {
    final scheduleId = _generatedScheduleId(grouped[time]!);
    if (!takenScheduleIds.contains(scheduleId)) {
      firstPendingId = scheduleId;
      break;
    }
  }

  return [
    for (final time in times)
      _buildGeneratedSchedule(
        time: time,
        entries: grouped[time]!,
        firstPendingId: firstPendingId,
      ),
  ];
}

MedicationScheduleModel _buildGeneratedSchedule({
  required String time,
  required List<GeneratedMedicationEntry> entries,
  required String? firstPendingId,
}) {
  entries.sort((a, b) => a.medicationName.compareTo(b.medicationName));

  final id = _generatedScheduleId(entries);
  final title = entries.map((item) => '${item.medicationName} ${item.dose}').join(' + ');
  final diseases = entries.map((item) => item.disease).toSet().join(', ');
  final totalTablets = entries.fold<int>(
    0,
    (previous, item) => previous + item.tabletsPerDose,
  );
  final instruction = entries.map((item) => item.instruction).toSet().join(' ');
  final medicationIds = entries.map((item) => item.medicationId).toSet().toList();

  return MedicationScheduleModel(
    id: id,
    time: time,
    title: title,
    copy: '$instruction · $totalTablets tablet · Dataset: $diseases',
    medicationIds: medicationIds,
    initialTaken: false,
    isNext: id == firstPendingId,
  );
}

String _generatedScheduleId(List<GeneratedMedicationEntry> entries) {
  final first = entries.first;
  return "generated-${_dateKey(first.date)}-${first.time.replaceAll(':', '')}";
}

bool _isSameDate(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

String _dateKey(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');

  return '${value.year}$month$day';
}

DateTime _entryDateTime(GeneratedMedicationEntry entry) {
  final parts = entry.time.split(':');
  final hour = int.tryParse(parts.first) ?? 0;
  final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;

  return DateTime(
    entry.date.year,
    entry.date.month,
    entry.date.day,
    hour,
    minute,
  );
}

String _icsDateTime(DateTime value) {
  final year = value.year.toString().padLeft(4, '0');
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  final second = value.second.toString().padLeft(2, '0');

  return '$year$month${day}T$hour$minute$second';
}

String _icsEscape(String value) {
  return value
      .replaceAll('\\', '\\\\')
      .replaceAll('\n', r'\n')
      .replaceAll(',', r'\,')
      .replaceAll(';', r'\;');
}
