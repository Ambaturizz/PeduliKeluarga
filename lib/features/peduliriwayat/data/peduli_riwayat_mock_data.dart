import '../domain/health_history_models.dart';

final bloodPressureHistory = <BloodPressureRecord>[
  BloodPressureRecord(date: DateTime(2026, 5, 5, 7, 30), systolic: 132, diastolic: 84, pulse: 78, statusLabel: 'Agak tinggi'),
  BloodPressureRecord(date: DateTime(2026, 5, 6, 7, 20), systolic: 128, diastolic: 82, pulse: 76, statusLabel: 'Terkendali'),
  BloodPressureRecord(date: DateTime(2026, 5, 7, 7, 35), systolic: 136, diastolic: 86, pulse: 82, statusLabel: 'Pantau'),
  BloodPressureRecord(date: DateTime(2026, 5, 8, 7, 15), systolic: 130, diastolic: 83, pulse: 77, statusLabel: 'Terkendali'),
  BloodPressureRecord(date: DateTime(2026, 5, 9, 7, 25), systolic: 126, diastolic: 80, pulse: 75, statusLabel: 'Baik'),
  BloodPressureRecord(date: DateTime(2026, 5, 10, 7, 30), systolic: 129, diastolic: 81, pulse: 76, statusLabel: 'Terkendali'),
  BloodPressureRecord(date: DateTime(2026, 5, 11, 7, 10), systolic: 124, diastolic: 79, pulse: 74, statusLabel: 'Baik'),
];

final bloodSugarHistory = <BloodSugarRecord>[
  BloodSugarRecord(date: DateTime(2026, 5, 5, 8, 0), mgdl: 154, timingLabel: 'Puasa', statusLabel: 'Tinggi ringan'),
  BloodSugarRecord(date: DateTime(2026, 5, 6, 8, 0), mgdl: 145, timingLabel: 'Puasa', statusLabel: 'Pantau'),
  BloodSugarRecord(date: DateTime(2026, 5, 7, 8, 0), mgdl: 162, timingLabel: 'Puasa', statusLabel: 'Tinggi'),
  BloodSugarRecord(date: DateTime(2026, 5, 8, 8, 0), mgdl: 138, timingLabel: 'Puasa', statusLabel: 'Membaik'),
  BloodSugarRecord(date: DateTime(2026, 5, 9, 8, 0), mgdl: 132, timingLabel: 'Puasa', statusLabel: 'Membaik'),
  BloodSugarRecord(date: DateTime(2026, 5, 10, 8, 0), mgdl: 128, timingLabel: 'Puasa', statusLabel: 'Terkendali'),
  BloodSugarRecord(date: DateTime(2026, 5, 11, 8, 0), mgdl: 126, timingLabel: 'Puasa', statusLabel: 'Terkendali'),
];

final healthSummaryMetrics = <HealthSummaryMetric>[
  HealthSummaryMetric(
    title: 'Tekanan darah',
    value: '124/79',
    unit: 'mmHg',
    caption: 'Rata-rata 7 hari turun 5 poin sistolik.',
    trendLabel: 'Membaik 4%',
    score: 0.82,
    sparklineValues: bloodPressureHistory.map((record) => record.systolic.toDouble()).toList(),
    severity: HealthTrendSeverity.improving,
  ),
  HealthSummaryMetric(
    title: 'Gula darah puasa',
    value: '126',
    unit: 'mg/dL',
    caption: 'Masih perlu kontrol pola makan malam.',
    trendLabel: 'Turun 18 mg/dL',
    score: 0.68,
    sparklineValues: bloodSugarHistory.map((record) => record.mgdl.toDouble()).toList(),
    severity: HealthTrendSeverity.attention,
  ),
  const HealthSummaryMetric(
    title: 'Kepatuhan obat',
    value: '94',
    unit: '%',
    caption: '1 dosis terlambat minggu ini.',
    trendLabel: 'Stabil',
    score: 0.94,
    sparklineValues: [88.0, 92.0, 96.0, 94.0, 98.0, 94.0, 94.0],
    severity: HealthTrendSeverity.stable,
  ),
  const HealthSummaryMetric(
    title: 'Kualitas istirahat',
    value: '7.1',
    unit: 'jam',
    caption: 'Durasi tidur meningkat setelah jadwal obat malam disesuaikan.',
    trendLabel: 'Naik 0.6 jam',
    score: 0.76,
    sparklineValues: [6.4, 6.7, 6.6, 7.0, 7.2, 7.0, 7.1],
    severity: HealthTrendSeverity.improving,
  ),
];

final healthTimelineEvents = <HealthTimelineEvent>[
  HealthTimelineEvent(
    timestamp: DateTime(2026, 5, 11, 8, 0),
    title: 'Gula darah puasa tercatat',
    description: '126 mg/dL, turun dari 128 mg/dL kemarin. Sistem menandai tren membaik.',
    metaLabel: 'PeduliCek otomatis',
    type: TimelineEventType.vital,
  ),
  HealthTimelineEvent(
    timestamp: DateTime(2026, 5, 11, 7, 10),
    title: 'Tekanan darah pagi',
    description: '124/79 mmHg dengan nadi 74 bpm. Masuk rentang aman untuk target keluarga.',
    metaLabel: 'Input keluarga',
    type: TimelineEventType.vital,
  ),
  HealthTimelineEvent(
    timestamp: DateTime(2026, 5, 10, 20, 30),
    title: 'Obat malam dikonfirmasi',
    description: 'Amlodipine dan Metformin diminum sesuai jadwal. Tidak ada efek samping dilaporkan.',
    metaLabel: 'PeduliObat',
    type: TimelineEventType.medication,
  ),
  HealthTimelineEvent(
    timestamp: DateTime(2026, 5, 10, 16, 0),
    title: 'Konsultasi follow-up',
    description: 'Dokter menyarankan kontrol tekanan darah pagi selama 7 hari dan mengurangi konsumsi garam.',
    metaLabel: 'dr. Maya Larasati',
    type: TimelineEventType.consultation,
  ),
  HealthTimelineEvent(
    timestamp: DateTime(2026, 5, 9, 9, 0),
    title: 'Ringkasan lab masuk',
    description: 'Kolesterol total 198 mg/dL. Hasil masuk kategori batas atas normal.',
    metaLabel: 'Klinik Medika Harmoni',
    type: TimelineEventType.lab,
  ),
];

final healthLogs = <HealthLogEntry>[
  HealthLogEntry(
    timestamp: DateTime(2026, 5, 11, 8, 15),
    title: 'Sarapan rendah gula',
    value: 'Oat + telur',
    note: 'Tidak ada keluhan pusing setelah makan.',
    severity: HealthTrendSeverity.stable,
  ),
  HealthLogEntry(
    timestamp: DateTime(2026, 5, 10, 21, 0),
    title: 'Tidur malam',
    value: '7 jam 10 menit',
    note: 'Bangun 1 kali, kualitas tidur cukup baik.',
    severity: HealthTrendSeverity.improving,
  ),
  HealthLogEntry(
    timestamp: DateTime(2026, 5, 10, 17, 30),
    title: 'Aktivitas ringan',
    value: '18 menit jalan',
    note: 'Napas normal, tidak ada nyeri dada.',
    severity: HealthTrendSeverity.improving,
  ),
  HealthLogEntry(
    timestamp: DateTime(2026, 5, 9, 20, 10),
    title: 'Keluhan ringan',
    value: 'Kaki agak pegal',
    note: 'Disarankan elevasi kaki dan pantau bengkak.',
    severity: HealthTrendSeverity.attention,
  ),
];

final aiTrendInsights = <AiTrendInsight>[
  const AiTrendInsight(
    title: 'Tekanan darah lebih stabil pada pagi hari',
    description: 'Variasi sistolik turun dibanding awal minggu. Rata-rata 7 hari berada di kisaran pemantauan aman.',
    recommendation: 'Pertahankan pengukuran pagi sebelum aktivitas dan catat setelah minum obat.',
    confidence: 0.86,
    severity: HealthTrendSeverity.improving,
  ),
  const AiTrendInsight(
    title: 'Gula darah membaik tetapi masih sensitif terhadap makan malam',
    description: 'Nilai puasa turun 28 mg/dL dari titik tertinggi minggu ini, namun masih di atas target ideal.',
    recommendation: 'Gunakan pengingat makan malam rendah karbo dan evaluasi ulang dalam 3 hari.',
    confidence: 0.78,
    severity: HealthTrendSeverity.attention,
  ),
  const AiTrendInsight(
    title: 'Kepatuhan obat mendukung tren membaik',
    description: 'Dosis yang tercatat tepat waktu berkorelasi dengan tekanan darah yang lebih rendah keesokan paginya.',
    recommendation: 'Aktifkan reminder keluarga untuk dosis malam agar tidak terlambat.',
    confidence: 0.82,
    severity: HealthTrendSeverity.stable,
  ),
];
