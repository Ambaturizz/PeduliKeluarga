import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/pk_design.dart';

const String noSymptomOption = 'Tidak ada keluhan';

const List<String> peduliCekSymptoms = [
  noSymptomOption,
  'Pusing',
  'Mual',
  'Lemas',
  'Sesak napas',
  'Nyeri dada',
  'Kesemutan',
  'Penglihatan kabur',
  'Demam',
  'Jatuh / terpeleset',
];

const Set<String> highRiskSymptoms = {
  'Sesak napas',
  'Nyeri dada',
  'Penglihatan kabur',
  'Jatuh / terpeleset',
};

const List<String> medicationOptions = [
  'Sudah semua',
  'Ada yang terlambat',
  'Ada yang terlewat',
  'Belum minum obat',
];

enum CekLevel {
  empty,
  ok,
  warn,
  danger,
}

extension CekLevelX on CekLevel {
  bool get isRisk => this == CekLevel.warn || this == CekLevel.danger;

  PkTone get tone {
    return switch (this) {
      CekLevel.empty => PkTone.gray,
      CekLevel.ok => PkTone.green,
      CekLevel.warn => PkTone.amber,
      CekLevel.danger => PkTone.red,
    };
  }
}

class CekEvaluation {
  const CekEvaluation({
    required this.label,
    required this.message,
    required this.level,
  });

  final String label;
  final String message;
  final CekLevel level;
}

class CekAiAnalysis {
  const CekAiAnalysis({
    required this.title,
    required this.message,
    required this.recommendations,
    required this.tone,
  });

  final String title;
  final String message;
  final List<String> recommendations;
  final PkTone tone;
}

class _NoChange {
  const _NoChange();
}

const _noChange = _NoChange();

class PeduliCekState {
  const PeduliCekState({
    this.systolic,
    this.diastolic,
    this.glucose,
    this.medicationAdherence,
    this.painScale,
    this.symptoms = const <String>{},
    this.note = '',
    this.submitted = false,
    this.submittedAt,
  });

  final int? systolic;
  final int? diastolic;
  final int? glucose;
  final String? medicationAdherence;
  final int? painScale;
  final Set<String> symptoms;
  final String note;
  final bool submitted;
  final DateTime? submittedAt;

  bool get hasBloodPressure => systolic != null && diastolic != null;

  bool get hasGlucose => glucose != null;

  bool get hasMedication => medicationAdherence != null;

  bool get hasPainScale => painScale != null;

  bool get hasSymptoms => symptoms.isNotEmpty;

  bool get canSubmit {
    return hasBloodPressure &&
        hasGlucose &&
        hasMedication &&
        hasPainScale &&
        hasSymptoms;
  }

  int get completedRequiredSections {
    var total = 0;

    if (hasBloodPressure) total++;
    if (hasGlucose) total++;
    if (hasMedication) total++;
    if (hasPainScale) total++;
    if (hasSymptoms) total++;

    return total;
  }

  int get totalRequiredSections => 5;

  double get progress {
    return completedRequiredSections / totalRequiredSections;
  }

  int get progressPercent => (progress * 100).round();

  CekEvaluation get bloodPressureEvaluation {
    final s = systolic;
    final d = diastolic;

    if (s == null || d == null) {
      return const CekEvaluation(
        label: 'Belum diisi',
        message: 'Masukkan tekanan darah sistolik dan diastolik.',
        level: CekLevel.empty,
      );
    }

    if (s >= 180 || d >= 120) {
      return const CekEvaluation(
        label: 'Sangat tinggi',
        message: 'Tekanan darah sangat tinggi. Perlu perhatian keluarga.',
        level: CekLevel.danger,
      );
    }

    if (s < 90 || d < 60) {
      return const CekEvaluation(
        label: 'Rendah',
        message: 'Tekanan darah lebih rendah dari rentang umum.',
        level: CekLevel.warn,
      );
    }

    if (s >= 140 || d >= 90) {
      return const CekEvaluation(
        label: 'Tinggi',
        message: 'Tekanan darah tinggi. Pantau ulang dan istirahat.',
        level: CekLevel.warn,
      );
    }

    if (s >= 130 || d >= 80) {
      return const CekEvaluation(
        label: 'Normal tinggi',
        message: 'Masih aman, tetapi sebaiknya tetap dipantau.',
        level: CekLevel.warn,
      );
    }

    return const CekEvaluation(
      label: 'Normal',
      message: 'Tekanan darah terlihat stabil.',
      level: CekLevel.ok,
    );
  }

  CekEvaluation get glucoseEvaluation {
    final value = glucose;

    if (value == null) {
      return const CekEvaluation(
        label: 'Belum diisi',
        message: 'Masukkan nilai gula darah hari ini.',
        level: CekLevel.empty,
      );
    }

    if (value < 70) {
      return const CekEvaluation(
        label: 'Rendah',
        message: 'Gula darah rendah. Perhatikan asupan makanan/minuman.',
        level: CekLevel.danger,
      );
    }

    if (value > 300) {
      return const CekEvaluation(
        label: 'Sangat tinggi',
        message: 'Gula darah sangat tinggi. Keluarga perlu diberi tahu.',
        level: CekLevel.danger,
      );
    }

    if (value > 180) {
      return const CekEvaluation(
        label: 'Tinggi',
        message: 'Gula darah tinggi. Pantau pola makan dan obat.',
        level: CekLevel.warn,
      );
    }

    return const CekEvaluation(
      label: 'Normal',
      message: 'Gula darah berada di rentang aman.',
      level: CekLevel.ok,
    );
  }

  CekEvaluation get medicationEvaluation {
    final value = medicationAdherence;

    if (value == null) {
      return const CekEvaluation(
        label: 'Belum dipilih',
        message: 'Pilih status minum obat hari ini.',
        level: CekLevel.empty,
      );
    }

    if (value == 'Sudah semua') {
      return const CekEvaluation(
        label: 'Patuh',
        message: 'Semua obat hari ini sudah diminum sesuai jadwal.',
        level: CekLevel.ok,
      );
    }

    if (value == 'Ada yang terlambat') {
      return const CekEvaluation(
        label: 'Terlambat',
        message: 'Ada obat yang diminum terlambat. Jadwal perlu dipantau.',
        level: CekLevel.warn,
      );
    }

    return const CekEvaluation(
      label: 'Terlewat',
      message: 'Ada obat yang belum diminum. Keluarga perlu mendapat ringkasan.',
      level: CekLevel.danger,
    );
  }

  CekEvaluation get painEvaluation {
    final value = painScale;

    if (value == null) {
      return const CekEvaluation(
        label: 'Belum dipilih',
        message: 'Pilih tingkat nyeri 0 sampai 10.',
        level: CekLevel.empty,
      );
    }

    if (value >= 7) {
      return CekEvaluation(
        label: 'Nyeri berat',
        message: 'Skala nyeri $value/10. Perlu perhatian lebih.',
        level: CekLevel.danger,
      );
    }

    if (value >= 4) {
      return CekEvaluation(
        label: 'Nyeri sedang',
        message: 'Skala nyeri $value/10. Pantau aktivitas dan istirahat.',
        level: CekLevel.warn,
      );
    }

    return CekEvaluation(
      label: 'Ringan',
      message: 'Skala nyeri $value/10. Tidak ada tanda nyeri berat.',
      level: CekLevel.ok,
    );
  }

  CekEvaluation get symptomsEvaluation {
    if (symptoms.isEmpty) {
      return const CekEvaluation(
        label: 'Belum dipilih',
        message: 'Pilih keluhan atau “Tidak ada keluhan”.',
        level: CekLevel.empty,
      );
    }

    if (symptoms.contains(noSymptomOption)) {
      return const CekEvaluation(
        label: 'Tidak ada keluhan',
        message: 'Tidak ada gejala yang dilaporkan hari ini.',
        level: CekLevel.ok,
      );
    }

    final hasHighRisk = symptoms.any(highRiskSymptoms.contains);

    if (hasHighRisk) {
      return const CekEvaluation(
        label: 'Perlu perhatian',
        message: 'Ada keluhan yang perlu dipantau keluarga.',
        level: CekLevel.danger,
      );
    }

    return const CekEvaluation(
      label: 'Keluhan ringan',
      message: 'Ada keluhan ringan. Pantau perkembangan hari ini.',
      level: CekLevel.warn,
    );
  }

  List<CekEvaluation> get evaluations {
    return [
      bloodPressureEvaluation,
      glucoseEvaluation,
      medicationEvaluation,
      painEvaluation,
      symptomsEvaluation,
    ];
  }

  bool get hasRisk {
    return evaluations.any((item) => item.level.isRisk);
  }

  CekLevel get overallLevel {
    if (evaluations.any((item) => item.level == CekLevel.danger)) {
      return CekLevel.danger;
    }

    if (evaluations.any((item) => item.level == CekLevel.warn)) {
      return CekLevel.warn;
    }

    if (canSubmit) return CekLevel.ok;

    return CekLevel.empty;
  }

  String get bloodPressureValue {
    if (!hasBloodPressure) return '—';
    return '$systolic/$diastolic mmHg';
  }

  String get glucoseValue {
    if (!hasGlucose) return '—';
    return '$glucose mg/dL';
  }

  String get medicationValue => medicationAdherence ?? '—';

  String get painValue {
    if (painScale == null) return '—';
    return '$painScale / 10';
  }

  String get symptomValue {
    if (symptoms.isEmpty) return '—';
    return symptoms.join(', ');
  }

  String get resultTitle {
    return switch (overallLevel) {
      CekLevel.danger => 'Laporan terkirim dengan catatan perhatian',
      CekLevel.warn => 'Laporan terkirim dengan catatan pemantauan',
      CekLevel.ok => 'Laporan terkirim — kondisi stabil',
      CekLevel.empty => 'PeduliCek belum lengkap',
    };
  }

  CekAiAnalysis get aiAnalysis {
    if (overallLevel == CekLevel.danger) {
      return const CekAiAnalysis(
        title: 'AI menemukan beberapa tanda yang perlu diperhatikan',
        message:
            'Ada nilai atau keluhan yang masuk kategori perhatian. Ringkasan sebaiknya dikirim ke keluarga agar kondisi dapat dipantau lebih cepat.',
        recommendations: [
          'Istirahat dan hindari aktivitas berat.',
          'Ulangi pengukuran setelah 10–15 menit bila memungkinkan.',
          'Hubungi keluarga bila keluhan terasa memburuk.',
        ],
        tone: PkTone.red,
      );
    }

    if (overallLevel == CekLevel.warn) {
      return const CekAiAnalysis(
        title: 'AI menyarankan pemantauan ringan hari ini',
        message:
            'Data hari ini belum menunjukkan kondisi darurat, tetapi ada beberapa nilai yang sebaiknya dipantau ulang.',
        recommendations: [
          'Minum air cukup dan makan teratur.',
          'Pastikan obat diminum sesuai jadwal berikutnya.',
          'Catat keluhan tambahan bila muncul.',
        ],
        tone: PkTone.amber,
      );
    }

    return const CekAiAnalysis(
      title: 'AI melihat kondisi hari ini cukup stabil',
      message:
          'Data PeduliCek hari ini terlihat baik. Pertahankan rutinitas minum obat, pola makan, dan aktivitas ringan.',
      recommendations: [
        'Lanjutkan jadwal obat seperti biasa.',
        'Tetap isi PeduliCek setiap hari.',
        'Bagikan ringkasan ke keluarga bila dibutuhkan.',
      ],
      tone: PkTone.green,
    );
  }

  PeduliCekState copyWith({
    Object? systolic = _noChange,
    Object? diastolic = _noChange,
    Object? glucose = _noChange,
    Object? medicationAdherence = _noChange,
    Object? painScale = _noChange,
    Set<String>? symptoms,
    String? note,
    bool? submitted,
    Object? submittedAt = _noChange,
  }) {
    return PeduliCekState(
      systolic:
          identical(systolic, _noChange) ? this.systolic : systolic as int?,
      diastolic:
          identical(diastolic, _noChange) ? this.diastolic : diastolic as int?,
      glucose: identical(glucose, _noChange) ? this.glucose : glucose as int?,
      medicationAdherence: identical(medicationAdherence, _noChange)
          ? this.medicationAdherence
          : medicationAdherence as String?,
      painScale:
          identical(painScale, _noChange) ? this.painScale : painScale as int?,
      symptoms: symptoms ?? this.symptoms,
      note: note ?? this.note,
      submitted: submitted ?? this.submitted,
      submittedAt: identical(submittedAt, _noChange)
          ? this.submittedAt
          : submittedAt as DateTime?,
    );
  }
}

final peduliCekProvider =
    NotifierProvider<PeduliCekController, PeduliCekState>(
  PeduliCekController.new,
);

class PeduliCekController extends Notifier<PeduliCekState> {
  @override
  PeduliCekState build() {
    return const PeduliCekState();
  }

  void setSystolic(int? value) {
    state = state.copyWith(
      systolic: value,
      submitted: false,
      submittedAt: null,
    );
  }

  void setDiastolic(int? value) {
    state = state.copyWith(
      diastolic: value,
      submitted: false,
      submittedAt: null,
    );
  }

  void setGlucose(int? value) {
    state = state.copyWith(
      glucose: value,
      submitted: false,
      submittedAt: null,
    );
  }

  void setMedicationAdherence(String value) {
    state = state.copyWith(
      medicationAdherence: value,
      submitted: false,
      submittedAt: null,
    );
  }

  void setPainScale(int value) {
    state = state.copyWith(
      painScale: value,
      submitted: false,
      submittedAt: null,
    );
  }

  void toggleSymptom(String value) {
    final next = Set<String>.from(state.symptoms);

    if (value == noSymptomOption) {
      if (next.contains(noSymptomOption)) {
        next.clear();
      } else {
        next
          ..clear()
          ..add(noSymptomOption);
      }

      state = state.copyWith(
        symptoms: next,
        submitted: false,
        submittedAt: null,
      );
      return;
    }

    next.remove(noSymptomOption);

    if (next.contains(value)) {
      next.remove(value);
    } else {
      next.add(value);
    }

    state = state.copyWith(
      symptoms: next,
      submitted: false,
      submittedAt: null,
    );
  }

  void setNote(String value) {
    state = state.copyWith(
      note: value,
      submitted: false,
      submittedAt: null,
    );
  }

  bool submit() {
    if (!state.canSubmit) return false;

    state = state.copyWith(
      submitted: true,
      submittedAt: DateTime.now(),
    );

    return true;
  }

  void reset() {
    state = const PeduliCekState();
  }
}
