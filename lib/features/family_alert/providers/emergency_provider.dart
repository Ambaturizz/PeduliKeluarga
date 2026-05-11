import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/pk_design.dart';
import '../data/emergency_mock_data.dart';

class EmergencyState {
  const EmergencyState({
    required this.status,
    required this.contacts,
    required this.timeline,
    required this.countdownSeconds,
    required this.dispatchProgress,
    required this.notificationCount,
    required this.startedAt,
    required this.resolvedAt,
  });

  final EmergencyStatus status;
  final List<EmergencyContact> contacts;
  final List<EmergencyTimelineEvent> timeline;
  final int countdownSeconds;
  final double dispatchProgress;
  final int notificationCount;
  final DateTime? startedAt;
  final DateTime? resolvedAt;

  bool get isStandby => status == EmergencyStatus.standby;
  bool get isActive => status == EmergencyStatus.active;
  bool get isDispatching => status == EmergencyStatus.dispatching;
  bool get isNotified => status == EmergencyStatus.notified;
  bool get isResolved => status == EmergencyStatus.resolved;
  bool get isCancelled => status == EmergencyStatus.cancelled;

  bool get canStart => isStandby || isResolved || isCancelled;
  bool get canCancel => isActive || isDispatching;
  bool get canResolve => isActive || isDispatching || isNotified;

  int get notifiedContacts {
    return contacts.where((item) => item.notified).length;
  }

  String get heroTitle {
    return switch (status) {
      EmergencyStatus.standby => 'Family Alert siap digunakan',
      EmergencyStatus.active => 'Alert aktif — tetap tenang',
      EmergencyStatus.dispatching => 'Mengirim notifikasi bantuan',
      EmergencyStatus.notified => 'Keluarga sudah diberi tahu',
      EmergencyStatus.resolved => 'Emergency selesai',
      EmergencyStatus.cancelled => 'Emergency dibatalkan',
    };
  }

  String get heroSubtitle {
    return switch (status) {
      EmergencyStatus.standby =>
        'Tekan tombol besar di bawah jika membutuhkan bantuan keluarga atau AhliPeduli.',
      EmergencyStatus.active =>
        'Countdown berjalan. Sistem akan mengirim notifikasi otomatis bila tidak dibatalkan.',
      EmergencyStatus.dispatching =>
        'Kontak keluarga, AhliPeduli, dan ringkasan medis sedang disiapkan.',
      EmergencyStatus.notified =>
        'Simulasi notifikasi berhasil dikirim ke kontak darurat.',
      EmergencyStatus.resolved =>
        'Kejadian ditandai aman. Timeline tetap tersimpan sebagai log lokal.',
      EmergencyStatus.cancelled =>
        'Alert dihentikan. Sistem kembali bisa dipakai kapan saja.',
    };
  }

  PkTone get tone => status.tone;

  EmergencyState copyWith({
    EmergencyStatus? status,
    List<EmergencyContact>? contacts,
    List<EmergencyTimelineEvent>? timeline,
    int? countdownSeconds,
    double? dispatchProgress,
    int? notificationCount,
    DateTime? startedAt,
    DateTime? resolvedAt,
    bool clearResolvedAt = false,
  }) {
    return EmergencyState(
      status: status ?? this.status,
      contacts: contacts ?? this.contacts,
      timeline: timeline ?? this.timeline,
      countdownSeconds: countdownSeconds ?? this.countdownSeconds,
      dispatchProgress: dispatchProgress ?? this.dispatchProgress,
      notificationCount: notificationCount ?? this.notificationCount,
      startedAt: startedAt ?? this.startedAt,
      resolvedAt: clearResolvedAt ? null : resolvedAt ?? this.resolvedAt,
    );
  }

  factory EmergencyState.initial() {
    return EmergencyState(
      status: EmergencyStatus.standby,
      contacts: EmergencyMockData.contacts,
      timeline: [
        EmergencyMockData.initialTimelineEvent(),
      ],
      countdownSeconds: 5,
      dispatchProgress: 0,
      notificationCount: 0,
      startedAt: null,
      resolvedAt: null,
    );
  }
}

final emergencyProvider =
    NotifierProvider<EmergencyController, EmergencyState>(
  EmergencyController.new,
);

class EmergencyController extends Notifier<EmergencyState> {
  Timer? _timer;

  @override
  EmergencyState build() {
    ref.onDispose(_stopTimer);
    return EmergencyState.initial();
  }

  void startEmergency() {
    _stopTimer();

    state = EmergencyState.initial().copyWith(
      status: EmergencyStatus.active,
      countdownSeconds: 5,
      startedAt: DateTime.now(),
      clearResolvedAt: true,
      timeline: [
        EmergencyMockData.event(
          title: 'Emergency button ditekan',
          description: 'Alert aktif. Countdown 5 detik dimulai.',
          tone: PkTone.red,
          icon: Icons.touch_app_outlined,
        ),
      ],
    );

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _tick(),
    );
  }

  void cancelEmergency() {
    if (!state.canCancel) return;

    _stopTimer();

    state = state.copyWith(
      status: EmergencyStatus.cancelled,
      countdownSeconds: 5,
      dispatchProgress: 0,
      timeline: [
        EmergencyMockData.event(
          title: 'Alert dibatalkan',
          description: 'Emergency dihentikan sebelum proses selesai.',
          tone: PkTone.gray,
          icon: Icons.cancel_outlined,
        ),
        ...state.timeline,
      ],
    );
  }

  void resolveEmergency() {
    if (!state.canResolve) return;

    _stopTimer();

    state = state.copyWith(
      status: EmergencyStatus.resolved,
      dispatchProgress: 1,
      resolvedAt: DateTime.now(),
      timeline: [
        EmergencyMockData.event(
          title: 'Emergency selesai',
          description: 'Status ditandai aman oleh pengguna.',
          tone: PkTone.green,
          icon: Icons.check_circle_outline_rounded,
        ),
        ...state.timeline,
      ],
    );
  }

  void resetEmergency() {
    _stopTimer();
    state = EmergencyState.initial();
  }

  void triggerNotificationSimulation() {
    final updatedContacts = state.contacts
        .map((item) => item.copyWith(notified: true))
        .toList();

    state = state.copyWith(
      status: EmergencyStatus.notified,
      contacts: updatedContacts,
      notificationCount: updatedContacts.length,
      dispatchProgress: 1,
      timeline: [
        EmergencyMockData.event(
          title: 'Simulasi notifikasi terkirim',
          description:
              '${updatedContacts.length} kontak darurat menerima Family Alert.',
          tone: PkTone.blue,
          icon: Icons.notifications_active_outlined,
        ),
        ...state.timeline,
      ],
    );
  }

  void _tick() {
    if (state.isActive) {
      final nextCountdown = state.countdownSeconds - 1;

      if (nextCountdown <= 0) {
        state = state.copyWith(
          status: EmergencyStatus.dispatching,
          countdownSeconds: 0,
          dispatchProgress: 0.25,
          timeline: [
            EmergencyMockData.event(
              title: 'Countdown selesai',
              description: 'Sistem mulai dispatch notifikasi darurat.',
              tone: PkTone.amber,
              icon: Icons.timer_outlined,
            ),
            ...state.timeline,
          ],
        );
        return;
      }

      state = state.copyWith(countdownSeconds: nextCountdown);
      return;
    }

    if (state.isDispatching) {
      final nextProgress =
          (state.dispatchProgress + 0.25).clamp(0.0, 1.0).toDouble();

      if (nextProgress >= 1) {
        triggerNotificationSimulation();
        return;
      }

      final nextTimeline = [
        EmergencyMockData.event(
          title: _dispatchTitle(nextProgress),
          description: _dispatchDescription(nextProgress),
          tone: PkTone.amber,
          icon: Icons.local_shipping_outlined,
        ),
        ...state.timeline,
      ];

      state = state.copyWith(
        dispatchProgress: nextProgress,
        timeline: nextTimeline,
      );
    }
  }

  String _dispatchTitle(double progress) {
    if (progress <= 0.50) return 'Menghubungi keluarga';
    if (progress <= 0.75) return 'Mengirim ringkasan medis';
    return 'Mengaktifkan AhliPeduli standby';
  }

  String _dispatchDescription(double progress) {
    if (progress <= 0.50) {
      return 'Notifikasi prioritas dikirim ke kontak utama.';
    }

    if (progress <= 0.75) {
      return 'Data kondisi terakhir disiapkan untuk keluarga.';
    }

    return 'Partner AhliPeduli menerima simulasi status emergency.';
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
}