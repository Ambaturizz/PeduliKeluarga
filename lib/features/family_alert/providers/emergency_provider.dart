import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/pk_design.dart';
import '../data/emergency_mock_data.dart';

class DaruratState {
  const DaruratState({
    required this.status,
    required this.contacts,
    required this.timeline,
    required this.countdownSeconds,
    required this.dispatchProgress,
    required this.notificationCount,
    required this.startedAt,
    required this.resolvedAt,
  });

  final DaruratStatus status;
  final List<DaruratContact> contacts;
  final List<DaruratTimelineEvent> timeline;
  final int countdownSeconds;
  final double dispatchProgress;
  final int notificationCount;
  final DateTime? startedAt;
  final DateTime? resolvedAt;

  bool get isStandby => status == DaruratStatus.standby;
  bool get isActive => status == DaruratStatus.active;
  bool get isDispatching => status == DaruratStatus.dispatching;
  bool get isNotified => status == DaruratStatus.notified;
  bool get isResolved => status == DaruratStatus.resolved;
  bool get isCancelled => status == DaruratStatus.cancelled;

  bool get canStart => isStandby || isResolved || isCancelled;
  bool get canCancel => isActive || isDispatching;
  bool get canResolve => isActive || isDispatching || isNotified;

  int get notifiedContacts => contacts.where((item) => item.notified).length;

  String get heroTitle {
    return switch (status) {
      DaruratStatus.standby => 'PeduliDarurat siap digunakan',
      DaruratStatus.active => 'PeduliDarurat aktif — tetap tenang',
      DaruratStatus.dispatching => 'Mengirim notifikasi bantuan',
      DaruratStatus.notified => 'Keluarga sudah diberi tahu',
      DaruratStatus.resolved => 'Darurat selesai',
      DaruratStatus.cancelled => 'Darurat dibatalkan',
    };
  }

  String get heroSubtitle {
    return switch (status) {
      DaruratStatus.standby =>
        'Tekan tombol besar di bawah jika membutuhkan bantuan keluarga atau AhliPeduli.',
      DaruratStatus.active =>
        'Hitungan mundur berjalan. Sistem akan mengirim notifikasi otomatis bila tidak dibatalkan.',
      DaruratStatus.dispatching =>
        'Kontak keluarga, AhliPeduli, dan ringkasan medis sedang disiapkan.',
      DaruratStatus.notified =>
        'Simulasi notifikasi berhasil dikirim ke kontak darurat.',
      DaruratStatus.resolved =>
        'Kejadian ditandai aman. Riwayat tetap tersimpan sebagai catatan lokal.',
      DaruratStatus.cancelled =>
        'PeduliDarurat dihentikan. Sistem kembali bisa dipakai kapan saja.',
    };
  }

  PkTone get tone => status.tone;

  DaruratState copyWith({
    DaruratStatus? status,
    List<DaruratContact>? contacts,
    List<DaruratTimelineEvent>? timeline,
    int? countdownSeconds,
    double? dispatchProgress,
    int? notificationCount,
    DateTime? startedAt,
    DateTime? resolvedAt,
    bool clearResolvedAt = false,
  }) {
    return DaruratState(
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

  factory DaruratState.initial() {
    return DaruratState(
      status: DaruratStatus.standby,
      contacts: DaruratMockData.contacts,
      timeline: [DaruratMockData.initialTimelineEvent()],
      countdownSeconds: 5,
      dispatchProgress: 0,
      notificationCount: 0,
      startedAt: null,
      resolvedAt: null,
    );
  }
}

final emergencyProvider = NotifierProvider<DaruratController, DaruratState>(
  DaruratController.new,
);

class DaruratController extends Notifier<DaruratState> {
  Timer? _timer;

  @override
  DaruratState build() {
    ref.onDispose(_stopTimer);
    return DaruratState.initial();
  }

  void startDarurat() {
    _stopTimer();

    state = DaruratState.initial().copyWith(
      status: DaruratStatus.active,
      countdownSeconds: 5,
      startedAt: DateTime.now(),
      clearResolvedAt: true,
      timeline: [
        DaruratMockData.event(
          title: 'Tombol darurat ditekan',
          description: 'PeduliDarurat aktif. Hitungan mundur 5 detik dimulai.',
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

  void cancelDarurat() {
    if (!state.canCancel) return;
    _stopTimer();

    state = state.copyWith(
      status: DaruratStatus.cancelled,
      countdownSeconds: 5,
      dispatchProgress: 0,
      timeline: [
        DaruratMockData.event(
          title: 'PeduliDarurat dibatalkan',
          description: 'Darurat dihentikan sebelum proses selesai.',
          tone: PkTone.gray,
          icon: Icons.cancel_outlined,
        ),
        ...state.timeline,
      ],
    );
  }

  void resolveDarurat() {
    if (!state.canResolve) return;
    _stopTimer();

    state = state.copyWith(
      status: DaruratStatus.resolved,
      dispatchProgress: 1,
      resolvedAt: DateTime.now(),
      timeline: [
        DaruratMockData.event(
          title: 'Darurat selesai',
          description: 'Status ditandai aman oleh pengguna.',
          tone: PkTone.green,
          icon: Icons.check_circle_outline_rounded,
        ),
        ...state.timeline,
      ],
    );
  }

  void resetDarurat() {
    _stopTimer();
    state = DaruratState.initial();
  }

  void triggerNotificationSimulation() {
    final updatedContacts = state.contacts
        .map((item) => item.copyWith(notified: true))
        .toList();

    state = state.copyWith(
      status: DaruratStatus.notified,
      contacts: updatedContacts,
      notificationCount: updatedContacts.length,
      dispatchProgress: 1,
      timeline: [
        DaruratMockData.event(
          title: 'Simulasi notifikasi terkirim',
          description:
              '${updatedContacts.length} kontak darurat menerima PeduliDarurat.',
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
          status: DaruratStatus.dispatching,
          countdownSeconds: 0,
          dispatchProgress: 0.25,
          timeline: [
            DaruratMockData.event(
              title: 'Hitungan mundur selesai',
              description: 'Sistem mulai mengirim notifikasi darurat.',
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

      state = state.copyWith(
        dispatchProgress: nextProgress,
        timeline: [
          DaruratMockData.event(
            title: _dispatchTitle(nextProgress),
            description: _dispatchDescription(nextProgress),
            tone: PkTone.amber,
            icon: Icons.local_shipping_outlined,
          ),
          ...state.timeline,
        ],
      );
    }
  }

  String _dispatchTitle(double progress) {
    if (progress <= 0.50) return 'Menghubungi keluarga';
    if (progress <= 0.75) return 'Mengirim ringkasan medis';
    return 'Mengaktifkan AhliPeduli siaga';
  }

  String _dispatchDescription(double progress) {
    if (progress <= 0.50) {
      return 'Notifikasi prioritas dikirim ke kontak utama.';
    }
    if (progress <= 0.75) {
      return 'Data kondisi terakhir disiapkan untuk keluarga.';
    }
    return 'Partner AhliPeduli menerima simulasi status PeduliDarurat.';
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
