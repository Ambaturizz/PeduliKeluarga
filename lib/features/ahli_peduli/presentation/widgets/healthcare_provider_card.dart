import 'package:flutter/material.dart';

import '../../../../core/theme/pk_design.dart';
import '../../domain/healthcare_provider.dart';

class HealthcareProviderCard extends StatelessWidget {
  const HealthcareProviderCard({
    required this.provider,
    this.onBook,
    this.onDarurat,
    super.key,
  });

  final HealthcareProvider provider;
  final VoidCallback? onBook;
  final VoidCallback? onDarurat;

  @override
  Widget build(BuildContext context) {
    final tone = _toneFor(provider.category);

    return PkCard(
      soft: true,
      padding: const EdgeInsets.all(PkSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProviderAvatar(category: provider.category),
              const SizedBox(width: PkSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            provider.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: PkColors.text,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.35,
                                ),
                          ),
                        ),
                        if (provider.isVerified) ...[
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.verified_rounded,
                            size: 18,
                            color: PkColors.brand,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      provider.speciality,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: PkColors.text2,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        PkBadge(
                          label: provider.category.shortLabel,
                          tone: tone,
                          icon: _iconFor(provider.category),
                        ),
                        if (provider.isOnlineConsultationReady)
                          const PkBadge(
                            label: 'Telekonsultasi',
                            tone: PkTone.blue,
                            icon: Icons.video_call_outlined,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: PkSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _InfoPill(
                  icon: Icons.star_rounded,
                  label: provider.rating.toStringAsFixed(1),
                  caption: '${provider.reviewCount} ulasan',
                  tone: PkTone.amber,
                ),
              ),
              const SizedBox(width: PkSpacing.sm),
              Expanded(
                child: _InfoPill(
                  icon: Icons.near_me_outlined,
                  label: provider.distanceLabel,
                  caption: provider.isNearby ? 'terdekat' : provider.location,
                  tone: PkTone.brand,
                ),
              ),
              const SizedBox(width: PkSpacing.sm),
              Expanded(
                child: _InfoPill(
                  icon: Icons.schedule_rounded,
                  label: provider.etaLabel,
                  caption: 'estimasi respon',
                  tone: PkTone.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: PkSpacing.md),
          _FacilityLine(provider: provider),
          const SizedBox(height: PkSpacing.md),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: provider.tags
                .map(
                  (tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: PkColors.surfaceSoft,
                      borderRadius: PkRadius.pillRadius,
                      border: Border.all(color: PkColors.line),
                    ),
                    child: Text(
                      tag,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: PkColors.text2,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: PkSpacing.lg),
          _SlotStrip(slots: provider.nextSlots),
          const SizedBox(height: PkSpacing.lg),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onBook,
                  icon: const Icon(Icons.calendar_month_rounded, size: 18),
                  label: const Text('Booking AhliPeduli'),
                ),
              ),
              if (provider.isDaruratReady) ...[
                const SizedBox(width: PkSpacing.sm),
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: PkColors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: onDarurat,
                    icon: const Icon(Icons.emergency_share_outlined, size: 18),
                    label: const Text('PeduliDarurat'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ProviderAvatar extends StatelessWidget {
  const _ProviderAvatar({required this.category});

  final ProviderCategory category;

  @override
  Widget build(BuildContext context) {
    final tone = _toneFor(category);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: pkToneSoft(tone),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: PkShadow.sm,
          ),
          child: Icon(_iconFor(category), color: pkToneColor(tone), size: 30),
        ),
        Positioned(
          right: -3,
          bottom: -3,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: PkColors.green,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.label,
    required this.caption,
    required this.tone,
  });

  final IconData icon;
  final String label;
  final String caption;
  final PkTone tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: pkToneSoft(tone).withValues(alpha: 0.72),
        borderRadius: PkRadius.smRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: pkToneColor(tone)),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: PkColors.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: PkColors.muted,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _FacilityLine extends StatelessWidget {
  const _FacilityLine({required this.provider});

  final HealthcareProvider provider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(PkSpacing.md),
      decoration: BoxDecoration(
        color: PkColors.surfaceTint,
        borderRadius: PkRadius.smRadius,
        border: Border.all(color: PkColors.line),
      ),
      child: Row(
        children: [
          const PkIconBox(icon: Icons.apartment_rounded, size: 36, iconSize: 18),
          const SizedBox(width: PkSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.facility,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: PkColors.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                Text(
                  '${provider.location} - ${provider.experienceLabel}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: PkColors.text2,
                      ),
                ),
              ],
            ),
          ),
          Text(
            provider.priceLabel,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: PkColors.brand,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class _SlotStrip extends StatelessWidget {
  const _SlotStrip({required this.slots});

  final List<String> slots;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Slot cepat',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: PkColors.muted,
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(width: PkSpacing.sm),
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: slots
                .map(
                  (slot) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: PkRadius.pillRadius,
                      border: Border.all(color: PkColors.lineStrong),
                    ),
                    child: Text(
                      slot,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: PkColors.text,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

PkTone _toneFor(ProviderCategory category) {
  return switch (category) {
    ProviderCategory.doctor => PkTone.brand,
    ProviderCategory.nurse => PkTone.purple,
    ProviderCategory.clinic => PkTone.blue,
    ProviderCategory.hospital => PkTone.red,
  };
}

IconData _iconFor(ProviderCategory category) {
  return switch (category) {
    ProviderCategory.doctor => Icons.medical_information_outlined,
    ProviderCategory.nurse => Icons.volunteer_activism_outlined,
    ProviderCategory.clinic => Icons.local_hospital_outlined,
    ProviderCategory.hospital => Icons.apartment_rounded,
  };
}
