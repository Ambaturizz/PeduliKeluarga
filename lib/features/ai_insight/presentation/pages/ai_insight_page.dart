import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/pk_design.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/app_top_bar.dart';
import '../../../../state/providers/app_mode_provider.dart';

// ─── Data Model ────────────────────────────────────────────────
class AiMessage {
  const AiMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
}

// ─── State ─────────────────────────────────────────────────────
class AiInsightState {
  const AiInsightState({
    this.messages = const [],
    this.isTyping = false,
    this.error,
  });

  final List<AiMessage> messages;
  final bool isTyping;
  final String? error;

  AiInsightState copyWith({
    List<AiMessage>? messages,
    bool? isTyping,
    String? error,
    bool clearError = false,
  }) {
    return AiInsightState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      error: clearError ? null : error ?? this.error,
    );
  }
}

// ─── Simulated AI Responses ────────────────────────────────────
const _aiResponses = {
  'tekanan darah':
      'Tekanan darah normal untuk lansia adalah sekitar 120/80 mmHg. Jika tekanan darah sering di atas 140/90 mmHg, disebut hipertensi. Pastikan rutin cek tekanan darah, kurangi konsumsi garam, dan konsultasikan dengan dokter mengenai obat yang tepat.',
  'gula darah':
      'Kadar gula darah puasa normal adalah 70–110 mg/dL. Untuk lansia dengan diabetes, target umumnya 80–130 mg/dL sebelum makan. Penting untuk rutin cek dan konsumsi obat sesuai anjuran dokter.',
  'obat':
      'Penggunaan obat pada lansia perlu hati-hati karena metabolisme tubuh melambat. Selalu minum obat sesuai dosis dan waktu yang diresepkan. Catat semua obat yang diminum dan tunjukkan ke dokter saat kontrol.',
  'jatuh':
      'Risiko jatuh pada lansia bisa dikurangi dengan: memasang pegangan di kamar mandi, menggunakan alas kaki anti-selip, pencahayaan yang cukup di malam hari, dan latihan keseimbangan ringan secara rutin.',
  'tidur':
      'Lansia umumnya membutuhkan 7–8 jam tidur per malam. Kualitas tidur yang baik mendukung kesehatan jantung, otak, dan imunitas. Hindari kafein setelah sore hari dan ciptakan rutinitas tidur yang teratur.',
  'makan':
      'Nutrisi penting untuk lansia meliputi protein cukup (ayam, ikan, telur), kalsium (susu, tahu, tempe), serat (sayur dan buah), serta minum air putih minimal 6–8 gelas per hari. Hindari makanan tinggi garam dan lemak jenuh.',
  'olahraga':
      'Olahraga ringan yang aman untuk lansia antara lain: jalan kaki 30 menit/hari, senam lansia, renang, atau yoga ringan. Penting untuk tidak memaksakan diri dan selalu warmup sebelum berolahraga.',
  'ingatan':
      'Penurunan daya ingat ringan adalah normal pada proses penuaan. Aktivitas yang membantu: membaca buku, teka-teki silang, bermain catur, bergabung dalam kegiatan sosial, dan tidur cukup. Jika gangguan ingatan berat, segera konsultasi dokter.',
  'pernapasan':
      'Sesak napas pada lansia bisa disebabkan banyak hal: penyakit jantung, PPOK, anemia, atau infeksi. Jika sesak napas tiba-tiba atau disertai nyeri dada, segera hubungi layanan darurat. Jangan abaikan gejala ini.',
};

const _defaultResponse =
    'Terima kasih atas pertanyaan Anda. Sebagai asisten kesehatan AI, saya dapat membantu dengan informasi umum tentang kesehatan lansia. Untuk diagnosis atau pengobatan yang tepat, selalu konsultasikan dengan dokter atau tenaga medis profesional. Apakah ada topik kesehatan spesifik yang ingin Anda tanyakan?';

// ─── Provider ──────────────────────────────────────────────────
final aiInsightProvider =
    NotifierProvider<AiInsightController, AiInsightState>(
  AiInsightController.new,
);

class AiInsightController extends Notifier<AiInsightState> {
  @override
  AiInsightState build() {
    return AiInsightState(
      messages: [
        AiMessage(
          id: 'welcome',
          text:
              'Halo! Saya AIPeduli, asisten kesehatan digital Anda. Saya siap membantu menjawab pertanyaan seputar kesehatan lansia, tips perawatan, dan informasi medis umum.\n\nApa yang ingin Anda tanyakan hari ini?',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      ],
    );
  }

  Future<void> sendMessage(String text) async {
    final clean = text.trim();
    if (clean.isEmpty || state.isTyping) return;

    final now = DateTime.now();
    final userMsg = AiMessage(
      id: 'user-${now.microsecondsSinceEpoch}',
      text: clean,
      isUser: true,
      timestamp: now,
    );

    // Add user message + show typing indicator
    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isTyping: true,
      clearError: true,
    );

    // Simulate AI thinking delay (600ms–1.5s)
    final lower = clean.toLowerCase();
    String reply = _defaultResponse;
    for (final entry in _aiResponses.entries) {
      if (lower.contains(entry.key)) {
        reply = entry.value;
        break;
      }
    }

    await Future<void>.delayed(const Duration(milliseconds: 1200));

    final aiMsg = AiMessage(
      id: 'ai-${DateTime.now().microsecondsSinceEpoch}',
      text: reply,
      isUser: false,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, aiMsg],
      isTyping: false,
    );
  }

  void clearChat() {
    state = build();
  }
}

// ─── Quick Prompts ─────────────────────────────────────────────
const _quickPrompts = [
  '💊 Soal obat lansia',
  '❤️ Tekanan darah tinggi',
  '🩸 Gula darah',
  '🏃 Olahraga aman',
  '🧠 Tips daya ingat',
  '🍽️ Nutrisi lansia',
];

// ─── Page ──────────────────────────────────────────────────────
class AiInsightPage extends ConsumerStatefulWidget {
  const AiInsightPage({super.key});

  @override
  ConsumerState<AiInsightPage> createState() => _AiInsightPageState();
}

class _AiInsightPageState extends ConsumerState<AiInsightPage> {
  late final TextEditingController _controller;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send([String? quickText]) {
    final text = quickText ?? _controller.text;
    if (text.trim().isEmpty) return;
    ref.read(aiInsightProvider.notifier).sendMessage(text);
    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiInsightProvider);
    final mode = ref.watch(appModeControllerProvider);
    final isElder = mode == AppUserMode.elder;

    // Auto-scroll when new messages arrive
    ref.listen(aiInsightProvider, (prev, next) {
      if (next.messages.length != prev?.messages.length) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      appBar: const AppTopBar(),
      body: PkGradientBackground(
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.horizontalPagePadding,
          ),
          child: ResponsiveCenter(
            maxWidth: 900,
            child: Column(
              children: [
                // ── Header ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 22, 0, 16),
                  child: _AiHeader(
                    isElder: isElder,
                    onClear: () =>
                        ref.read(aiInsightProvider.notifier).clearChat(),
                  ),
                ),

                // ── Quick Prompts ───────────────────────────────
                if (state.messages.length <= 1) ...[
                  _QuickPromptsRow(onTap: _send),
                  const SizedBox(height: 16),
                ],

                // ── Message List ────────────────────────────────
                Expanded(
                  child: PkCard(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      children: [
                        Expanded(
                          child: state.messages.isEmpty
                              ? const _EmptyState()
                              : ListView.builder(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.all(PkSpacing.md),
                                  itemCount: state.messages.length +
                                      (state.isTyping ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index == state.messages.length &&
                                        state.isTyping) {
                                      return const _TypingIndicator();
                                    }
                                    final msg = state.messages[index];
                                    return _MessageBubble(message: msg);
                                  },
                                ),
                        ),
                        if (state.error != null)
                          _ErrorBanner(message: state.error!),
                      ],
                    ),
                  ),
                ),

                // ── Input Bar ───────────────────────────────────
                const SizedBox(height: PkSpacing.md),
                _InputBar(
                  controller: _controller,
                  isTyping: state.isTyping,
                  onSend: _send,
                ),
                const SizedBox(height: PkSpacing.md),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}

// ─── Widgets ───────────────────────────────────────────────────

class _AiHeader extends StatelessWidget {
  const _AiHeader({required this.isElder, required this.onClear});
  final bool isElder;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/icons/aipeduli.webp',
          width: 44,
          height: 44,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AIPeduli',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: PkColors.text,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF22C55E),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Asisten kesehatan aktif',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: PkColors.text2,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Bersihkan percakapan',
          icon: const Icon(Icons.refresh_rounded),
          onPressed: onClear,
        ),
      ],
    );
  }
}

class _QuickPromptsRow extends StatelessWidget {
  const _QuickPromptsRow({required this.onTap});
  final void Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _quickPrompts.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final prompt = _quickPrompts[index];
          return GestureDetector(
            onTap: () => onTap(prompt),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: PkColors.brandSoft,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: PkColors.brand.withValues(alpha: 0.25)),
              ),
              child: Text(
                prompt,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: PkColors.brand,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});
  final AiMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.only(right: 8, top: 2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [PkColors.blue, PkColors.brand],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.psychology_rounded,
                  color: Colors.white, size: 16),
            ),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser ? PkColors.brand : PkColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                border: isUser
                    ? null
                    : Border.all(color: PkColors.line),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isUser ? Colors.white : PkColors.text,
                          height: 1.5,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isUser
                              ? Colors.white.withValues(alpha: 0.7)
                              : PkColors.muted,
                          fontSize: 10,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      )..repeat(
          reverse: true,
          period: Duration(milliseconds: 600 + i * 150),
        ),
    );
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.only(right: 8, top: 2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [PkColors.blue, PkColors.brand],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.psychology_rounded,
                color: Colors.white, size: 16),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: PkColors.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(color: PkColors.line),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return AnimatedBuilder(
                  animation: _controllers[i],
                  builder: (context, _) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 7,
                      height: 7 + (_controllers[i].value * 4),
                      decoration: BoxDecoration(
                        color: PkColors.brand
                            .withValues(alpha: 0.5 + _controllers[i].value * 0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.isTyping,
    required this.onSend,
  });
  final TextEditingController controller;
  final bool isTyping;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            minLines: 1,
            maxLines: 3,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => onSend(),
            enabled: !isTyping,
            decoration: InputDecoration(
              hintText: isTyping
                  ? 'AIPeduli sedang membalas...'
                  : 'Tanyakan seputar kesehatan lansia...',
              prefixIcon: const Icon(Icons.chat_bubble_outline_rounded),
            ),
          ),
        ),
        const SizedBox(width: PkSpacing.sm),
        FilledButton(
          onPressed: isTyping ? null : onSend,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.all(14),
            minimumSize: const Size(52, 52),
          ),
          child: isTyping
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.send_rounded),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.psychology_outlined, size: 48, color: PkColors.muted),
          const SizedBox(height: 12),
          Text(
            'Mulai bertanya ke AIPeduli',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: PkColors.text2,
                ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: PkColors.redSoft,
      child: Text(
        message,
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: PkColors.red),
        textAlign: TextAlign.center,
      ),
    );
  }
}
