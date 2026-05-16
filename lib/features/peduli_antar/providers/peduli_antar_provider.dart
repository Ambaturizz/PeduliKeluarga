import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../peduliobat/data/medication_dummy_data.dart';

enum MedicineOrderStatus {
  waitingCaregiverConfirmation,
  confirmed,
  processing,
  courierToPharmacy,
  courierToElderAddress,
  completed,
  cancelled;

  String get label {
    return switch (this) {
      MedicineOrderStatus.waitingCaregiverConfirmation => 'Menunggu konfirmasi pendamping',
      MedicineOrderStatus.confirmed => 'Dikonfirmasi',
      MedicineOrderStatus.processing => 'Diproses apotek',
      MedicineOrderStatus.courierToPharmacy => 'Kurir menuju apotek',
      MedicineOrderStatus.courierToElderAddress => 'Kurir menuju alamat lansia',
      MedicineOrderStatus.completed => 'Selesai',
      MedicineOrderStatus.cancelled => 'Dibatalkan',
    };
  }
}

class MedicineOrderItem {
  const MedicineOrderItem({
    required this.medicineId,
    required this.name,
    required this.dose,
    required this.quantity,
    required this.price,
  });

  final String medicineId;
  final String name;
  final String dose;
  final int quantity;
  final int price;

  String get priceLabel => rupiah(price);
}

class MedicineOrder {
  const MedicineOrder({
    required this.id,
    required this.elderId,
    required this.caregiverId,
    required this.medicines,
    required this.pharmacyName,
    required this.pharmacyAddress,
    required this.deliveryAddress,
    required this.medicinePrice,
    required this.deliveryFee,
    required this.totalPrice,
    required this.etaMinutes,
    required this.status,
    required this.createdAt,
    required this.confirmedAt,
  });

  final String id;
  final String elderId;
  final String caregiverId;
  final List<MedicineOrderItem> medicines;
  final String pharmacyName;
  final String pharmacyAddress;
  final String deliveryAddress;
  final int medicinePrice;
  final int deliveryFee;
  final int totalPrice;
  final int etaMinutes;
  final MedicineOrderStatus status;
  final DateTime createdAt;
  final DateTime? confirmedAt;

  String get medicineNames => medicines.map((item) => item.name).join(', ');
  String get medicinePriceLabel => rupiah(medicinePrice);
  String get deliveryFeeLabel => rupiah(deliveryFee);
  String get totalPriceLabel => rupiah(totalPrice);
  String get etaLabel => '$etaMinutes menit';

  MedicineOrder copyWith({
    MedicineOrderStatus? status,
    DateTime? confirmedAt,
  }) {
    return MedicineOrder(
      id: id,
      elderId: elderId,
      caregiverId: caregiverId,
      medicines: medicines,
      pharmacyName: pharmacyName,
      pharmacyAddress: pharmacyAddress,
      deliveryAddress: deliveryAddress,
      medicinePrice: medicinePrice,
      deliveryFee: deliveryFee,
      totalPrice: totalPrice,
      etaMinutes: etaMinutes,
      status: status ?? this.status,
      createdAt: createdAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
    );
  }
}

String rupiah(int value) {
  final text = value.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (match) => '${match[1]}.',
      );
  return 'Rp$text';
}

class PeduliAntarState {
  const PeduliAntarState({required this.orders});

  final List<MedicineOrder> orders;

  bool get hasOrders => orders.isNotEmpty;
  List<MedicineOrder> get waitingOrders => orders.where((item) => item.status == MedicineOrderStatus.waitingCaregiverConfirmation).toList();
  MedicineOrder? get latestOrder => orders.isEmpty ? null : orders.first;

  PeduliAntarState copyWith({List<MedicineOrder>? orders}) {
    return PeduliAntarState(orders: orders ?? this.orders);
  }
}

final peduliAntarProvider = NotifierProvider<PeduliAntarController, PeduliAntarState>(
  PeduliAntarController.new,
);

class PeduliAntarController extends Notifier<PeduliAntarState> {
  @override
  PeduliAntarState build() {
    return const PeduliAntarState(orders: []);
  }

  MedicineOrder createRequest(MedicationModel medication) {
    return createDraftFromMedication(medication);
  }

  MedicineOrder createDraftFromMedication(MedicationModel medication) {
    final medicinePrice = _priceFor(medication.id);
    final deliveryFee = 18000;
    final order = MedicineOrder(
      id: 'order-${medication.id}-${DateTime.now().millisecondsSinceEpoch}',
      elderId: 'elder-local',
      caregiverId: 'caregiver-local',
      medicines: [
        MedicineOrderItem(
          medicineId: medication.id,
          name: medication.name,
          dose: medication.dose,
          quantity: 1,
          price: medicinePrice,
        ),
      ],
      pharmacyName: 'Apotek Sehat Bersama',
      pharmacyAddress: 'Jl. Kesehatan No. 12, Tangerang',
      deliveryAddress: 'Alamat lansia dari profil PeduliDiri',
      medicinePrice: medicinePrice,
      deliveryFee: deliveryFee,
      totalPrice: medicinePrice + deliveryFee,
      etaMinutes: 35,
      status: MedicineOrderStatus.waitingCaregiverConfirmation,
      createdAt: DateTime.now(),
      confirmedAt: null,
    );

    final existingIndex = state.orders.indexWhere(
      (item) => item.medicines.any((medicine) => medicine.medicineId == medication.id) && item.status != MedicineOrderStatus.cancelled,
    );

    if (existingIndex >= 0) {
      final next = [...state.orders];
      next[existingIndex] = order;
      state = state.copyWith(orders: next);
      return order;
    }

    state = state.copyWith(orders: [order, ...state.orders]);
    return order;
  }

  void confirm(String orderId) {
    _updateStatus(orderId, MedicineOrderStatus.processing, confirmedAt: DateTime.now());
  }

  void cancel(String orderId) {
    _updateStatus(orderId, MedicineOrderStatus.cancelled);
  }

  void advance(String orderId) {
    final order = state.orders.firstWhere((item) => item.id == orderId);
    final nextStatus = switch (order.status) {
      MedicineOrderStatus.waitingCaregiverConfirmation => MedicineOrderStatus.confirmed,
      MedicineOrderStatus.confirmed => MedicineOrderStatus.processing,
      MedicineOrderStatus.processing => MedicineOrderStatus.courierToPharmacy,
      MedicineOrderStatus.courierToPharmacy => MedicineOrderStatus.courierToElderAddress,
      MedicineOrderStatus.courierToElderAddress => MedicineOrderStatus.completed,
      MedicineOrderStatus.completed => MedicineOrderStatus.completed,
      MedicineOrderStatus.cancelled => MedicineOrderStatus.cancelled,
    };
    _updateStatus(orderId, nextStatus);
  }

  void _updateStatus(String orderId, MedicineOrderStatus status, {DateTime? confirmedAt}) {
    state = state.copyWith(
      orders: state.orders.map((item) {
        if (item.id == orderId) {
          return item.copyWith(status: status, confirmedAt: confirmedAt);
        }
        return item;
      }).toList(),
    );
  }

  int _priceFor(String medicationId) {
    return switch (medicationId) {
      'simvastatin' => 42000,
      'metformin' => 56000,
      'amlodipin' => 38000,
      _ => 45000,
    };
  }
}

enum PeduliAntarLocationStatus {
  initial,
  loading,
  granted,
  denied,
  deniedForever,
  serviceDisabled,
  error,
}

class PeduliAntarLocationState {
  const PeduliAntarLocationState({
    required this.status,
    this.currentPosition,
    this.message,
    this.isTracking = false,
  });

  final PeduliAntarLocationStatus status;
  final LatLng? currentPosition;
  final String? message;
  final bool isTracking;

  bool get hasLocation => currentPosition != null;

  bool get canUseMapLocation {
    return status == PeduliAntarLocationStatus.granted &&
        currentPosition != null;
  }

  PeduliAntarLocationState copyWith({
    PeduliAntarLocationStatus? status,
    LatLng? currentPosition,
    String? message,
    bool? isTracking,
    bool clearCurrentPosition = false,
    bool clearMessage = false,
  }) {
    return PeduliAntarLocationState(
      status: status ?? this.status,
      currentPosition:
          clearCurrentPosition ? null : currentPosition ?? this.currentPosition,
      message: clearMessage ? null : message ?? this.message,
      isTracking: isTracking ?? this.isTracking,
    );
  }

  static const initialState = PeduliAntarLocationState(
    status: PeduliAntarLocationStatus.initial,
    message: 'Lokasi belum dicek.',
  );
}

final peduliAntarLocationProvider = NotifierProvider.autoDispose<
    PeduliAntarLocationController, PeduliAntarLocationState>(
  PeduliAntarLocationController.new,
);

class PeduliAntarLocationController
    extends Notifier<PeduliAntarLocationState> {
  StreamSubscription<Position>? _positionSubscription;
  bool _isDisposed = false;

  static const LocationSettings _locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10,
  );

  @override
  PeduliAntarLocationState build() {
    _isDisposed = false;

    ref.onDispose(() {
      _isDisposed = true;
      final subscription = _positionSubscription;
      _positionSubscription = null;
      unawaited(subscription?.cancel() ?? Future<void>.value());
    });

    return PeduliAntarLocationState.initialState;
  }

  Future<void> initialize() async {
    await _checkPermissionAndStart(requestIfDenied: true);
  }

  Future<void> refreshPermissionStatus() async {
    await _checkPermissionAndStart(requestIfDenied: false);
  }

  Future<void> requestLocationPermission() async {
    await _checkPermissionAndStart(requestIfDenied: true);
  }

  Future<void> openAppSettings() async {
    try {
      await Geolocator.openAppSettings();
    } catch (_) {
      _updateState(
        status: PeduliAntarLocationStatus.error,
        message: 'Tidak dapat membuka pengaturan aplikasi.',
      );
    }
  }

  Future<void> openLocationSettings() async {
    try {
      await Geolocator.openLocationSettings();
      await refreshPermissionStatus();
    } catch (_) {
      _updateState(
        status: PeduliAntarLocationStatus.error,
        message: 'Tidak dapat membuka pengaturan lokasi.',
      );
    }
  }

  Future<void> _checkPermissionAndStart({
    required bool requestIfDenied,
  }) async {
    _updateState(
      status: PeduliAntarLocationStatus.loading,
      message: 'Mengecek layanan dan izin lokasi...',
    );

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (_isDisposed) return;

    if (!serviceEnabled) {
      await _stopTracking();
      if (_isDisposed) return;

      _updateState(
        status: PeduliAntarLocationStatus.serviceDisabled,
        message:
            'Layanan lokasi belum aktif. Aktifkan GPS/lokasi perangkat terlebih dahulu.',
        isTracking: false,
        clearCurrentPosition: true,
      );
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (_isDisposed) return;

    if (permission == LocationPermission.denied && requestIfDenied) {
      permission = await Geolocator.requestPermission();
      if (_isDisposed) return;
    }

    if (permission == LocationPermission.denied) {
      await _stopTracking();
      if (_isDisposed) return;

      _updateState(
        status: PeduliAntarLocationStatus.denied,
        message: 'Izin lokasi belum diberikan.',
        isTracking: false,
        clearCurrentPosition: true,
      );
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      await _stopTracking();
      if (_isDisposed) return;

      _updateState(
        status: PeduliAntarLocationStatus.deniedForever,
        message:
            'Izin lokasi ditolak permanen. Buka pengaturan aplikasi untuk mengaktifkannya.',
        isTracking: false,
        clearCurrentPosition: true,
      );
      return;
    }

    await _startTracking();
  }

  Future<void> _startTracking() async {
    await _stopTracking();
    if (_isDisposed) return;

    _updateState(
      status: PeduliAntarLocationStatus.loading,
      message: 'Mengambil lokasi terkini...',
      isTracking: false,
    );

    try {
      final lastKnownPosition = await Geolocator.getLastKnownPosition();
      if (_isDisposed) return;

      if (lastKnownPosition != null) {
        _updatePosition(lastKnownPosition, isTracking: false);
      }

      final currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: _locationSettings,
      );
      if (_isDisposed) return;

      _updatePosition(currentPosition, isTracking: true);
    } catch (_) {
      if (_isDisposed) return;

      _updateState(
        status: PeduliAntarLocationStatus.granted,
        message:
            'Izin lokasi aktif. Menunggu pembaruan lokasi realtime...',
        isTracking: true,
      );
    }

    if (_isDisposed) return;

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: _locationSettings,
    ).listen(
      (position) {
        _updatePosition(position, isTracking: true);
      },
      onError: (_) {
        _updateState(
          status: PeduliAntarLocationStatus.error,
          message: 'Gagal membaca pembaruan lokasi realtime.',
          isTracking: false,
        );
      },
    );
  }

  Future<void> _stopTracking() async {
    final subscription = _positionSubscription;
    _positionSubscription = null;
    await subscription?.cancel();
  }

  void _updatePosition(
    Position position, {
    required bool isTracking,
  }) {
    _updateState(
      status: PeduliAntarLocationStatus.granted,
      currentPosition: LatLng(position.latitude, position.longitude),
      message:
          isTracking ? 'Lokasi realtime aktif.' : 'Lokasi terakhir berhasil ditemukan.',
      isTracking: isTracking,
    );
  }

  void _updateState({
    PeduliAntarLocationStatus? status,
    LatLng? currentPosition,
    String? message,
    bool? isTracking,
    bool clearCurrentPosition = false,
  }) {
    if (_isDisposed) return;

    state = state.copyWith(
      status: status,
      currentPosition: currentPosition,
      message: message,
      isTracking: isTracking,
      clearCurrentPosition: clearCurrentPosition,
    );
  }
}
