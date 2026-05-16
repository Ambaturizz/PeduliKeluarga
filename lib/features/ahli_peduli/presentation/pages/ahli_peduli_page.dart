import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/pk_design.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/states/app_state_widgets.dart';
import '../../../caregiver_profile/providers/caregiver_profile_provider.dart';
import '../../../elder_profile/providers/elder_profile_provider.dart';
import '../../data/ahli_peduli_mock_data.dart';
import '../../domain/healthcare_provider.dart';
import '../../providers/ahli_peduli_booking_provider.dart';
import '../widgets/healthcare_provider_card.dart';

class AhliPeduliPage extends ConsumerStatefulWidget {
  const AhliPeduliPage({super.key});

  @override
  ConsumerState<AhliPeduliPage> createState() => _AhliPeduliPageState();
}

class _AhliPeduliPageState extends ConsumerState<AhliPeduliPage> {
  ProviderCategory? _selectedCategory;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final providers = ahliPeduliProviders.where((provider) {
      final matchesCategory =
          _selectedCategory == null || provider.category == _selectedCategory;
      final matchesSearch = query.isEmpty ||
          provider.name.toLowerCase().contains(query) ||
          provider.speciality.toLowerCase().contains(query) ||
          provider.location.toLowerCase().contains(query) ||
          provider.tags.any((tag) => tag.toLowerCase().contains(query));

      return matchesCategory && matchesSearch;
    }).toList()
      ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

    final daruratProviders = ahliPeduliProviders
        .where((provider) => provider.isDaruratReady)
        .toList()
      ..sort((a, b) => a.etaMinutes.compareTo(b.etaMinutes));
    final bookingState = ref.watch(ahliPeduliBookingProvider);

    return PkGradientBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: context.horizontalPagePadding,
            vertical: PkSpacing.xxl,
          ),
          child: ResponsiveCenter(
            maxWidth: 1180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AhliPeduliHero(
                  onDaruratTap: () =>
                      _showDaruratSheet(context, daruratProviders),
                ),
                const SizedBox(height: PkSpacing.xl),
                _NetworkMetricGrid(metrics: ahliPeduliNetworkMetrics),
                if (bookingState.bookings.isNotEmpty) ...[
                  const PkSectionTitle(
                    title: 'Riwayat booking',
                    subtitle: 'Booking AhliPeduli terbaru',
                  ),
                  _BookingHistoryCard(bookings: bookingState.bookings),
                ],
                const PkSectionTitle(
                  title: 'Cari ahli kesehatan',
                  subtitle: 'Rating, jarak, dan slot cepat',
                ),
                _SearchAndFilters(
                  controller: _searchController,
                  selectedCategory: _selectedCategory,
                  onChanged: () => setState(() {}),
                  onCategoryChanged: (category) {
                    setState(() => _selectedCategory = category);
                  },
                ),
                const SizedBox(height: PkSpacing.lg),
                if (daruratProviders.isNotEmpty)
                  _DaruratBanner(
                    fastestProvider: daruratProviders.first,
                    onTap: () => _showDaruratSheet(context, daruratProviders),
                  ),
                const SizedBox(height: PkSpacing.xl),
                _ProviderGrid(
                  providers: providers,
                  onBook: (provider) => _showBookingSheet(context, provider),
                  onDarurat: (provider) =>
                      _showDaruratProvider(context, provider),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBookingSheet(BuildContext context, HealthcareProvider provider) {
    final elder = ref.read(elderProfileProvider);
    final caregiver = ref.read(caregiverProfileProvider);
    final canUseAmbulance = provider.category == ProviderCategory.clinic || provider.category == ProviderCategory.hospital;
    String selectedSlot = provider.nextSlots.isEmpty ? 'Hari ini' : provider.nextSlots.first;
    bool needsAmbulance = false;
    final complaintController = TextEditingController();
    final pickupController = TextEditingController(text: elder.displayAddress == 'Belum diisi' ? '' : elder.displayAddress);

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: PkColors.surface,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 8,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking AhliPeduli',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: PkColors.text,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${provider.name} · ${provider.category.label}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: PkColors.text2),
                    ),
                    const SizedBox(height: 18),
                    Text('Pilih slot waktu', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: provider.nextSlots
                          .map(
                            (slot) => ChoiceChip(
                              avatar: const Icon(Icons.schedule_rounded, size: 18),
                              label: Text('Hari ini $slot'),
                              selected: selectedSlot == slot,
                              onSelected: (_) => setSheetState(() => selectedSlot = slot),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: complaintController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Catatan keluhan',
                        hintText: 'Contoh: pusing ringan sejak pagi',
                        prefixIcon: Icon(Icons.note_alt_outlined),
                      ),
                    ),
                    if (canUseAmbulance) ...[
                      const SizedBox(height: 16),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Butuh ambulans'),
                        subtitle: const Text('Estimasi biaya ambulans Rp185.000 dan waktu jemput 18 menit.'),
                        value: needsAmbulance,
                        onChanged: (value) => setSheetState(() => needsAmbulance = value),
                      ),
                      if (needsAmbulance) ...[
                        const SizedBox(height: 8),
                        TextField(
                          controller: pickupController,
                          decoration: const InputDecoration(
                            labelText: 'Alamat penjemputan',
                            hintText: 'Isi alamat rumah lansia',
                            prefixIcon: Icon(Icons.home_outlined),
                          ),
                        ),
                      ],
                    ],
                    const SizedBox(height: 20),
                    PkCard(
                      clean: true,
                      tint: PkColors.surfaceTint,
                      padding: const EdgeInsets.all(PkSpacing.md),
                      child: Text(
                        needsAmbulance
                            ? 'Konfirmasi booking untuk ${provider.name}, slot $selectedSlot, dengan permintaan ambulans.'
                            : 'Konfirmasi booking untuk ${provider.name}, slot $selectedSlot.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: PkColors.text2, height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          final booking = ref.read(ahliPeduliBookingProvider.notifier).createBooking(
                                elderId: elder.id,
                                caregiverId: caregiver.id,
                                provider: provider,
                                selectedSlot: selectedSlot,
                                complaintNote: complaintController.text,
                                needsAmbulance: needsAmbulance,
                                pickupAddress: needsAmbulance ? pickupController.text : '',
                              );
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(booking.needsAmbulance
                                  ? 'Booking AhliPeduli berhasil. Ambulans diminta.'
                                  : 'Booking AhliPeduli berhasil.'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Konfirmasi Booking'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      complaintController.dispose();
      pickupController.dispose();
    });
  }

  void _showDaruratProvider(BuildContext context, HealthcareProvider provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'PeduliDarurat: ${provider.name} menerima permintaan bantuan.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showDaruratSheet(
    BuildContext context,
    List<HealthcareProvider> providers,
  ) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: PkColors.surface,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const PkIconBox(
                    icon: Icons.emergency_share_outlined,
                    tone: PkTone.red,
                    size: 44,
                  ),
                  const SizedBox(width: PkSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rute bantuan darurat',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: PkColors.text,
                              ),
                        ),
                        Text(
                          'Urut berdasarkan estimasi respon tercepat.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: PkSpacing.lg),
              ...providers.take(3).map(
                    (provider) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: PkRadius.smRadius,
                          side: BorderSide(color: PkColors.line),
                        ),
                        leading: const CircleAvatar(
                          backgroundColor: PkColors.redSoft,
                          foregroundColor: PkColors.red,
                          child: Icon(Icons.local_hospital_outlined),
                        ),
                        title: Text(provider.name),
                        subtitle: Text(
                          '${provider.distanceLabel} · Tiba ${provider.etaLabel}',
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }
}


class _BookingHistoryCard extends StatelessWidget {
  const _BookingHistoryCard({required this.bookings});

  final List<AhliPeduliBooking> bookings;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final booking in bookings.take(3))
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: PkIconBox(
                icon: booking.needsAmbulance ? Icons.emergency_share_outlined : Icons.health_and_safety_outlined,
                tone: booking.needsAmbulance ? PkTone.red : PkTone.green,
              ),
              title: Text(booking.providerName),
              subtitle: Text('${booking.providerCategory} · Slot ${booking.selectedSlot} · ${booking.status.label}'),
              trailing: booking.needsAmbulance
                  ? PkBadge(label: 'Ambulans', tone: PkTone.red, icon: Icons.local_taxi_outlined)
                  : null,
            ),
        ],
      ),
    );
  }
}

class _AhliPeduliHero extends StatelessWidget {
  const _AhliPeduliHero({required this.onDaruratTap});

  final VoidCallback onDaruratTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: PkRadius.lgRadius,
        boxShadow: PkShadow.md,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF064D49),
            PkColors.brand,
            PkColors.brand2,
          ],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 760;
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HeroBadge(),
              const SizedBox(height: 18),
              Text(
                'Hubungkan keluarga dengan ahli kesehatan tepercaya.',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.2,
                      height: 1.02,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Cari dokter, perawat, dan klinik berdasarkan rating, jarak, dan jadwal yang tersedia.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.78),
                      height: 1.7,
                    ),
              ),
              const SizedBox(height: 22),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: PkColors.brand,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pilih dokter, perawat, rumah sakit, atau klinik di bawah untuk booking.')),
                      );
                    },
                    icon: const Icon(Icons.calendar_month_rounded),
                    label: const Text('Booking sekarang'),
                  ),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: PkColors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: onDaruratTap,
                    icon: const Icon(Icons.emergency_share_outlined),
                    label: const Text('PeduliDarurat'),
                  ),
                ],
              ),
            ],
          );

          final panel = Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: PkRadius.mdRadius,
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroSignal(
                  title: 'Dokter siaga',
                  value: '12',
                  icon: Icons.medical_information_outlined,
                ),
                SizedBox(height: 10),
                _HeroSignal(
                  title: 'Perawat perawatan rumah',
                  value: '18',
                  icon: Icons.volunteer_activism_outlined,
                ),
                SizedBox(height: 10),
                _HeroSignal(
                  title: 'Klinik terdekat',
                  value: '9',
                  icon: Icons.local_hospital_outlined,
                ),
              ],
            ),
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [copy, const SizedBox(height: 20), panel],
            );
          }

          return Row(
            children: [
              Expanded(flex: 6, child: copy),
              const SizedBox(width: 28),
              Expanded(flex: 4, child: panel),
            ],
          );
        },
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: PkRadius.pillRadius,
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.health_and_safety_outlined, color: Colors.white, size: 17),
          SizedBox(width: 8),
          Text(
            'AHLIPEDULI',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSignal extends StatelessWidget {
  const _HeroSignal({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: PkRadius.smRadius,
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.86)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class _NetworkMetricGrid extends StatelessWidget {
  const _NetworkMetricGrid({required this.metrics});

  final List<CareNetworkMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 760 ? metrics.length : 1;
        return GridView.builder(
          itemCount: metrics.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: columns == 1 ? 3.2 : 1.8,
          ),
          itemBuilder: (context, index) {
            final metric = metrics[index];
            return PkCard(
              clean: true,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    metric.value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: PkColors.brand,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    metric.label,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: PkColors.text,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  Text(
                    metric.caption,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: PkColors.text2,
                        ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _SearchAndFilters extends StatelessWidget {
  const _SearchAndFilters({
    required this.controller,
    required this.selectedCategory,
    required this.onChanged,
    required this.onCategoryChanged,
  });

  final TextEditingController controller;
  final ProviderCategory? selectedCategory;
  final VoidCallback onChanged;
  final ValueChanged<ProviderCategory?> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      padding: const EdgeInsets.all(PkSpacing.lg),
      child: Column(
        children: [
          TextField(
            controller: controller,
            onChanged: (_) => onChanged(),
            decoration: const InputDecoration(
              hintText: 'Cari dokter, perawat, klinik, atau keluhan',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          const SizedBox(height: PkSpacing.md),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Semua'),
                  selected: selectedCategory == null,
                  onSelected: (_) => onCategoryChanged(null),
                ),
                for (final category in ProviderCategory.values)
                  ChoiceChip(
                    label: Text(category.label),
                    selected: selectedCategory == category,
                    onSelected: (_) => onCategoryChanged(category),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DaruratBanner extends StatelessWidget {
  const _DaruratBanner({required this.fastestProvider, required this.onTap});

  final HealthcareProvider fastestProvider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      padding: const EdgeInsets.all(PkSpacing.lg),
      tint: PkColors.redSoft,
      borderColor: PkColors.red.withValues(alpha: 0.22),
      child: Row(
        children: [
          const PkIconBox(
            icon: Icons.emergency_share_outlined,
            tone: PkTone.red,
            size: 50,
          ),
          const SizedBox(width: PkSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PeduliDarurat aktif',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: PkColors.red,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Provider tercepat: ${fastestProvider.name} · ETA ${fastestProvider.etaLabel}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: PkColors.text2),
                ),
              ],
            ),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: PkColors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: onTap,
            icon: const Icon(Icons.sos_rounded),
            label: const Text('Panggil'),
          ),
        ],
      ),
    );
  }
}

class _ProviderGrid extends StatelessWidget {
  const _ProviderGrid({
    required this.providers,
    required this.onBook,
    required this.onDarurat,
  });

  final List<HealthcareProvider> providers;
  final ValueChanged<HealthcareProvider> onBook;
  final ValueChanged<HealthcareProvider> onDarurat;

  @override
  Widget build(BuildContext context) {
    if (providers.isEmpty) {
      return const AppEmptyState(
        title: 'Provider tidak ditemukan',
        message: 'Coba ubah kata kunci, kategori, atau gunakan filter Semua.',
        icon: Icons.manage_search_rounded,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 980
            ? 3
            : constraints.maxWidth >= 650
                ? 2
                : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: columns == 1 ? 0.94 : 0.76,
          ),
          itemCount: providers.length,
          itemBuilder: (context, index) {
            final provider = providers[index];
            return HealthcareProviderCard(
              provider: provider,
              onBook: () => onBook(provider),
              onDarurat: () => onDarurat(provider),
            );
          },
        );
      },
    );
  }
}
