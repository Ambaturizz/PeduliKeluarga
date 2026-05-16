import 'package:flutter_riverpod/flutter_riverpod.dart';

class KonsulMessage {
  const KonsulMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.createdAt,
  });

  final String id;
  final String text;
  final KonsulSender sender;
  final DateTime createdAt;

  bool get isUser => sender == KonsulSender.user;
}

enum KonsulSender { user, doctor }

class PeduliKonsulState {
  const PeduliKonsulState({
    required this.messages,
    this.showAhliPeduliCta = false,
  });

  final List<KonsulMessage> messages;
  final bool showAhliPeduliCta;

  PeduliKonsulState copyWith({
    List<KonsulMessage>? messages,
    bool? showAhliPeduliCta,
  }) {
    return PeduliKonsulState(
      messages: messages ?? this.messages,
      showAhliPeduliCta: showAhliPeduliCta ?? this.showAhliPeduliCta,
    );
  }
}

final peduliKonsulProvider = NotifierProvider<PeduliKonsulController, PeduliKonsulState>(
  PeduliKonsulController.new,
);

class PeduliKonsulController extends Notifier<PeduliKonsulState> {
  @override
  PeduliKonsulState build() {
    return PeduliKonsulState(
      messages: [
        KonsulMessage(
          id: 'welcome',
          text: 'Halo, saya dokter pendamping PeduliKonsul. Ceritakan keluhan ringan yang dirasakan hari ini.',
          sender: KonsulSender.doctor,
          createdAt: DateTime.now(),
        ),
      ],
    );
  }

  void send(String text) {
    final clean = text.trim();
    if (clean.isEmpty) return;

    final now = DateTime.now();
    final needsDoctor = _needsDoctorFollowUp(clean);

    final reply = needsDoctor
        ? 'Terima kasih sudah cerita. Keluhan ini sebaiknya dibahas langsung dengan dokter. Saya belum bisa memberi diagnosis. Silakan lanjut ke AhliPeduli atau gunakan PeduliDarurat bila terasa berat.'
        : 'Terima kasih. Catat keluhan ini, istirahat, minum air cukup, dan pantau perubahan. Jika keluhan memburuk atau membuat Bapak/Ibu khawatir, lanjutkan konsultasi dokter.';

    state = state.copyWith(
      showAhliPeduliCta: state.showAhliPeduliCta || needsDoctor,
      messages: [
        ...state.messages,
        KonsulMessage(
          id: 'user-${now.microsecondsSinceEpoch}',
          text: clean,
          sender: KonsulSender.user,
          createdAt: now,
        ),
        KonsulMessage(
          id: 'doctor-${now.microsecondsSinceEpoch}',
          text: reply,
          sender: KonsulSender.doctor,
          createdAt: now.add(const Duration(seconds: 1)),
        ),
      ],
    );
  }

  bool _needsDoctorFollowUp(String text) {
    final value = text.toLowerCase();
    return value.contains('sesak') ||
        value.contains('nyeri dada') ||
        value.contains('pingsan') ||
        value.contains('gula darah tinggi') ||
        value.contains('darah tinggi') ||
        value.contains('lemas sekali') ||
        value.contains('jatuh');
  }
}
