enum TimelineEventType {
  vital,
  medication,
  consultation,
  lab,
  alert,
  note;

  String get label {
    return switch (this) {
      TimelineEventType.vital => 'Vital',
      TimelineEventType.medication => 'Obat',
      TimelineEventType.consultation => 'Konsultasi',
      TimelineEventType.lab => 'Lab',
      TimelineEventType.alert => 'PeduliDarurat',
      TimelineEventType.note => 'Catatan',
    };
  }
}

enum HealthTrendSeverity {
  stable,
  attention,
  improving,
  risk;

  String get label {
    return switch (this) {
      HealthTrendSeverity.stable => 'Stabil',
      HealthTrendSeverity.attention => 'Perlu perhatian',
      HealthTrendSeverity.improving => 'Membaik',
      HealthTrendSeverity.risk => 'Risiko naik',
    };
  }
}

class BloodPressureRecord {
  const BloodPressureRecord({
    required this.date,
    required this.systolic,
    required this.diastolic,
    required this.pulse,
    required this.statusLabel,
  });

  final DateTime date;
  final int systolic;
  final int diastolic;
  final int pulse;
  final String statusLabel;

  String get readingLabel => '$systolic/$diastolic';
}

class BloodSugarRecord {
  const BloodSugarRecord({
    required this.date,
    required this.mgdl,
    required this.timingLabel,
    required this.statusLabel,
  });

  final DateTime date;
  final int mgdl;
  final String timingLabel;
  final String statusLabel;
}

class HealthSummaryMetric {
  const HealthSummaryMetric({
    required this.title,
    required this.value,
    required this.unit,
    required this.caption,
    required this.trendLabel,
    required this.score,
    required this.sparklineValues,
    required this.severity,
  });

  final String title;
  final String value;
  final String unit;
  final String caption;
  final String trendLabel;
  final double score;
  final List<double> sparklineValues;
  final HealthTrendSeverity severity;
}

class HealthTimelineEvent {
  const HealthTimelineEvent({
    required this.timestamp,
    required this.title,
    required this.description,
    required this.metaLabel,
    required this.type,
  });

  final DateTime timestamp;
  final String title;
  final String description;
  final String metaLabel;
  final TimelineEventType type;
}

class HealthLogEntry {
  const HealthLogEntry({
    required this.timestamp,
    required this.title,
    required this.value,
    required this.note,
    required this.severity,
  });

  final DateTime timestamp;
  final String title;
  final String value;
  final String note;
  final HealthTrendSeverity severity;
}

class AiTrendInsight {
  const AiTrendInsight({
    required this.title,
    required this.description,
    required this.recommendation,
    required this.confidence,
    required this.severity,
  });

  final String title;
  final String description;
  final String recommendation;
  final double confidence;
  final HealthTrendSeverity severity;
}
