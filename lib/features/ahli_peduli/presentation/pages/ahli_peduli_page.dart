
import 'package:flutter/material.dart';

import '../../../../core/theme/pk_design.dart';
import '../../../../core/animations/app_motion.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/states/app_state_widgets.dart';
import '../../data/ahli_peduli_mock_data.dart';
import '../../domain/healthcare_provider.dart';
import '../widgets/healthcare_provider_card.dart';

class AhliPeduliPage extends StatefulWidget {
  const AhliPeduliPage({super.key});

  @override
  State<AhliPeduliPage> createState() => _AhliPeduliPageState();
}

class _AhliPeduliPageState extends State<AhliPeduliPage> {
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
      final matchesCategory = _selectedCategory == null || provider.category == _selectedCategory;
      final matchesSearch = query.isEmpty ||
          provider.name.toLowerCase().contains(query) ||
          provider.speciality.toLowerCase().contains(query) ||
          provider.location.toLowerCase().contains(query) ||
          provider.tags.any((tag) => tag.toLowerCase().contains(query));

      return matchesCategory && matchesSearch;
    }).toList()
      ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));

    final emergencyProviders = ahliPeduliProviders
        .where((provider) => provider.isEmergencyReady)
        .toList()
      ..sort((a, b) => a.etaMinutes.compareTo(b.etaMinutes));

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
                _AhliPeduliHero(onEmergencyTap: () => _showEmergencySheet(context, emergencyProviders)),
                const SizedBox(height: PkSpacing.xl),
                _NetworkMetricGrid(metrics: ahliPeduliNetworkMetrics),
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
                _EmergencyBanner(
                  fastestProvider: emergencyProviders.first,
                  onTap: () => _showEmergencySheet(context, emergencyProviders),
                ),
                const SizedBox(height: PkSpacing.xl),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: _ProviderGrid(
                    key: ValueKey('${_selectedCategory?.name}-$query-${providers.length}'),
                    providers: providers,
                    onBook: (provider) => _showBookingSheet(context, provider),
                    onEmergency: (provider) => _showEmergencyProvider(context, provider),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBookingSheet(BuildContext context, HealthcareProvider provider) {
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
              Text(
                'Booking ${provider.category.shortLabel}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: PkColors.text,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                provider.name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: PkColors.text2),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: provider.nextSlots
                    .map(
                      (slot) => ActionChip(
                        avatar: const Icon(Icons.schedule_rounded, size: 18),
                        label: Text('Hari ini $slot'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Konfirmasi booking'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEmergencyProvider(BuildContext context, HealthcareProvider provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Emergency CTA: ${provider.name} menerima permintaan bantuan.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showEmergencySheet(BuildContext context, List<HealthcareProvider> providers) {
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
                          'Emergency care routing',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: PkColors.text,
                              ),
                        ),
                        Text(
                          'Urut berdasarkan ETA tercepat dan status siaga.',
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
                        leading: CircleAvatar(
                          backgroundColor: PkColors.redSoft,
                          foregroundColor: PkColors.red,
                          child: const Icon(Icons.local_hospital_outlined),
                        ),
                        title: Text(provider.name),
                        subtitle: Text('${provider.distanceLabel} - ETA ${provider.etaLabel}'),
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

class _AhliPeduliHero extends StatelessWidget {
  const _AhliPeduliHero({required this.onEmergencyTap});

  final VoidCallback onEmergencyTap;

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
              Container(
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
                      'AHLIPEDULI NETWORK',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.1,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
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
                'Doctor cards, nurse cards, clinic cards, rating UI, distance UI, booking CTA, dan emergency CTA dalam satu pengalaman premium.',
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
                    onPressed: () {},
                    icon: const Icon(Icons.calendar_month_rounded),
                    label: const Text('Booking sekarang'),
                  ),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: PkColors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: onEmergencyTap,
                    icon: const Icon(Icons.emergency_share_outlined),
                    label: const Text('Emergency CTA'),
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
                _HeroSignal(title: 'Dokter siaga', value: '12', icon: Icons.medical_information_outlined),
                SizedBox(height: 10),
                _HeroSignal(title: 'Perawat homecare', value: '18', icon: Icons.volunteer_activism_outlined),
                SizedBox(height: 10),
                _HeroSignal(title: 'Klinik terdekat', value: '9', icon: Icons.local_hospital_outlined),
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

class _HeroSignal extends StatelessWidget {
  const _HeroSignal({required this.title, required this.value, required this.icon});

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
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.74),
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
        final columns = constraints.maxWidth < 680 ? 1 : 3;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: columns == 1 ? 3.8 : 2.3,
          ),
          itemCount: metrics.length,
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
                    metric.label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: PkColors.muted,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    metric.value,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: PkColors.text,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.8,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    metric.caption,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: PkColors.text2),
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
      clean: true,
      padding: const EdgeInsets.all(PkSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            onChanged: (_) => onChanged(),
            decoration: const InputDecoration(
              hintText: 'Cari dokter, perawat, klinik, lokasi, atau spesialisasi...',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          const SizedBox(height: PkSpacing.md),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Semua'),
                selected: selectedCategory == null,
                onSelected: (_) => onCategoryChanged(null),
              ),
              ...ProviderCategory.values.map(
                (category) => ChoiceChip(
                  avatar: Icon(_iconFor(category), size: 18),
                  label: Text(category.shortLabel),
                  selected: selectedCategory == category,
                  onSelected: (_) => onCategoryChanged(category),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmergencyBanner extends StatelessWidget {
  const _EmergencyBanner({required this.fastestProvider, required this.onTap});

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
                  'Emergency CTA aktif',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: PkColors.red,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Provider tercepat: ${fastestProvider.name} - ETA ${fastestProvider.etaLabel}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: PkColors.text2),
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
    required this.onEmergency,
    super.key,
  });

  final List<HealthcareProvider> providers;
  final ValueChanged<HealthcareProvider> onBook;
  final ValueChanged<HealthcareProvider> onEmergency;

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
        final columns = constraints.maxWidth >= 980 ? 3 : constraints.maxWidth >= 650 ? 2 : 1;
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
            return AppAnimatedEntrance(
              delay: Duration(milliseconds: 28 * index),
              child: HealthcareProviderCard(
                provider: provider,
              onBook: () => onBook(provider),
              onEmergency: () => onEmergency(provider),
              ),
            );
          },
        );
      },
    );
  }
}

IconData _iconFor(ProviderCategory category) {
  return switch (category) {
    ProviderCategory.doctor => Icons.medical_information_outlined,
    ProviderCategory.nurse => Icons.volunteer_activism_outlined,
    ProviderCategory.clinic => Icons.local_hospital_outlined,
  };
}
