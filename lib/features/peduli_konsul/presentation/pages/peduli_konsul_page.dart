import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/pk_design.dart';
import '../../../../core/utils/responsive.dart';
import '../../providers/peduli_konsul_provider.dart';

class PeduliKonsulPage extends ConsumerStatefulWidget {
  const PeduliKonsulPage({super.key});

  @override
  ConsumerState<PeduliKonsulPage> createState() => _PeduliKonsulPageState();
}

class _PeduliKonsulPageState extends ConsumerState<PeduliKonsulPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send([String? quickText]) {
    final text = quickText ?? _controller.text;
    ref.read(peduliKonsulProvider.notifier).send(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(peduliKonsulProvider);

    return PkGradientBackground(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.horizontalPagePadding,
            vertical: PkSpacing.xxl,
          ),
          child: ResponsiveCenter(
            maxWidth: 900,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(
                  onAhliPeduli: () => context.go(AppRoutes.ahliPeduliPath),
                ),
                const SizedBox(height: PkSpacing.lg),
                Expanded(
                  child: PkCard(
                    padding: const EdgeInsets.all(PkSpacing.lg),
                    child: ListView.separated(
                      itemCount: state.messages.length,
                      separatorBuilder: (context, index) => const SizedBox(height: PkSpacing.md),
                      itemBuilder: (context, index) {
                        return _MessageBubble(message: state.messages[index]);
                      },
                    ),
                  ),
                ),
                if (state.showAhliPeduliCta) ...[
                  const SizedBox(height: PkSpacing.md),
                  FilledButton.icon(
                    onPressed: () => context.go(AppRoutes.ahliPeduliPath),
                    icon: const Icon(Icons.health_and_safety_outlined),
                    label: const Text('Lanjut ke AhliPeduli'),
                  ),
                ],
                const SizedBox(height: PkSpacing.md),
                Wrap(
                  spacing: PkSpacing.sm,
                  runSpacing: PkSpacing.sm,
                  children: [
                    _QuickButton(label: 'Saya pusing', onTap: () => _send('Saya pusing')),
                    _QuickButton(label: 'Gula darah tinggi', onTap: () => _send('Gula darah tinggi')),
                    _QuickButton(label: 'Obat hampir habis', onTap: () => _send('Obat hampir habis')),
                  ],
                ),
                const SizedBox(height: PkSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        minLines: 1,
                        maxLines: 3,
                        style: Theme.of(context).textTheme.bodyLarge,
                        decoration: const InputDecoration(
                          hintText: 'Tulis keluhan singkat...',
                          prefixIcon: Icon(Icons.chat_bubble_outline_rounded),
                        ),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                    const SizedBox(width: PkSpacing.sm),
                    FilledButton.icon(
                      onPressed: _send,
                      icon: const Icon(Icons.send_rounded),
                      label: const Text('Kirim'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onAhliPeduli});

  final VoidCallback onAhliPeduli;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      tint: PkColors.brandSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const PkIconBox(icon: Icons.chat_bubble_outline_rounded, tone: PkTone.brand),
              const SizedBox(width: PkSpacing.md),
              Expanded(
                child: Text(
                  'PeduliKonsul',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: PkColors.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: onAhliPeduli,
                icon: const Icon(Icons.health_and_safety_outlined),
                label: const Text('AhliPeduli'),
              ),
            ],
          ),
          const SizedBox(height: PkSpacing.md),
          Text(
            'Chat awal untuk keluhan ringan. PeduliKonsul tidak menggantikan diagnosis dokter.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: PkColors.text2,
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final KonsulMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 620),
        padding: const EdgeInsets.all(PkSpacing.md),
        decoration: BoxDecoration(
          color: message.isUser ? PkColors.brand : PkColors.surfaceSoft,
          borderRadius: PkRadius.mdRadius,
          border: Border.all(color: PkColors.line),
        ),
        child: Text(
          message.text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: message.isUser ? Colors.white : PkColors.text,
                height: 1.55,
              ),
        ),
      ),
    );
  }
}

class _QuickButton extends StatelessWidget {
  const _QuickButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      child: Text(label),
    );
  }
}
