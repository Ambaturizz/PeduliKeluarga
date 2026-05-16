import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/pk_design.dart';
import '../../../../state/providers/app_mode_provider.dart';
import '../../../peduli_antar/providers/peduli_antar_provider.dart';
import '../../data/medication_dummy_data.dart';
import '../../providers/peduli_obat_provider.dart';
import '../widgets/peduli_obat_widgets.dart';

class PeduliObatPage extends ConsumerWidget {
  const PeduliObatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(peduliObatProvider);
    final notifier = ref.read(peduliObatProvider.notifier);

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
                      MedicationPageHero(
                        state: state,
                        onReset: notifier.resetDemo,
                      ),
                      const SizedBox(height: 22),
                      MedicationLowStockWarning(
                        items: state.lowStockMedications,
                        onReorder: (item) {
                          _reorderSingle(
                            context: context,
                            ref: ref,
                            notifier: notifier,
                            medication: item,
                          );
                        },
                      ),
                      const PkSectionTitle(
                        title: 'Jadwal Obat',
                        subtitle: 'Jadwal dan catatan harian',
                      ),
                      PeduliObatResponsiveGrid(
                        left: [
                          MedicationScheduleCard(
                            schedules: state.schedules,
                            takenIds: state.takenScheduleIds,
                            onMarkTaken: (id) {
                              notifier.markScheduleTaken(id);
                              _showMessage(
                                context,
                                'Jadwal obat ditandai diminum.',
                              );
                            },
                            onUndo: (id) {
                              notifier.undoSchedule(id);
                              _showMessage(
                                context,
                                'Status obat dikembalikan menjadi menunggu.',
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          MedicationAdherenceCard(state: state),
                          const SizedBox(height: 16),
                          MedicationHistoryCard(logs: state.logs),
                          const SizedBox(height: 16),
                        ],
                        right: [
                          MedicationReminderCard(
                            reminders: state.reminders,
                            enabled: state.reminderEnabled,
                            onToggle: notifier.toggleReminder,
                          ),
                          const SizedBox(height: 16),
                          MedicationReorderCta(
                            lowStockItems: state.lowStockMedications,
                            onReorderAll: () {
                              final items = List<MedicationModel>.from(
                                state.lowStockMedications,
                              );

                              for (final item in items) {
                                ref.read(peduliAntarProvider.notifier).createRequest(item);
                                notifier.requestMedicationPurchase(item.id);
                              }

                              context.go(AppRoutes.peduliAntarPath);
                              final mode = ref.read(appModeControllerProvider);
                              _showMessage(
                                context,
                                mode == AppUserMode.caregiver
                                    ? 'Draft pesanan dibuat. Periksa detail lalu tekan Konfirmasi Pesanan.'
                                    : 'Permintaan pembelian obat sudah dikirim ke keluarga. Tunggu konfirmasi dari anak atau pendamping.',
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                      const PkSectionTitle(
                        title: 'Stok Obat',
                        subtitle: 'Pantau sisa obat',
                      ),
                      MedicationStockGrid(
                        medications: state.medications,
                        onReorder: (item) {
                          _reorderSingle(
                            context: context,
                            ref: ref,
                            notifier: notifier,
                            medication: item,
                          );
                        },
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

  void _reorderSingle({
    required BuildContext context,
    required WidgetRef ref,
    required PeduliObatController notifier,
    required MedicationModel medication,
  }) {
    ref.read(peduliAntarProvider.notifier).createRequest(medication);
    notifier.requestMedicationPurchase(medication.id);

    context.go(AppRoutes.peduliAntarPath);
    final mode = ref.read(appModeControllerProvider);
    _showMessage(
      context,
      mode == AppUserMode.caregiver
          ? 'Draft pesanan dibuat. Periksa detail lalu tekan Konfirmasi Pesanan.'
          : 'Permintaan pembelian obat sudah dikirim ke keluarga. Tunggu konfirmasi dari anak atau pendamping.',
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
