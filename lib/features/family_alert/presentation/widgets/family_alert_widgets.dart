import 'package:flutter/material.dart';

import '../../../../core/theme/pk_design.dart';
import '../../data/emergency_mock_data.dart';
import '../../providers/emergency_provider.dart';

class FamilyAlertHero extends StatelessWidget {
  const FamilyAlertHero({
    required this.state,
    required this.onOpenModal,
    super.key,
  });

  final EmergencyState state;
  final VoidCallback onOpenModal;

  @override
  Widget build(BuildContext context) {
    final color = pkToneColor(state.tone);

    return Container(
      padding: EdgeInsets.all(MediaQuery.sizeOf(context).width < 640 ? 22 : 34),
      decoration: BoxDecoration(
        borderRadius: PkRadius.lgRadius,
        boxShadow: PkShadow.md,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: state.status == EmergencyStatus.standby ||
                  state.status == EmergencyStatus.resolved
              ? const [
                  Color(0xFF064D49),
                  PkColors.brand,
                  PkColors.brand2,
                ]
              : const [
                  Color(0xFF8F2427),
                  PkColors.red,
                  Color(0xFFE15B54),
                ],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _EmergencyHeroPainter())),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 760;
              final copy = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroBadge(
                    label: 'Family Alert · Emergency System',
                    icon: state.status.icon,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    state.heroTitle,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.8,
                          height: 1.02,
                        ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    state.heroSubtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                          foregroundColor: color,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          shape: const StadiumBorder(),
                        ),
                        onPressed: onOpenModal,
                        icon: const Icon(Icons.emergency_outlined),
                        label: const Text('Buka Emergency Modal'),
                      ),
                    ],
                  ),
                ],
              );

              final panel = _HeroPanel(state: state);

              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    copy,
                    const SizedBox(height: 24),
                    panel,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(flex: 6, child: copy),
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

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: PkRadius.pillRadius,
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
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
    required this.state,
  });

  final EmergencyState state;

  @override
  Widget build(BuildContext context) {
    final dispatchPercent = (state.dispatchProgress * 100).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
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
                  'Alert status tracking',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.76),
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
              Text(
                state.status.label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.86),
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
                  _HeroStatTile(
                    value: state.isActive ? '${state.countdownSeconds}s' : '24/7',
                    label: state.isActive ? 'Countdown' : 'Standby',
                    icon: Icons.timer_outlined,
                  ),
                  _HeroStatTile(
                    value: '${state.notifiedContacts}/${state.contacts.length}',
                    label: 'Kontak notified',
                    icon: Icons.groups_outlined,
                  ),
                  _HeroStatTile(
                    value: '$dispatchPercent%',
                    label: 'Dispatch',
                    icon: Icons.local_shipping_outlined,
                  ),
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
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.82), size: 20),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.7,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
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

class _EmergencyHeroPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.055)
      ..strokeWidth = 1;

    const gap = 42.0;

    for (double x = 0; x <= size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (double y = 0; y <= size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
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
          radius: 155,
        ),
      );

    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.18),
      155,
      glow,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class EmergencyButtonCard extends StatelessWidget {
  const EmergencyButtonCard({
    required this.state,
    required this.onStart,
    required this.onCancel,
    required this.onResolve,
    super.key,
  });

  final EmergencyState state;
  final VoidCallback onStart;
  final VoidCallback onCancel;
  final VoidCallback onResolve;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          EmergencyPulseButton(
            enabled: state.canStart,
            active: !state.canStart,
            countdownSeconds: state.countdownSeconds,
            status: state.status,
            onPressed: onStart,
          ),
          const SizedBox(height: 18),
          _EmergencyActionRow(
            state: state,
            onStart: onStart,
            onCancel: onCancel,
            onResolve: onResolve,
          ),
        ],
      ),
    );
  }
}

class EmergencyPulseButton extends StatefulWidget {
  const EmergencyPulseButton({
    required this.enabled,
    required this.active,
    required this.countdownSeconds,
    required this.status,
    required this.onPressed,
    super.key,
  });

  final bool enabled;
  final bool active;
  final int countdownSeconds;
  final EmergencyStatus status;
  final VoidCallback onPressed;

  @override
  State<EmergencyPulseButton> createState() => _EmergencyPulseButtonState();
}

class _EmergencyPulseButtonState extends State<EmergencyPulseButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _label {
    return switch (widget.status) {
      EmergencyStatus.active => 'Countdown ${widget.countdownSeconds}',
      EmergencyStatus.dispatching => 'Dispatching',
      EmergencyStatus.notified => 'Notified',
      EmergencyStatus.resolved => 'Resolved',
      EmergencyStatus.cancelled => 'Cancelled',
      EmergencyStatus.standby => 'DARURAT',
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDanger =
        widget.status == EmergencyStatus.active ||
        widget.status == EmergencyStatus.dispatching;

    return Semantics(
      button: true,
      label: 'Tombol darurat Family Alert',
      hint: widget.enabled
          ? 'Tekan untuk memulai emergency alert'
          : 'Emergency alert sedang berjalan',
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, child) {
          return Transform.scale(
            scale: isDanger ? _pulse.value : 1,
            child: child,
          );
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isDanger)
              Container(
                width: 230,
                height: 230,
                decoration: BoxDecoration(
                  color: PkColors.red.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
              ),
            SizedBox(
              width: 206,
              height: 206,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: widget.enabled
                      ? PkColors.red
                      : pkToneColor(widget.status.tone),
                  foregroundColor: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 0,
                  padding: EdgeInsets.zero,
                ),
                onPressed: widget.enabled ? widget.onPressed : null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.status.icon,
                      size: 56,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _label,
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.8,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.enabled ? 'Tekan 1x' : widget.status.label,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.78),
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmergencyActionRow extends StatelessWidget {
  const _EmergencyActionRow({
    required this.state,
    required this.onStart,
    required this.onCancel,
    required this.onResolve,
  });

  final EmergencyState state;
  final VoidCallback onStart;
  final VoidCallback onCancel;
  final VoidCallback onResolve;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 520;

        final start = FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: PkColors.red,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(56),
            shape: const StadiumBorder(),
          ),
          onPressed: state.canStart ? onStart : null,
          icon: const Icon(Icons.emergency_outlined),
          label: const Text('Mulai Alert'),
        );

        final cancel = OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: PkColors.red,
            minimumSize: const Size.fromHeight(56),
            shape: const StadiumBorder(),
          ),
          onPressed: state.canCancel ? onCancel : null,
          icon: const Icon(Icons.cancel_outlined),
          label: const Text('Batalkan'),
        );

        final resolve = FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: PkColors.green,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(56),
            shape: const StadiumBorder(),
          ),
          onPressed: state.canResolve ? onResolve : null,
          icon: const Icon(Icons.check_circle_outline_rounded),
          label: const Text('Selesai'),
        );

        if (compact) {
          return Column(
            children: [
              start,
              const SizedBox(height: 10),
              cancel,
              const SizedBox(height: 10),
              resolve,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: start),
            const SizedBox(width: 10),
            Expanded(child: cancel),
            const SizedBox(width: 10),
            Expanded(child: resolve),
          ],
        );
      },
    );
  }
}

class AlertStatusCard extends StatelessWidget {
  const AlertStatusCard({
    required this.state,
    super.key,
  });

  final EmergencyState state;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      soft: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            eyebrow: 'Alert status tracking',
            title: state.status.label,
            subtitle: state.status.description,
            icon: state.status.icon,
            tone: state.tone,
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: PkRadius.pillRadius,
            child: LinearProgressIndicator(
              value: state.status == EmergencyStatus.standby
                  ? 0.16
                  : state.status == EmergencyStatus.active
                      ? 0.35
                      : state.status == EmergencyStatus.dispatching
                          ? state.dispatchProgress
                          : 1,
              minHeight: 11,
              color: pkToneColor(state.tone),
              backgroundColor: PkColors.line,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              PkBadge(
                label: '${state.notifiedContacts} kontak notified',
                tone: state.notifiedContacts == 0 ? PkTone.gray : PkTone.blue,
                icon: Icons.notifications_active_outlined,
              ),
              PkBadge(
                label:
                    'Dispatch ${(state.dispatchProgress * 100).round()}%',
                tone: state.dispatchProgress >= 1 ? PkTone.green : PkTone.amber,
                icon: Icons.local_shipping_outlined,
              ),
              PkBadge(
                label: 'Timeline ${state.timeline.length} event',
                tone: PkTone.brand,
                icon: Icons.timeline_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DispatchTrackingCard extends StatelessWidget {
  const DispatchTrackingCard({
    required this.progress,
    super.key,
  });

  final double progress;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            eyebrow: 'Emergency dispatch tracking',
            title: 'Alur dispatch bantuan',
            subtitle: 'Simulasi alur pengiriman notifikasi dan ringkasan medis.',
            icon: Icons.route_outlined,
            tone: PkTone.amber,
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < EmergencyMockData.dispatchSteps.length; i++)
            _DispatchStepRow(
              step: EmergencyMockData.dispatchSteps[i],
              completed: progress >= (i + 1) / EmergencyMockData.dispatchSteps.length,
              isLast: i == EmergencyMockData.dispatchSteps.length - 1,
            ),
        ],
      ),
    );
  }
}

class _DispatchStepRow extends StatelessWidget {
  const _DispatchStepRow({
    required this.step,
    required this.completed,
    required this.isLast,
  });

  final EmergencyDispatchStep step;
  final bool completed;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final tone = completed ? step.tone : PkTone.gray;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PkIconBox(
            icon: completed ? Icons.check_rounded : step.icon,
            tone: tone,
            size: 42,
            iconSize: 21,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 220),
              opacity: completed ? 1 : 0.62,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: PkColors.text,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    step.subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: PkColors.text2,
                          height: 1.45,
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
}

class EmergencyContactsCard extends StatelessWidget {
  const EmergencyContactsCard({
    required this.contacts,
    super.key,
  });

  final List<EmergencyContact> contacts;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            eyebrow: 'Emergency contacts',
            title: 'Kontak darurat',
            subtitle: 'Keluarga dan AhliPeduli yang menerima alert.',
            icon: Icons.contacts_outlined,
            tone: PkTone.blue,
          ),
          const SizedBox(height: 16),
          for (final contact in contacts)
            _ContactTile(contact: contact),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.contact,
  });

  final EmergencyContact contact;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PkColors.surfaceSoft,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: PkColors.line),
      ),
      child: Row(
        children: [
          PkIconBox(
            icon: contact.notified
                ? Icons.mark_email_read_outlined
                : contact.icon,
            tone: contact.notified ? PkTone.green : contact.tone,
            size: 44,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: PkColors.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${contact.role} · ${contact.phone}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: PkColors.text2,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          PkBadge(
            label: contact.notified ? 'Notified' : contact.responseTime,
            tone: contact.notified ? PkTone.green : contact.tone,
          ),
        ],
      ),
    );
  }
}

class EmergencyMedicalSummaryCard extends StatelessWidget {
  const EmergencyMedicalSummaryCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const summary = EmergencyMockData.medicalSummary;

    return PkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            eyebrow: 'Emergency medical summary card',
            title: 'Ringkasan medis darurat',
            subtitle: 'Data penting yang ditampilkan saat Family Alert aktif.',
            icon: Icons.medical_information_outlined,
            tone: PkTone.red,
          ),
          const SizedBox(height: 16),
          _MedicalRow(
            label: 'Pasien',
            value: '${summary.name}, ${summary.age} tahun',
            icon: Icons.elderly_rounded,
            tone: PkTone.brand,
          ),
          _MedicalRow(
            label: 'Kondisi',
            value: summary.conditions.join(', '),
            icon: Icons.monitor_heart_outlined,
            tone: PkTone.amber,
          ),
          _MedicalRow(
            label: 'Alergi',
            value: summary.allergies,
            icon: Icons.warning_amber_rounded,
            tone: PkTone.red,
          ),
          _MedicalRow(
            label: 'Cek terakhir',
            value:
                '${summary.lastCheck} · TD ${summary.bloodPressure} · GD ${summary.bloodSugar}',
            icon: Icons.fact_check_outlined,
            tone: PkTone.blue,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final medication in summary.currentMedications)
                PkBadge(
                  label: medication,
                  tone: PkTone.green,
                  icon: Icons.medication_outlined,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MedicalRow extends StatelessWidget {
  const _MedicalRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.tone,
  });

  final String label;
  final String value;
  final IconData icon;
  final PkTone tone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          PkIconBox(icon: icon, tone: tone, size: 38, iconSize: 19),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: PkColors.muted,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: PkColors.text,
                        fontWeight: FontWeight.w700,
                        height: 1.45,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EmergencyTimelineCard extends StatelessWidget {
  const EmergencyTimelineCard({
    required this.events,
    super.key,
  });

  final List<EmergencyTimelineEvent> events;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(
            eyebrow: 'Emergency timeline animation',
            title: 'Timeline alert',
            subtitle: 'Urutan kejadian emergency secara lokal.',
            icon: Icons.timeline_outlined,
            tone: PkTone.brand,
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            child: Column(
              key: ValueKey(events.length),
              children: [
                for (var i = 0; i < events.length; i++)
                  _TimelineItem(
                    event: events[i],
                    isLast: i == events.length - 1,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.event,
    required this.isLast,
  });

  final EmergencyTimelineEvent event;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = pkToneColor(event.tone);

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 260),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: pkToneSoft(event.tone),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(event.icon, color: color, size: 18),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 42,
                    color: PkColors.line,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: PkColors.surfaceSoft,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: PkColors.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: PkColors.text,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: PkColors.text2,
                            height: 1.45,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      event.time,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: PkColors.muted,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmergencyResponsiveGrid extends StatelessWidget {
  const EmergencyResponsiveGrid({
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.eyebrow,
    required this.title,
    required this.icon,
    required this.tone,
    this.subtitle,
  });

  final String eyebrow;
  final String title;
  final String? subtitle;
  final IconData icon;
  final PkTone tone;

  @override
  Widget build(BuildContext context) {
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
                      color: PkColors.muted,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: PkColors.text,
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
                        color: PkColors.text2,
                        height: 1.55,
                      ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 14),
        PkIconBox(icon: icon, tone: tone),
      ],
    );
  }
}

class EmergencyConfirmSheet extends StatelessWidget {
  const EmergencyConfirmSheet({
    required this.onConfirm,
    super.key,
  });

  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          18,
          20,
          20 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: PkColors.lineStrong,
                borderRadius: PkRadius.pillRadius,
              ),
            ),
            const SizedBox(height: 18),
            const PkIconBox(
              icon: Icons.emergency_outlined,
              tone: PkTone.red,
              size: 64,
              iconSize: 34,
            ),
            const SizedBox(height: 16),
            Text(
              'Mulai Family Alert?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: PkColors.text,
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Dalam 5 detik, sistem akan mensimulasikan notifikasi ke keluarga dan AhliPeduli jika tidak dibatalkan.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: PkColors.text2,
                    height: 1.55,
                  ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: PkColors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(58),
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
                icon: const Icon(Icons.emergency_outlined),
                label: const Text('Ya, mulai emergency'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: PkColors.text2,
                  minimumSize: const Size.fromHeight(56),
                  shape: const StadiumBorder(),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Batal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}