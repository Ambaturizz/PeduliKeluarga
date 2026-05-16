import 'dart:convert';

class CaregiverConnection {
  const CaregiverConnection({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.relationship,
    required this.connectedAt,
  });

  final String id;
  final String name;
  final String phoneNumber;
  final String relationship;
  final DateTime connectedAt;

  String get displayName => name.trim().isEmpty ? 'Belum diisi' : name.trim();
  String get displayPhone => phoneNumber.trim().isEmpty ? 'Belum diisi' : phoneNumber.trim();
  String get displayRelationship => relationship.trim().isEmpty ? 'Keluarga' : relationship.trim();

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'relationship': relationship,
      'connectedAt': connectedAt.toIso8601String(),
    };
  }

  factory CaregiverConnection.fromJson(Map<String, Object?> json) {
    return CaregiverConnection(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      relationship: json['relationship'] as String? ?? '',
      connectedAt: DateTime.tryParse(json['connectedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

class ElderProfile {
  const ElderProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.weight,
    required this.gender,
    required this.phoneNumber,
    required this.address,
    required this.medicalHistory,
    required this.linkedCaregivers,
    required this.connectionCode,
    required this.qrPayload,
  });

  final String id;
  final String name;
  final String age;
  final String weight;
  final String gender;
  final String phoneNumber;
  final String address;
  final List<String> medicalHistory;
  final List<CaregiverConnection> linkedCaregivers;
  final String connectionCode;
  final String qrPayload;

  factory ElderProfile.empty({
    required String id,
    required String connectionCode,
  }) {
    return ElderProfile(
      id: id,
      name: '',
      age: '',
      weight: '',
      gender: '',
      phoneNumber: '',
      address: '',
      medicalHistory: const [],
      linkedCaregivers: const [],
      connectionCode: connectionCode,
      qrPayload: _buildQrPayload(id: id, connectionCode: connectionCode),
    );
  }

  static String buildQrPayload({
    required String id,
    required String connectionCode,
  }) {
    return _buildQrPayload(id: id, connectionCode: connectionCode);
  }

  static String _buildQrPayload({
    required String id,
    required String connectionCode,
  }) {
    return jsonEncode({
      'app': 'PeduliKeluarga',
      'mode': 'PeduliDiri',
      'elderId': id,
      'connectionCode': connectionCode,
    });
  }

  String get displayName => name.trim().isEmpty ? 'Belum diisi' : name.trim();
  String get displayAge => age.trim().isEmpty ? 'Belum diisi' : '${age.trim()} tahun';
  String get displayWeight => weight.trim().isEmpty ? 'Belum diisi' : '${weight.trim()} kg';
  String get displayGender => gender.trim().isEmpty ? 'Belum diisi' : gender.trim();
  String get displayPhone => phoneNumber.trim().isEmpty ? 'Belum diisi' : phoneNumber.trim();
  String get displayAddress => address.trim().isEmpty ? 'Belum diisi' : address.trim();

  String get medicalHistoryLabel {
    if (medicalHistory.isEmpty) return 'Belum diisi';
    return medicalHistory.join(', ');
  }

  bool get hasCaregiver => linkedCaregivers.isNotEmpty;

  bool get hasDiabetes {
    final joined = medicalHistory.join(' ').toLowerCase();
    return joined.contains('diabetes') || joined.contains('diabetes melitus');
  }

  bool get usesInsulin {
    final joined = medicalHistory.join(' ').toLowerCase();
    return joined.contains('insulin');
  }

  ElderProfile copyWith({
    String? id,
    String? name,
    String? age,
    String? weight,
    String? gender,
    String? phoneNumber,
    String? address,
    List<String>? medicalHistory,
    List<CaregiverConnection>? linkedCaregivers,
    String? connectionCode,
    String? qrPayload,
  }) {
    final nextId = id ?? this.id;
    final nextCode = connectionCode ?? this.connectionCode;

    return ElderProfile(
      id: nextId,
      name: name ?? this.name,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      linkedCaregivers: linkedCaregivers ?? this.linkedCaregivers,
      connectionCode: nextCode,
      qrPayload: qrPayload ?? _buildQrPayload(id: nextId, connectionCode: nextCode),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'weight': weight,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'address': address,
      'medicalHistory': medicalHistory,
      'linkedCaregivers': linkedCaregivers.map((item) => item.toJson()).toList(),
      'connectionCode': connectionCode,
      'qrPayload': qrPayload,
    };
  }

  factory ElderProfile.fromJson(Map<String, Object?> json) {
    final id = json['id'] as String? ?? '';
    final code = json['connectionCode'] as String? ?? '';

    return ElderProfile(
      id: id,
      name: json['name'] as String? ?? '',
      age: json['age'] as String? ?? '',
      weight: json['weight'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      address: json['address'] as String? ?? '',
      medicalHistory: (json['medicalHistory'] as List<dynamic>? ?? const [])
          .map((item) => item.toString())
          .where((item) => item.trim().isNotEmpty)
          .toList(),
      linkedCaregivers: (json['linkedCaregivers'] as List<dynamic>? ?? const [])
          .whereType<Map<String, Object?>>()
          .map(CaregiverConnection.fromJson)
          .toList(),
      connectionCode: code,
      qrPayload: json['qrPayload'] as String? ?? _buildQrPayload(id: id, connectionCode: code),
    );
  }
}
