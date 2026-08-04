import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../elder_profile/domain/elder_profile.dart';
import '../../elder_profile/providers/elder_profile_provider.dart';
import '../../onboarding/providers/onboarding_provider.dart';
import '../data/caregiver_profile_repository.dart';
import '../domain/caregiver_profile.dart';

final caregiverProfileRepositoryProvider = Provider<CaregiverProfileRepository>((ref) {
  return CaregiverProfileRepository();
});

final caregiverProfileProvider = NotifierProvider<CaregiverProfileController, CaregiverProfile>(
  CaregiverProfileController.new,
);

class CaregiverProfileController extends Notifier<CaregiverProfile> {
  late final CaregiverProfileRepository _repository;

  @override
  CaregiverProfile build() {
    _repository = ref.read(caregiverProfileRepositoryProvider);
    return _repository.loadProfile();
  }

  void saveFromOnboarding(OnboardingState onboarding) {
    final next = state.copyWith(
      name: onboarding.fullName.trim(),
      phoneNumber: onboarding.phoneNumber.trim(),
      relationship: onboarding.relationship.trim(),
      address: onboarding.address.trim(),
      elderName: onboarding.elderName.trim(),
    );
    _repository.saveProfile(next);
    state = next;

    if (onboarding.familyCode.trim().isNotEmpty) {
      connectWithCode(onboarding.familyCode.trim());
    }
  }

  bool connectWithCode(String rawInput) {
    final elder = ref.read(elderProfileProvider);
    final code = ConnectionPayloadParser.connectionCodeFromInput(rawInput);

    if (!ConnectionPayloadParser.isValidForElder(rawInput, elder)) {
      return false;
    }

    final connectedAt = DateTime.now();
    final next = state.copyWith(
      linkedElderId: elder.id,
      usedConnectionCode: code,
      connectedAt: connectedAt,
      elderName: state.elderName.trim().isEmpty ? elder.displayName : state.elderName.trim(),
    );
    _repository.saveProfile(next);
    state = next;

    ref.read(elderProfileProvider.notifier).addCaregiver(
          CaregiverConnection(
            id: next.id,
            name: next.displayName,
            phoneNumber: next.displayPhone,
            relationship: next.displayRelationship,
            connectedAt: connectedAt,
          ),
        );

    return true;
  }

  void updateFamilyIdentity({
    required String childName,
    required String childPhoneNumber,
    required String relationship,
    required String childAddress,
    required String elderName,
  }) {
    final next = state.copyWith(
      name: childName.trim(),
      phoneNumber: childPhoneNumber.trim(),
      relationship: relationship.trim(),
      address: childAddress.trim(),
      elderName: elderName.trim(),
    );
    _repository.saveProfile(next);
    state = next;
  }

  void updateIdentity({
    required String name,
    required String phoneNumber,
    required String relationship,
    required String address,
    String? elderName,
  }) {
    final next = state.copyWith(
      name: name.trim(),
      phoneNumber: phoneNumber.trim(),
      relationship: relationship.trim(),
      address: address.trim(),
      elderName: elderName?.trim(),
    );
    _repository.saveProfile(next);
    state = next;
  }

  void updateElderName(String value) {
    state = state.copyWith(elderName: value.trim());
  }
}
