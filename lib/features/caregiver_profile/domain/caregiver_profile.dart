import 'dart:convert';

import '../../elder_profile/domain/elder_profile.dart';

class CaregiverProfile {
  const CaregiverProfile({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.relationship,
    required this.address,
    required this.elderName,
    required this.linkedElderId,
    required this.usedConnectionCode,
    required this.connectedAt,
  });

  final String id;
  final String name;
  final String phoneNumber;
  final String relationship;
  final String address;
  final String elderName;
  final String linkedElderId;
  final String usedConnectionCode;
  final DateTime? connectedAt;

  bool get hasLinkedElder => linkedElderId.trim().isNotEmpty;

  String get displayName => name.trim().isEmpty ? 'Belum diisi' : name.trim();
  String get displayPhone => phoneNumber.trim().isEmpty ? 'Belum diisi' : phoneNumber.trim();
  String get displayRelationship => relationship.trim().isEmpty ? 'Anak atau pendamping' : relationship.trim();
  String get displayAddress => address.trim().isEmpty ? 'Belum diisi' : address.trim();
  String get displayElderName => elderName.trim().isEmpty ? 'Belum diisi' : elderName.trim();
  String get displayConnectionCode => usedConnectionCode.trim().isEmpty ? 'Belum ada' : usedConnectionCode.trim();
  String get displayConnectedAt {
    final value = connectedAt;
    if (value == null) return 'Belum terhubung';
    return '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
  }

  factory CaregiverProfile.empty() {
    return CaregiverProfile(
      id: 'caregiver-${DateTime.now().millisecondsSinceEpoch}',
      name: '',
      phoneNumber: '',
      relationship: '',
      address: '',
      elderName: '',
      linkedElderId: '',
      usedConnectionCode: '',
      connectedAt: null,
    );
  }

  CaregiverProfile copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? relationship,
    String? address,
    String? elderName,
    String? linkedElderId,
    String? usedConnectionCode,
    DateTime? connectedAt,
    bool clearConnectedAt = false,
  }) {
    return CaregiverProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      relationship: relationship ?? this.relationship,
      address: address ?? this.address,
      elderName: elderName ?? this.elderName,
      linkedElderId: linkedElderId ?? this.linkedElderId,
      usedConnectionCode: usedConnectionCode ?? this.usedConnectionCode,
      connectedAt: clearConnectedAt ? null : connectedAt ?? this.connectedAt,
    );
  }
}

class ConnectionPayloadParser {
  const ConnectionPayloadParser._();

  static String connectionCodeFromInput(String rawInput) {
    final input = rawInput.trim();
    if (input.isEmpty) return '';

    try {
      final decoded = jsonDecode(input);
      if (decoded is Map<String, dynamic>) {
        final code = decoded['connectionCode']?.toString().trim() ?? '';
        if (code.isNotEmpty) return code.toUpperCase();
      }
    } catch (_) {
      // Input bisa berupa kode biasa, bukan JSON QR.
    }

    return input.toUpperCase().replaceAll(' ', '');
  }

  static bool isValidForElder(String rawInput, ElderProfile elder) {
    final code = connectionCodeFromInput(rawInput);
    return code.isNotEmpty && code == elder.connectionCode.toUpperCase();
  }
}
