enum ProviderCategory {
  doctor,
  nurse,
  clinic;

  String get label {
    return switch (this) {
      ProviderCategory.doctor => 'Dokter',
      ProviderCategory.nurse => 'Perawat',
      ProviderCategory.clinic => 'Klinik',
    };
  }

  String get pluralLabel {
    return switch (this) {
      ProviderCategory.doctor => 'Doctor cards',
      ProviderCategory.nurse => 'Nurse cards',
      ProviderCategory.clinic => 'Clinic cards',
    };
  }

  String get shortLabel {
    return switch (this) {
      ProviderCategory.doctor => 'Dokter',
      ProviderCategory.nurse => 'Perawat',
      ProviderCategory.clinic => 'Klinik',
    };
  }
}

class HealthcareProvider {
  const HealthcareProvider({
    required this.id,
    required this.category,
    required this.name,
    required this.speciality,
    required this.facility,
    required this.location,
    required this.distanceKm,
    required this.rating,
    required this.reviewCount,
    required this.etaMinutes,
    required this.priceLabel,
    required this.availabilityLabel,
    required this.experienceLabel,
    required this.tags,
    required this.nextSlots,
    required this.isVerified,
    required this.isEmergencyReady,
    required this.isOnlineConsultationReady,
  });

  final String id;
  final ProviderCategory category;
  final String name;
  final String speciality;
  final String facility;
  final String location;
  final double distanceKm;
  final double rating;
  final int reviewCount;
  final int etaMinutes;
  final String priceLabel;
  final String availabilityLabel;
  final String experienceLabel;
  final List<String> tags;
  final List<String> nextSlots;
  final bool isVerified;
  final bool isEmergencyReady;
  final bool isOnlineConsultationReady;

  bool get isNearby => distanceKm <= 3.0;

  String get distanceLabel => '${distanceKm.toStringAsFixed(1)} km';

  String get etaLabel => '$etaMinutes menit';
}

class CareNetworkMetric {
  const CareNetworkMetric({
    required this.label,
    required this.value,
    required this.caption,
  });

  final String label;
  final String value;
  final String caption;
}
