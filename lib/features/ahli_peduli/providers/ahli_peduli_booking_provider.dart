import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/healthcare_provider.dart';

enum AhliPeduliBookingStatus {
  waitingConfirmation,
  confirmed,
  onTheWay,
  completed,
  cancelled;

  String get label {
    return switch (this) {
      AhliPeduliBookingStatus.waitingConfirmation => 'Menunggu konfirmasi',
      AhliPeduliBookingStatus.confirmed => 'Dikonfirmasi',
      AhliPeduliBookingStatus.onTheWay => 'Dalam perjalanan',
      AhliPeduliBookingStatus.completed => 'Selesai',
      AhliPeduliBookingStatus.cancelled => 'Dibatalkan',
    };
  }
}

class AhliPeduliBooking {
  const AhliPeduliBooking({
    required this.id,
    required this.elderId,
    required this.caregiverId,
    required this.providerId,
    required this.providerName,
    required this.providerCategory,
    required this.selectedSlot,
    required this.complaintNote,
    required this.needsAmbulance,
    required this.pickupAddress,
    required this.ambulanceFee,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String elderId;
  final String caregiverId;
  final String providerId;
  final String providerName;
  final String providerCategory;
  final String selectedSlot;
  final String complaintNote;
  final bool needsAmbulance;
  final String pickupAddress;
  final int ambulanceFee;
  final AhliPeduliBookingStatus status;
  final DateTime createdAt;

  String get ambulanceFeeLabel => 'Rp${ambulanceFee.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}';

  AhliPeduliBooking copyWith({
    AhliPeduliBookingStatus? status,
  }) {
    return AhliPeduliBooking(
      id: id,
      elderId: elderId,
      caregiverId: caregiverId,
      providerId: providerId,
      providerName: providerName,
      providerCategory: providerCategory,
      selectedSlot: selectedSlot,
      complaintNote: complaintNote,
      needsAmbulance: needsAmbulance,
      pickupAddress: pickupAddress,
      ambulanceFee: ambulanceFee,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}

class AhliPeduliBookingState {
  const AhliPeduliBookingState({required this.bookings});

  final List<AhliPeduliBooking> bookings;

  List<AhliPeduliBooking> get activeBookings => bookings
      .where((item) => item.status != AhliPeduliBookingStatus.cancelled && item.status != AhliPeduliBookingStatus.completed)
      .toList();

  AhliPeduliBookingState copyWith({List<AhliPeduliBooking>? bookings}) {
    return AhliPeduliBookingState(bookings: bookings ?? this.bookings);
  }
}

final ahliPeduliBookingProvider = NotifierProvider<AhliPeduliBookingController, AhliPeduliBookingState>(
  AhliPeduliBookingController.new,
);

class AhliPeduliBookingController extends Notifier<AhliPeduliBookingState> {
  @override
  AhliPeduliBookingState build() => const AhliPeduliBookingState(bookings: []);

  AhliPeduliBooking createBooking({
    required String elderId,
    required String caregiverId,
    required HealthcareProvider provider,
    required String selectedSlot,
    required String complaintNote,
    required bool needsAmbulance,
    required String pickupAddress,
  }) {
    final booking = AhliPeduliBooking(
      id: 'booking-${provider.id}-${DateTime.now().millisecondsSinceEpoch}',
      elderId: elderId,
      caregiverId: caregiverId,
      providerId: provider.id,
      providerName: provider.name,
      providerCategory: provider.category.label,
      selectedSlot: selectedSlot,
      complaintNote: complaintNote.trim().isEmpty ? 'Belum ada catatan keluhan' : complaintNote.trim(),
      needsAmbulance: needsAmbulance,
      pickupAddress: pickupAddress.trim(),
      ambulanceFee: needsAmbulance ? 185000 : 0,
      status: AhliPeduliBookingStatus.confirmed,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(bookings: [booking, ...state.bookings]);
    return booking;
  }

  void cancel(String bookingId) {
    state = state.copyWith(
      bookings: state.bookings.map((item) {
        if (item.id == bookingId) {
          return item.copyWith(status: AhliPeduliBookingStatus.cancelled);
        }
        return item;
      }).toList(),
    );
  }
}
