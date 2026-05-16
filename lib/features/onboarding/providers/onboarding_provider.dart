import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../state/providers/app_mode_provider.dart';

class OnboardingState {
  const OnboardingState({
    this.role,
    this.fullName = '',
    this.age = '',
    this.phoneNumber = '',
    this.gender = '',
    this.address = '',
    this.relationship = '',
    this.elderName = '',
    this.familyCode = '',
    this.healthConditions = const <String>{},
    this.mobilityNeeds = const <String>{},
    this.allergies = '',
    this.emergencyContactName = '',
    this.emergencyContactPhone = '',
    this.enableMedicationReminder = true,
    this.enableFamilyAlert = true,
    this.enableHealthSummary = true,
    this.completedAt,
  });

  final AppUserMode? role;
  final String fullName;
  final String age;
  final String phoneNumber;
  final String gender;
  final String address;
  final String relationship;
  final String elderName;
  final String familyCode;
  final Set<String> healthConditions;
  final Set<String> mobilityNeeds;
  final String allergies;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final bool enableMedicationReminder;
  final bool enableFamilyAlert;
  final bool enableHealthSummary;
  final DateTime? completedAt;

  bool get hasSelectedRole => role != null;

  bool get isElder => role == AppUserMode.elder;

  bool get isCaregiver => role == AppUserMode.caregiver;

  String get roleTitle {
    return switch (role) {
      AppUserMode.elder => 'PeduliDiri',
      AppUserMode.caregiver => 'PeduliPenuh',
      null => 'Belum dipilih',
    };
  }

  String get roleSubtitle {
    return switch (role) {
      AppUserMode.elder => 'Mode Lansia',
      AppUserMode.caregiver => 'Mode Anak',
      null => 'Pilih mode penggunaan',
    };
  }

  String get displayName {
    if (fullName.trim().isNotEmpty) return fullName.trim();
    if (isElder) return 'Bapak/Ibu';
    return 'Kak';
  }

  String get genderLabel => gender.trim().isEmpty ? 'Belum dipilih' : gender.trim();

  String get connectedFamilyLabel {
    if (isElder) {
      return familyCode.trim().isEmpty ? 'Kode siap dibagikan' : familyCode;
    }

    return familyCode.trim().isEmpty ? 'Belum dihubungkan' : familyCode.trim();
  }

  String get inviteCode => familyCode.trim().isEmpty ? 'Kode dibuat otomatis' : familyCode.trim();

  OnboardingState copyWith({
    AppUserMode? role,
    String? fullName,
    String? age,
    String? phoneNumber,
    String? gender,
    String? address,
    String? relationship,
    String? elderName,
    String? familyCode,
    Set<String>? healthConditions,
    Set<String>? mobilityNeeds,
    String? allergies,
    String? emergencyContactName,
    String? emergencyContactPhone,
    bool? enableMedicationReminder,
    bool? enableFamilyAlert,
    bool? enableHealthSummary,
    DateTime? completedAt,
  }) {
    return OnboardingState(
      role: role ?? this.role,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      relationship: relationship ?? this.relationship,
      elderName: elderName ?? this.elderName,
      familyCode: familyCode ?? this.familyCode,
      healthConditions: healthConditions ?? this.healthConditions,
      mobilityNeeds: mobilityNeeds ?? this.mobilityNeeds,
      allergies: allergies ?? this.allergies,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      enableMedicationReminder:
          enableMedicationReminder ?? this.enableMedicationReminder,
      enableFamilyAlert: enableFamilyAlert ?? this.enableFamilyAlert,
      enableHealthSummary: enableHealthSummary ?? this.enableHealthSummary,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

final onboardingProvider =
    NotifierProvider<OnboardingController, OnboardingState>(
  OnboardingController.new,
);

class OnboardingController extends Notifier<OnboardingState> {
  @override
  OnboardingState build() {
    return const OnboardingState();
  }

  void setRole(AppUserMode role) {
    state = state.copyWith(role: role);
  }

  void setFullName(String value) {
    state = state.copyWith(fullName: value);
  }

  void setAge(String value) {
    state = state.copyWith(age: value);
  }

  void setPhoneNumber(String value) {
    state = state.copyWith(phoneNumber: value);
  }

  void setGender(String value) {
    state = state.copyWith(gender: value);
  }

  void setAddress(String value) {
    state = state.copyWith(address: value);
  }

  void setRelationship(String value) {
    state = state.copyWith(relationship: value);
  }

  void setElderName(String value) {
    state = state.copyWith(elderName: value);
  }

  void setFamilyCode(String value) {
    state = state.copyWith(familyCode: value);
  }

  void setAllergies(String value) {
    state = state.copyWith(allergies: value);
  }

  void setEmergencyContactName(String value) {
    state = state.copyWith(emergencyContactName: value);
  }

  void setEmergencyContactPhone(String value) {
    state = state.copyWith(emergencyContactPhone: value);
  }

  void toggleCondition(String condition) {
    final next = Set<String>.from(state.healthConditions);

    if (next.contains(condition)) {
      next.remove(condition);
    } else {
      next.add(condition);
    }

    state = state.copyWith(healthConditions: next);
  }

  void toggleMobilityNeed(String need) {
    final next = Set<String>.from(state.mobilityNeeds);

    if (next.contains(need)) {
      next.remove(need);
    } else {
      next.add(need);
    }

    state = state.copyWith(mobilityNeeds: next);
  }

  void setMedicationReminder(bool value) {
    state = state.copyWith(enableMedicationReminder: value);
  }

  void setFamilyAlert(bool value) {
    state = state.copyWith(enableFamilyAlert: value);
  }

  void setHealthSummary(bool value) {
    state = state.copyWith(enableHealthSummary: value);
  }

  void finish() {
    state = state.copyWith(completedAt: DateTime.now());
  }

  void reset() {
    state = const OnboardingState();
  }

  bool canContinueFromPage(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return true;
      case 1:
        return true;
      case 2:
        return state.role != null;
      case 3:
        if (state.isElder) {
          return state.fullName.trim().isNotEmpty && state.gender.trim().isNotEmpty;
        }
        return state.fullName.trim().isNotEmpty && state.elderName.trim().isNotEmpty;
      case 4:
        return true;
      case 5:
        return true;
      case 6:
        return true;
      default:
        return false;
    }
  }
}
