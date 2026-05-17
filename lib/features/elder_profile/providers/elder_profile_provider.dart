import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../onboarding/providers/onboarding_provider.dart';
import '../data/elder_profile_repository.dart';
import '../domain/elder_profile.dart';

final elderProfileRepositoryProvider = Provider<ElderProfileRepository>((ref) {
  return ElderProfileRepository();
});

final elderProfileProvider = NotifierProvider<ElderProfileController, ElderProfile>(
  ElderProfileController.new,
);

class ElderProfileController extends Notifier<ElderProfile> {
  late final ElderProfileRepository _repository;

  @override
  ElderProfile build() {
    _repository = ref.read(elderProfileRepositoryProvider);
    return _repository.loadProfile();
  }

  void saveProfile(ElderProfile profile) {
    _repository.saveProfile(profile);
    state = profile;
  }

  void saveFromOnboarding(OnboardingState onboarding) {
    final previous = state;
    final conditions = <String>{
      ...onboarding.healthConditions,
      ...onboarding.mobilityNeeds,
      if (onboarding.allergies.trim().isNotEmpty) onboarding.allergies.trim(),
    }.where((item) => item.trim().isNotEmpty).toList();

    final profile = previous.copyWith(
      name: onboarding.fullName.trim(),
      age: onboarding.age.trim(),
      gender: onboarding.gender.trim(),
      phoneNumber: onboarding.phoneNumber.trim(),
      address: onboarding.address.trim(),
      medicalHistory: conditions,
      connectionCode: previous.connectionCode,
      qrPayload: ElderProfile.buildQrPayload(
        id: previous.id,
        connectionCode: previous.connectionCode,
      ),
    );

    saveProfile(profile);
  }

  void updateFamilyIdentity({
    required String elderName,
    required String elderAge,
    required String elderHeight,
    required String elderWeight,
    required String elderGender,
    required String elderPhoneNumber,
    required String elderAddress,
    required List<String> medicalHistory,
  }) {
    saveProfile(
      state.copyWith(
        name: elderName.trim(),
        age: elderAge.trim(),
        height: elderHeight.trim(),
        weight: elderWeight.trim(),
        gender: elderGender.trim(),
        phoneNumber: elderPhoneNumber.trim(),
        address: elderAddress.trim(),
        medicalHistory: medicalHistory
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty)
            .toList(),
      ),
    );
  }

  void addCaregiver(CaregiverConnection caregiver) {
    final next = [
      ...state.linkedCaregivers.where((item) => item.id != caregiver.id),
      caregiver,
    ];

    saveProfile(state.copyWith(linkedCaregivers: next));
  }
}
