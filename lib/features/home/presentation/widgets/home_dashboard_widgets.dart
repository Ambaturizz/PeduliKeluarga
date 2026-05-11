import 'package:flutter/material.dart';

import '../../../../core/theme/pk_design.dart';
import '../../../../state/providers/app_mode_provider.dart';
import '../../data/home_dummy_data.dart';

class PremiumModeSwitch extends StatelessWidget {
  const PremiumModeSwitch({
    required this.mode,
    required this.onChanged,
    super.key,
  });

  final AppUserMode mode;
  final ValueChanged<AppUserMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: PkColors.text,
        borderRadius: PkRadius.pillRadius,
        boxShadow: PkShadow.xs,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ModeButton(
            label: 'Lansia',
            icon: Icons.volunteer_activism_outlined,
            active: mode == AppUserMode.elder,
            onTap: () => onChanged(AppUserMode.elder),
          ),
          _ModeButton(
            label: 'Anak',
            icon: Icons.groups_outlined,
            active: mode == AppUserMode.caregiver,
            onTap: () => onChanged(AppUserMode.caregiver),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      label: label,
      child: InkWell(
        borderRadius: PkRadius.pillRadius,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: PkRadius.pillRadius,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 17,
                color: active ? PkColors.text : Colors.white70,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: active ? PkColors.text : Colors.white70,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PremiumPageHeader extends StatelessWidget {
  const PremiumPageHeader({
    required this.mode,
    required this.liveLabel,
    required this.onModeChanged,
    super.key,
  });

  final AppUserMode mode;
  final String liveLabel;
  final ValueChanged<AppUserMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 640;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: compact
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TitleBlock(liveLabel: liveLabel),
                const SizedBox(height: 12),
                PremiumModeSwitch(mode: mode, onChanged: onModeChanged),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _TitleBlock(liveLabel: liveLabel)),
                PremiumModeSwitch(mode: mode, onChanged: onModeChanged),
              ],
            ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock({
    required this.liveLabel,
  });

  final String liveLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PeduliKeluarga',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: PkColors.brand,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.4,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'Healthcare Dashboard',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: PkColors.text,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.5,
                height: 1.02,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Ringkasan kesehatan keluarga yang tenang, jelas, dan bisa ditindaklanjuti.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: PkColors.text2,
                height: 1.6,
              ),
        ),
        const SizedBox(height: 12),
        LivePill(label: liveLabel),
      ],
    );
  }
}

class LivePill extends StatelessWidget {
  const LivePill({
    required this.label,
    super.key,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: PkRadius.pillRadius,
        border: Border.all(color: PkColors.line),
        boxShadow: PkShadow.xs,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 900),
            tween: Tween(begin: 0.72, end: 1),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: PkColors.green,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: PkColors.green.withValues(alpha: 0.18),
                    blurRadius: 0,
                    spreadRadius: 6,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: PkColors.text2,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class PremiumHomeHero extends StatelessWidget {
  const PremiumHomeHero({
    required this.data,
    required this.onPrimary,
    required this.onSecondary,
    super.key,
  });

  final HomeDashboardData data;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 340),
      padding: EdgeInsets.all(
        MediaQuery.sizeOf(context).width < 640 ? 22 : 36,
      ),
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
          stops: [0, 0.48, 1],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _HeroGridPainter(),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 760;

              final content = _HeroCopy(
                data: data,
                onPrimary: onPrimary,
                onSecondary: onSecondary,
              );

              final panel = _HeroPanel(data: data);

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    content,
                    const SizedBox(height: 26),
                    panel,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(flex: 6, child: content),
                  const SizedBox(width: 26),
                  Expanded(flex: 4, child: panel),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({
    required this.data,
    required this.onPrimary,
    required this.onSecondary,
  });

  final HomeDashboardData data;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeroBadge(label: data.kicker),
        const SizedBox(height: 18),
        Text(
          data.heroTitle,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: -2.8,
                height: 0.96,
              ),
        ),
        const SizedBox(height: 16),
        Text(
          data.heroSubtitle,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.78),
                height: 1.7,
              ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: PkColors.brand,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                shape: const StadiumBorder(),
              ),
              onPressed: onPrimary,
              icon: Icon(
                data.isElder
                    ? Icons.medical_services_outlined
                    : Icons.assignment_outlined,
              ),
              label: Text(data.primaryButton),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(
                  color: Colors.white.withValues(alpha: 0.34),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                shape: const StadiumBorder(),
              ),
              onPressed: onSecondary,
              icon: const Icon(Icons.medication_outlined),
              label: Text(data.secondaryButton),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: PkRadius.pillRadius,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.auto_awesome_outlined,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.92),
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({
    required this.data,
  });

  final HomeDashboardData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 42,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  data.isElder ? 'Health status' : 'Family monitoring',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.76),
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
              Text(
                'Realtime',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.76),
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final narrow = constraints.maxWidth < 340;

              return GridView.count(
                crossAxisCount: narrow ? 1 : 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: narrow ? 4.6 : 1.08,
                children: [
                  for (final stat in data.heroStats)
                    _HeroStatTile(stat: stat),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HeroStatTile extends StatelessWidget {
  const _HeroStatTile({
    required this.stat,
  });

  final HomeHeroStat stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.14),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            stat.icon,
            color: Colors.white.withValues(alpha: 0.82),
            size: 20,
          ),
          const Spacer(),
          Text(
            stat.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.7,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            stat.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.70),
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class _HeroGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..strokeWidth = 1;

    const gap = 42.0;

    for (double x = 0; x <= size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y <= size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: 0.24),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.82, size.height * 0.18),
          radius: 160,
        ),
      );

    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.18),
      160,
      glow,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AlertStack extends StatelessWidget {
  const AlertStack({
    required this.items,
    super.key,
  });

  final List<HomeAlert> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PkCard(
              clean: true,
              tint: pkToneSoft(item.tone),
              borderColor: pkToneColor(item.tone).withValues(alpha: 0.14),
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PkIconBox(
                    icon: item.icon,
                    tone: item.tone,
                    size: 38,
                    iconSize: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: pkToneColor(item.tone),
                                    fontWeight: FontWeight.w900,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.copy,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: pkToneColor(item.tone),
                                    height: 1.5,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.time,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: pkToneColor(item.tone).withValues(alpha: 0.72),
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class PremiumSummaryCard extends StatelessWidget {
  const PremiumSummaryCard({
    required this.data,
    super.key,
  });

  final HomeDashboardData data;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      soft: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardTitleRow(
            eyebrow: data.isElder ? 'Daily condition' : 'Parent monitoring',
            title: data.summaryTitle,
            subtitle: data.summarySubtitle,
            icon: data.isElder
                ? Icons.monitor_heart_outlined
                : Icons.groups_outlined,
            tone: data.isElder ? PkTone.brand : PkTone.blue,
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final count = width >= 720 ? 3 : width >= 440 ? 2 : 1;

              return GridView.count(
                crossAxisCount: count,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: count == 1 ? 2.45 : 1.55,
                children: [
                  for (final metric in data.metrics)
                    PremiumMetricTile(metric: metric),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class PremiumMetricTile extends StatelessWidget {
  const PremiumMetricTile({
    required this.metric,
    super.key,
  });

  final HomeMetric metric;

  @override
  Widget build(BuildContext context) {
    final color = pkToneColor(metric.tone);

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: PkColors.surfaceSoft,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: PkColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  metric.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: PkColors.muted,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
              Icon(metric.icon, size: 18, color: color),
            ],
          ),
          const Spacer(),
          RichText(
            text: TextSpan(
              text: metric.value,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: PkColors.text,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.7,
                    height: 0.95,
                  ),
              children: [
                if (metric.unit != null)
                  TextSpan(
                    text: ' ${metric.unit}',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: PkColors.muted,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            metric.note,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: PkColors.text2,
                  height: 1.45,
                ),
          ),
          if (metric.progress != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: PkRadius.pillRadius,
              child: LinearProgressIndicator(
                value: metric.progress!.clamp(0, 1),
                minHeight: 7,
                color: color,
                backgroundColor: PkColors.line,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class PremiumAiCard extends StatelessWidget {
  const PremiumAiCard({
    required this.data,
    super.key,
  });

  final HomeDashboardData data;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      tint: PkColors.purpleSoft,
      borderColor: PkColors.purple.withValues(alpha: 0.14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: CardTitleRow(
                  eyebrow: data.aiEyebrow,
                  title: data.aiTitle,
                  icon: Icons.auto_awesome_outlined,
                  tone: PkTone.purple,
                ),
              ),
              PkBadge(
                label: data.aiBadge,
                tone: data.aiBadge == 'Medium' ? PkTone.amber : PkTone.purple,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            data.aiCopy,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: PkColors.text2,
                  height: 1.65,
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              PkBadge(
                label: 'AI insight',
                tone: PkTone.purple,
                icon: Icons.auto_awesome_outlined,
              ),
              PkBadge(
                label: 'Preventif',
                tone: PkTone.brand,
                icon: Icons.health_and_safety_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PremiumMedicineCard extends StatelessWidget {
  const PremiumMedicineCard({
    required this.items,
    super.key,
  });

  final List<HomeMedicine> items;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CardTitleRow(
            eyebrow: 'Medication progress',
            title: 'Obat hari ini',
            subtitle: 'Jadwal, status, dan stok obat.',
            icon: Icons.medication_outlined,
            tone: PkTone.green,
          ),
          const SizedBox(height: 16),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _MedicineItem(item: item),
            ),
        ],
      ),
    );
  }
}

class _MedicineItem extends StatelessWidget {
  const _MedicineItem({
    required this.item,
  });

  final HomeMedicine item;

  @override
  Widget build(BuildContext context) {
    final color = pkToneColor(item.tone);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: item.lowStock ? PkColors.redSoft : PkColors.surfaceSoft,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: item.lowStock
              ? PkColors.red.withValues(alpha: 0.18)
              : PkColors.line,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: pkToneSoft(item.tone),
                  borderRadius: PkRadius.smRadius,
                ),
                child: Text(
                  item.time,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: PkColors.text,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.dose,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: PkColors.text2,
                          ),
                    ),
                  ],
                ),
              ),
              PkBadge(
                label: item.status,
                tone: item.tone,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: PkRadius.pillRadius,
            child: LinearProgressIndicator(
              value: item.progress / 100,
              minHeight: 7,
              color: color,
              backgroundColor: PkColors.line,
            ),
          ),
        ],
      ),
    );
  }
}

class PremiumQuickGrid extends StatelessWidget {
  const PremiumQuickGrid({
    required this.actions,
    required this.onTap,
    super.key,
  });

  final List<HomeQuickAction> actions;
  final ValueChanged<HomeQuickAction> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final count = width >= 960 ? 4 : width >= 520 ? 2 : 1;

        return GridView.count(
          crossAxisCount: count,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: count == 1 ? 2.45 : 1.08,
          children: [
            for (final action in actions)
              PkCard(
                onTap: () => onTap(action),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        PkIconBox(icon: action.icon, tone: action.tone),
                        const Spacer(),
                        if (action.badge != null)
                          PkBadge(label: action.badge!, tone: action.tone),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      action.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: PkColors.text,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      action.subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: PkColors.text2,
                          ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class PremiumNotificationCard extends StatelessWidget {
  const PremiumNotificationCard({
    required this.items,
    super.key,
  });

  final List<HomeAlert> items;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CardTitleRow(
            eyebrow: 'Notification summary',
            title: 'Notifikasi terkini',
            subtitle: 'Aktivitas dan alert yang perlu diperhatikan.',
            icon: Icons.notifications_active_outlined,
            tone: PkTone.amber,
          ),
          const SizedBox(height: 14),
          for (final item in items)
            _NotificationItem(item: item),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  const _NotificationItem({
    required this.item,
  });

  final HomeAlert item;

  @override
  Widget build(BuildContext context) {
    final color = pkToneColor(item.tone);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: PkColors.line),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 9,
            height: 9,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: PkColors.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.copy,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: PkColors.text2,
                        height: 1.45,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            item.time,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: PkColors.muted,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class PremiumEmergencyCard extends StatelessWidget {
  const PremiumEmergencyCard({
    required this.data,
    required this.onPressed,
    super.key,
  });

  final HomeDashboardData data;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: PkColors.red,
        borderRadius: PkRadius.mdRadius,
        boxShadow: [
          BoxShadow(
            color: PkColors.red.withValues(alpha: 0.20),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFA92F32),
            Color(0xFFD44848),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardTitleRow(
            eyebrow: 'Emergency CTA',
            title: data.emergencyTitle,
            subtitle: data.emergencyCopy,
            icon: Icons.emergency_outlined,
            tone: PkTone.red,
            light: true,
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: PkColors.red,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: const StadiumBorder(),
              ),
              onPressed: onPressed,
              icon: const Icon(Icons.phone_in_talk_outlined),
              label: const Text('Buka Family Alert'),
            ),
          ),
        ],
      ),
    );
  }
}

class PremiumHistoryCard extends StatelessWidget {
  const PremiumHistoryCard({
    required this.items,
    super.key,
  });

  final List<HomeHistoryItem> items;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CardTitleRow(
            eyebrow: 'Timeline kesehatan',
            title: 'Catatan terbaru',
            icon: Icons.timeline_outlined,
            tone: PkTone.blue,
          ),
          const SizedBox(height: 14),
          for (final item in items)
            _HistoryItem(item: item),
        ],
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  const _HistoryItem({
    required this.item,
  });

  final HomeHistoryItem item;

  @override
  Widget build(BuildContext context) {
    final color = pkToneColor(item.tone);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: PkColors.line),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 9,
            height: 9,
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: PkColors.text,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.copy,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: PkColors.text2,
                        height: 1.45,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            item.time,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: PkColors.muted,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class ResponsiveDashboardGrid extends StatelessWidget {
  const ResponsiveDashboardGrid({
    required this.left,
    required this.right,
    super.key,
  });

  final List<Widget> left;
  final List<Widget> right;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 920;

        if (!wide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...left,
              ...right,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: left,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: right,
              ),
            ),
          ],
        );
      },
    );
  }
}

class CardTitleRow extends StatelessWidget {
  const CardTitleRow({
    required this.eyebrow,
    required this.title,
    required this.icon,
    required this.tone,
    this.subtitle,
    this.light = false,
    super.key,
  });

  final String eyebrow;
  final String title;
  final String? subtitle;
  final IconData icon;
  final PkTone tone;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final textColor = light ? Colors.white : PkColors.text;
    final subColor =
        light ? Colors.white.withValues(alpha: 0.76) : PkColors.text2;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: light
                          ? Colors.white.withValues(alpha: 0.72)
                          : PkColors.muted,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      height: 1.25,
                    ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: subColor,
                        height: 1.55,
                      ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 14),
        PkIconBox(
          icon: icon,
          tone: tone,
          backgroundColor:
              light ? Colors.white.withValues(alpha: 0.18) : null,
          iconColor: light ? Colors.white : null,
        ),
      ],
    );
  }
}