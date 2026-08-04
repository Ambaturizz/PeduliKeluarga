import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/pk_design.dart';
import '../../../../state/providers/app_mode_provider.dart';

class FamilyChatPage extends ConsumerStatefulWidget {
  const FamilyChatPage({super.key});

  @override
  ConsumerState<FamilyChatPage> createState() => _FamilyChatPageState();
}

class _FamilyChatPageState extends ConsumerState<FamilyChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<_FamilyChatMessage> _messages = [
    _FamilyChatMessage(
      text: 'Pagi, sudah sarapan dan minum obat belum?',
      time: '07:05',
      sentByMeInElderMode: false,
    ),
    _FamilyChatMessage(
      text: 'Sudah. Nanti saya isi PeduliCek juga ya.',
      time: '07:07',
      sentByMeInElderMode: true,
    ),
    _FamilyChatMessage(
      text: 'Baik, kalau butuh apa-apa langsung chat di sini.',
      time: '07:08',
      sentByMeInElderMode: false,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(appModeControllerProvider);
    final isElder = mode == AppUserMode.elder;
    final contactName = isElder ? 'Anak / Pendamping' : 'Orang Tua / Lansia';

    return PkGradientBackground(
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 10),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 920),
                  child: _ChatHeader(
                    contactName: contactName,
                    isElder: isElder,
                    onClearChat: () {
                      setState(() {
                        _messages.clear();
                      });
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 920),
                  child: _messages.isEmpty
                      ? _EmptyChatState(contactName: contactName)
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          reverse: true,
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final message = _messages[_messages.length - index - 1];
                            final isMine = isElder
                                ? message.sentByMeInElderMode
                                : !message.sentByMeInElderMode;

                            return _ChatBubble(
                              message: message,
                              isMine: isMine,
                              senderLabel: isMine ? 'Saya' : contactName,
                            );
                          },
                        ),
                ),
              ),
            ),
            _ChatInputBar(
              controller: _messageController,
              onSend: () => _sendMessage(isElder),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(bool isElder) {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now();
    final time =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    setState(() {
      _messages.add(
        _FamilyChatMessage(
          text: text,
          time: time,
          sentByMeInElderMode: isElder,
          status: MessageStatus.sent,
        ),
      );
      _messageController.clear();
    });

    Future<void>.delayed(const Duration(milliseconds: 450), () {
      if (!mounted) return;

      setState(() {
        if (_messages.isNotEmpty) {
           final last = _messages.last;
           _messages[_messages.length - 1] = last.copyWith(status: MessageStatus.delivered);
        }
      });

      Future<void>.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;

        setState(() {
          if (_messages.isNotEmpty) {
             final last = _messages.last;
             _messages[_messages.length - 1] = last.copyWith(status: MessageStatus.read);
          }
          _messages.add(
            _FamilyChatMessage(
              text: isElder
                  ? 'Pesan diterima keluarga. Tetap kabari kalau ada keluhan ya.'
                  : 'Pesan diterima lansia. Ini mockup chat keluarga internal.',
              time: time,
              sentByMeInElderMode: !isElder,
            ),
          );
        });
      });
    });
  }
}

enum MessageStatus { sent, delivered, read }

class _FamilyChatMessage {
  const _FamilyChatMessage({
    required this.text,
    required this.time,
    required this.sentByMeInElderMode,
    this.status = MessageStatus.read,
  });

  final String text;
  final String time;
  final bool sentByMeInElderMode;
  final MessageStatus status;

  _FamilyChatMessage copyWith({
    String? text,
    String? time,
    bool? sentByMeInElderMode,
    MessageStatus? status,
  }) {
    return _FamilyChatMessage(
      text: text ?? this.text,
      time: time ?? this.time,
      sentByMeInElderMode: sentByMeInElderMode ?? this.sentByMeInElderMode,
      status: status ?? this.status,
    );
  }
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({
    required this.contactName,
    required this.isElder,
    required this.onClearChat,
  });

  final String contactName;
  final bool isElder;
  final VoidCallback onClearChat;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      tint: PkColors.brandSoft,
      borderColor: PkColors.brand.withValues(alpha: 0.16),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/icons/pedulichat.webp',
                width: 32,
                height: 32,
              ),
              const SizedBox(width: PkSpacing.md),
              Expanded(
                child: Text(
                  'PeduliChat Keluarga',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: PkColors.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
              const PkBadge(
                label: 'Mock chat',
                tone: PkTone.brand,
                icon: Icons.chat_bubble_outline_rounded,
              ),
              const SizedBox(width: PkSpacing.sm),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: PkColors.red),
                tooltip: 'Hapus Chat',
                onPressed: onClearChat,
              ),
            ],
          ),
          const SizedBox(height: PkSpacing.sm),
          Text(
            'Chat langsung dengan $contactName. Fitur ini berbeda dari PeduliKonsul yang digunakan untuk konsultasi tenaga kesehatan.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: PkColors.text2,
                  height: 1.45,
                ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    required this.message,
    required this.isMine,
    required this.senderLabel,
  });

  final _FamilyChatMessage message;
  final bool isMine;
  final String senderLabel;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 620),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isMine ? PkColors.brand : PkColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMine ? 20 : 6),
            bottomRight: Radius.circular(isMine ? 6 : 20),
          ),
          border: Border.all(
            color: isMine ? PkColors.brand : PkColors.line,
          ),
          boxShadow: PkShadow.xs,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              senderLabel,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isMine ? Colors.white70 : PkColors.muted,
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 5),
            Text(
              message.text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isMine ? Colors.white : PkColors.text,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.time,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isMine ? Colors.white70 : PkColors.muted,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  if (isMine) ...[
                    const SizedBox(width: 4),
                    Icon(
                      message.status == MessageStatus.read
                          ? Icons.done_all_rounded
                          : message.status == MessageStatus.delivered
                              ? Icons.done_all_rounded
                              : Icons.check_rounded,
                      size: 14,
                      color: message.status == MessageStatus.read
                          ? Colors.blue.shade200
                          : Colors.white70,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyChatState extends StatelessWidget {
  const _EmptyChatState({required this.contactName});
  
  final String contactName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.mark_chat_unread_rounded,
            size: 64,
            color: PkColors.brand.withValues(alpha: 0.2),
          ),
          const SizedBox(height: PkSpacing.md),
          Text(
            'Belum ada percakapan',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: PkColors.text,
                ),
          ),
          const SizedBox(height: PkSpacing.xs),
          Text(
            'Mulai sapa $contactName sekarang.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: PkColors.text2,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  const _ChatInputBar({
    required this.controller,
    required this.onSend,
  });

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: PkColors.surface.withValues(alpha: 0.96),
        border: Border(top: BorderSide(color: PkColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      minLines: 1,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Tulis pesan keluarga',
                        hintText: 'Contoh: Saya sudah minum obat',
                        prefixIcon: Icon(Icons.edit_outlined),
                      ),
                      onSubmitted: (_) => onSend(),
                    ),
                  ),
                  const SizedBox(width: PkSpacing.sm),
                  FilledButton(
                    onPressed: onSend,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(58, 58),
                      shape: const CircleBorder(),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
