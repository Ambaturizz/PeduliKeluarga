import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/pk_design.dart';
import '../../providers/emergency_provider.dart';
import '../widgets/family_alert_widgets.dart';

class FamilyAlertPage extends ConsumerWidget {
  const FamilyAlertPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(emergencyProvider);
    final controller = ref.read(emergencyProvider.notifier);

    return PkGradientBackground(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              _horizontalPadding(context),
              26,
              _horizontalPadding(context),
              72,
            ),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FamilyPeduliDaruratHero(
                        state: state,
                        onOpenModal: () {
                          _openDaruratModal(
                            context: context,
                            onConfirm: controller.startDarurat,
                          );
                        },
                      ),
                      const SizedBox(height: 22),
                      DaruratButtonCard(
                        state: state,
                        onStart: () {
                          _openDaruratModal(
                            context: context,
                            onConfirm: controller.startDarurat,
                          );
                        },
                        onCancel: controller.cancelDarurat,
                        onResolve: controller.resolveDarurat,
                      ),
                      const PkSectionTitle(
                        title: 'PeduliDarurat',
                        subtitle: 'Status dan bantuan',
                      ),
                      DaruratResponsiveGrid(
                        left: [
                          PeduliDaruratStatusCard(state: state),
                          const SizedBox(height: 16),
                          DispatchTrackingCard(
                            progress: state.dispatchProgress,
                          ),
                          const SizedBox(height: 16),
                          DaruratTimelineCard(events: state.timeline),
                          const SizedBox(height: 16),
                        ],
                        right: [
                          DaruratContactsCard(contacts: state.contacts),
                          const SizedBox(height: 16),
                          const DaruratMedicalSummaryCard(),
                          const SizedBox(height: 16),
                          _ResetCard(
                            onReset: controller.resetDarurat,
                            onNotify: controller.triggerNotificationSimulation,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 640) return 16;
    if (width < 920) return 20;
    return 24;
  }

  void _openDaruratModal({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: false,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(PkRadius.lg),
        ),
      ),
      builder: (context) {
        return DaruratConfirmSheet(onConfirm: onConfirm);
      },
    );
  }
}

class _ResetCard extends StatelessWidget {
  const _ResetCard({
    required this.onReset,
    required this.onNotify,
  });

  final VoidCallback onReset;
  final VoidCallback onNotify;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      clean: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PkBadge(
            label: 'Tombol PeduliDarurat',
            tone: PkTone.brand,
            icon: Icons.touch_app_outlined,
          ),
          const SizedBox(height: 12),
          Text(
            'Kontrol simulasi',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: PkColors.text,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Gunakan tombol ini untuk mencoba simulasi notifikasi atau mengembalikan status ke siaga.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: PkColors.text2,
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: PkColors.brand,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(54),
                shape: const StadiumBorder(),
              ),
              onPressed: onNotify,
              icon: const Icon(Icons.notifications_active_outlined),
              label: const Text('Simulasikan Notifikasi'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: PkColors.text2,
                minimumSize: const Size.fromHeight(54),
                shape: const StadiumBorder(),
              ),
              onPressed: onReset,
              icon: const Icon(Icons.restart_alt_rounded),
              label: const Text('Kembali ke Siaga'),
            ),
          ),
        ],
      ),
    );
  }
}
