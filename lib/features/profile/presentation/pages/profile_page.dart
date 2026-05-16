import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/routing/app_route.dart';
import '../../../../core/theme/pk_design.dart';
import '../../../../shared/layouts/page_shell.dart';
import '../../../../state/providers/app_mode_provider.dart';
import '../../../caregiver_profile/domain/caregiver_profile.dart';
import '../../../caregiver_profile/providers/caregiver_profile_provider.dart';
import '../../../elder_profile/domain/elder_profile.dart';
import '../../../elder_profile/presentation/widgets/connection_code_card.dart';
import '../../../elder_profile/providers/elder_profile_provider.dart';
import '../../../pedulicek/providers/peduli_cek_provider.dart';
import '../../../peduliobat/providers/peduli_obat_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(appModeControllerProvider);
    final profile = ref.watch(elderProfileProvider);
    final caregiver = ref.watch(caregiverProfileProvider);
    final medicationState = ref.watch(peduliObatProvider);
    final cekState = ref.watch(peduliCekProvider);

    if (mode == AppUserMode.caregiver) {
      return PageShell(
        title: 'Profil PeduliPenuh',
        subtitle: 'Lengkapi data anak dan lansia agar tampil di dasbor utama.',
        icon: Icons.account_circle_outlined,
        headerTrailing: _ProfileBackButton(
          onPressed: () => _goBack(context),
        ),
        children: [
          _FamilyProfileFormCard(profile: profile, caregiver: caregiver),
          const SizedBox(height: PkSpacing.lg),
          _CaregiverIdentityCard(caregiver: caregiver),
          const SizedBox(height: PkSpacing.lg),
          _ConnectFamilyCard(
            isConnected: caregiver.hasLinkedElder,
            onConnect: (value) {
              final success = ref.read(caregiverProfileProvider.notifier).connectWithCode(value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success
                      ? 'Akun PeduliDiri berhasil terhubung.'
                      : 'Kode tidak sesuai. Pastikan kode berasal dari akun PeduliDiri.'),
                ),
              );
            },
            onScan: () async {
              final scanned = await showModalBottomSheet<String>(
                context: context,
                isScrollControlled: true,
                showDragHandle: true,
                builder: (context) => const _QrScannerSheet(),
              );

              if (scanned == null || scanned.trim().isEmpty) return;
              final success = ref.read(caregiverProfileProvider.notifier).connectWithCode(scanned);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success
                      ? 'QR Code valid. Akun PeduliDiri berhasil terhubung.'
                      : 'QR Code tidak valid untuk akun PeduliDiri ini.'),
                ),
              );
            },
          ),
          const SizedBox(height: PkSpacing.lg),
          _LinkedElderCard(profile: profile, caregiver: caregiver),
          const SizedBox(height: PkSpacing.lg),
          _ProfileCompleteRecordCard(
            profile: profile,
            caregiver: caregiver,
            medicationState: medicationState,
            cekState: cekState,
            mode: mode,
          ),
        ],
      );
    }

    return PageShell(
      title: 'Profil PeduliDiri',
      subtitle: 'Lengkapi data lansia dan anak agar sinkron di mode PeduliDiri dan PeduliPenuh.',
      icon: Icons.account_circle_outlined,
      headerTrailing: _ProfileBackButton(
        onPressed: () => _goBack(context),
      ),
      children: [
        _FamilyProfileFormCard(profile: profile, caregiver: caregiver),
        const SizedBox(height: PkSpacing.lg),
        _ProfileIdentityCard(profile: profile),
        const SizedBox(height: PkSpacing.lg),
        ConnectionCodeCard(profile: profile),
        const SizedBox(height: PkSpacing.lg),
        _CaregiverListCard(caregivers: profile.linkedCaregivers),
        const SizedBox(height: PkSpacing.lg),
        _ProfileCompleteRecordCard(
          profile: profile,
          caregiver: caregiver,
          medicationState: medicationState,
          cekState: cekState,
          mode: mode,
        ),
      ],
    );
  }

  void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.goNamed(AppRoute.home.name);
  }
}

class _ProfileBackButton extends StatelessWidget {
  const _ProfileBackButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 380;

    if (compact) {
      return IconButton.filledTonal(
        tooltip: 'Kembali',
        onPressed: onPressed,
        icon: const Icon(Icons.arrow_back_rounded),
      );
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.arrow_back_rounded),
      label: const Text('Kembali'),
      style: OutlinedButton.styleFrom(
        backgroundColor: PkColors.surface.withValues(alpha: 0.88),
      ),
    );
  }
}


class _FamilyProfileFormCard extends ConsumerStatefulWidget {
  const _FamilyProfileFormCard({
    required this.profile,
    required this.caregiver,
  });

  final ElderProfile profile;
  final CaregiverProfile caregiver;

  @override
  ConsumerState<_FamilyProfileFormCard> createState() => _FamilyProfileFormCardState();
}

class _FamilyProfileFormCardState extends ConsumerState<_FamilyProfileFormCard> {
  late final TextEditingController _childNameController;
  late final TextEditingController _childPhoneController;
  late final TextEditingController _relationshipController;
  late final TextEditingController _elderNameController;
  late final TextEditingController _elderAgeController;
  late final TextEditingController _elderWeightController;
  late final TextEditingController _elderGenderController;
  late final TextEditingController _elderPhoneController;
  late final TextEditingController _elderAddressController;
  late final TextEditingController _medicalHistoryController;

  @override
  void initState() {
    super.initState();

    final elderName = widget.profile.name.trim().isNotEmpty
        ? widget.profile.name.trim()
        : widget.caregiver.elderName.trim();

    _childNameController = TextEditingController(text: widget.caregiver.name);
    _childPhoneController = TextEditingController(text: widget.caregiver.phoneNumber);
    _relationshipController = TextEditingController(text: widget.caregiver.relationship);
    _elderNameController = TextEditingController(text: elderName);
    _elderAgeController = TextEditingController(text: widget.profile.age);
    _elderWeightController = TextEditingController(text: widget.profile.weight);
    _elderGenderController = TextEditingController(text: widget.profile.gender);
    _elderPhoneController = TextEditingController(text: widget.profile.phoneNumber);
    _elderAddressController = TextEditingController(text: widget.profile.address);
    _medicalHistoryController = TextEditingController(text: widget.profile.medicalHistory.join(', '));
  }

  @override
  void dispose() {
    _childNameController.dispose();
    _childPhoneController.dispose();
    _relationshipController.dispose();
    _elderNameController.dispose();
    _elderAgeController.dispose();
    _elderWeightController.dispose();
    _elderGenderController.dispose();
    _elderPhoneController.dispose();
    _elderAddressController.dispose();
    _medicalHistoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PkCard(
      tint: PkColors.surface.withValues(alpha: 0.96),
      borderColor: PkColors.brand.withValues(alpha: 0.16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final useTwoColumns = constraints.maxWidth >= 620;
          final fieldWidth = useTwoColumns
              ? (constraints.maxWidth - PkSpacing.md) / 2
              : constraints.maxWidth;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const PkIconBox(icon: Icons.edit_note_rounded, tone: PkTone.brand),
                  const SizedBox(width: PkSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lengkapi Profil Keluarga',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: PkColors.text,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Satu form untuk mode Lansia dan Anak. Data yang disimpan akan langsung sinkron ke dasbor.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: PkColors.text2,
                                height: 1.45,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: PkSpacing.lg),
              _FormSectionLabel(
                label: 'Data Anak / Pendamping',
                icon: Icons.groups_outlined,
              ),
              const SizedBox(height: PkSpacing.sm),
              Wrap(
                spacing: PkSpacing.md,
                runSpacing: PkSpacing.md,
                children: [
                  SizedBox(
                    width: fieldWidth,
                    child: _ProfileTextField(
                      controller: _childNameController,
                      label: 'Nama anak / pendamping',
                      hint: 'Contoh: Raka',
                      icon: Icons.person_outline_rounded,
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: _ProfileTextField(
                      controller: _childPhoneController,
                      label: 'Nomor HP anak',
                      hint: 'Contoh: 081234567890',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: _ProfileTextField(
                      controller: _relationshipController,
                      label: 'Hubungan',
                      hint: 'Contoh: Anak kandung',
                      icon: Icons.family_restroom_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: PkSpacing.lg),
              _FormSectionLabel(
                label: 'Data Lansia',
                icon: Icons.elderly_rounded,
              ),
              const SizedBox(height: PkSpacing.sm),
              Wrap(
                spacing: PkSpacing.md,
                runSpacing: PkSpacing.md,
                children: [
                  SizedBox(
                    width: fieldWidth,
                    child: _ProfileTextField(
                      controller: _elderNameController,
                      label: 'Nama lansia / orang tua',
                      hint: 'Contoh: Ibu Siti',
                      icon: Icons.person_outline_rounded,
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: _ProfileTextField(
                      controller: _elderAgeController,
                      label: 'Umur lansia',
                      hint: 'Contoh: 68',
                      icon: Icons.cake_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: _ProfileTextField(
                      controller: _elderWeightController,
                      label: 'Berat badan lansia',
                      hint: 'Contoh: 62',
                      icon: Icons.monitor_weight_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: _ProfileTextField(
                      controller: _elderGenderController,
                      label: 'Jenis kelamin',
                      hint: 'Contoh: Perempuan',
                      icon: Icons.wc_rounded,
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: _ProfileTextField(
                      controller: _elderPhoneController,
                      label: 'Nomor HP lansia',
                      hint: 'Contoh: 081298765432',
                      icon: Icons.phone_android_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  SizedBox(
                    width: fieldWidth,
                    child: _ProfileTextField(
                      controller: _elderAddressController,
                      label: 'Alamat lansia',
                      hint: 'Contoh: Tangerang',
                      icon: Icons.home_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: PkSpacing.md),
              _ProfileTextField(
                controller: _medicalHistoryController,
                label: 'Riwayat penyakit / catatan penting',
                hint: 'Contoh: Hipertensi, diabetes, alergi obat',
                icon: Icons.medical_information_outlined,
                minLines: 2,
                maxLines: 4,
              ),
              const SizedBox(height: PkSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Simpan Profil Keluarga'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _save() {
    final medicalHistory = _medicalHistoryController.text
        .split(RegExp(r'[,;\n]'))
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();

    ref.read(elderProfileProvider.notifier).updateFamilyIdentity(
          elderName: _elderNameController.text,
          elderAge: _elderAgeController.text,
          elderWeight: _elderWeightController.text,
          elderGender: _elderGenderController.text,
          elderPhoneNumber: _elderPhoneController.text,
          elderAddress: _elderAddressController.text,
          medicalHistory: medicalHistory,
        );

    ref.read(caregiverProfileProvider.notifier).updateFamilyIdentity(
          childName: _childNameController.text,
          childPhoneNumber: _childPhoneController.text,
          relationship: _relationshipController.text,
          elderName: _elderNameController.text,
        );

    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil keluarga tersimpan dan sudah sinkron ke dasbor.'),
      ),
    );
  }
}

class _FormSectionLabel extends StatelessWidget {
  const _FormSectionLabel({
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: PkColors.brand),
        const SizedBox(width: PkSpacing.sm),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: PkColors.text,
                fontWeight: FontWeight.w900,
              ),
        ),
      ],
    );
  }
}

class _ProfileTextField extends StatelessWidget {
  const _ProfileTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.minLines = 1,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final int minLines;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: maxLines == 1 ? TextInputAction.next : TextInputAction.newline,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
    );
  }
}

class _CaregiverIdentityCard extends StatelessWidget {
  const _CaregiverIdentityCard({required this.caregiver});

  final CaregiverProfile caregiver;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const PkIconBox(icon: Icons.groups_outlined, tone: PkTone.blue),
              const SizedBox(width: PkSpacing.md),
              Expanded(
                child: Text(
                  caregiver.displayName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: PkColors.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: PkSpacing.lg),
          _InfoRow(label: 'Mode', value: 'PeduliPenuh', icon: Icons.verified_user_outlined),
          _InfoRow(label: 'Nomor telepon', value: caregiver.displayPhone, icon: Icons.phone_outlined),
          _InfoRow(label: 'Hubungan dengan lansia', value: caregiver.displayRelationship, icon: Icons.family_restroom_rounded),
          _InfoRow(label: 'Nama orang tua/lansia', value: caregiver.displayElderName, icon: Icons.elderly_rounded),
          _InfoRow(label: 'Status koneksi', value: caregiver.hasLinkedElder ? 'Terhubung' : 'Belum terhubung', icon: Icons.link_rounded),
          _InfoRow(label: 'Tanggal terhubung', value: caregiver.displayConnectedAt, icon: Icons.event_available_outlined),
          _InfoRow(label: 'Kode koneksi yang digunakan', value: caregiver.displayConnectionCode, icon: Icons.qr_code_2_rounded),
        ],
      ),
    );
  }
}

class _ConnectFamilyCard extends StatefulWidget {
  const _ConnectFamilyCard({
    required this.isConnected,
    required this.onConnect,
    required this.onScan,
  });

  final bool isConnected;
  final ValueChanged<String> onConnect;
  final VoidCallback onScan;

  @override
  State<_ConnectFamilyCard> createState() => _ConnectFamilyCardState();
}

class _ConnectFamilyCardState extends State<_ConnectFamilyCard> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PkCard(
      tint: widget.isConnected ? PkColors.greenSoft : PkColors.amberSoft,
      borderColor: widget.isConnected
          ? PkColors.green.withValues(alpha: 0.18)
          : PkColors.amber.withValues(alpha: 0.18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PkIconBox(
                icon: widget.isConnected ? Icons.check_circle_outline_rounded : Icons.qr_code_scanner_rounded,
                tone: widget.isConnected ? PkTone.green : PkTone.amber,
              ),
              const SizedBox(width: PkSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isConnected ? 'Akun keluarga terhubung' : 'Hubungkan lansia',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: PkColors.text,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    Text(
                      widget.isConnected
                          ? 'Data lansia sudah bisa dipantau melalui PeduliPenuh.'
                          : 'Masukkan kode atau pindai QR Code dari akun PeduliDiri.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: PkColors.text2),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: PkSpacing.lg),
          TextField(
            controller: _codeController,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              labelText: 'Kode koneksi',
              hintText: 'Contoh: PK-482913',
              prefixIcon: Icon(Icons.key_rounded),
            ),
          ),
          const SizedBox(height: PkSpacing.md),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => widget.onConnect(_codeController.text),
                  icon: const Icon(Icons.link_rounded),
                  label: const Text('Hubungkan'),
                ),
              ),
              const SizedBox(width: PkSpacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: widget.onScan,
                  icon: const Icon(Icons.qr_code_scanner_rounded),
                  label: const Text('Scan QR Code'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QrScannerSheet extends StatefulWidget {
  const _QrScannerSheet();

  @override
  State<_QrScannerSheet> createState() => _QrScannerSheetState();
}

class _QrScannerSheetState extends State<_QrScannerSheet> {
  late final MobileScannerController _controller;
  bool _hasResult = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(facing: CameraFacing.back);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.72,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scan QR Code PeduliDiri',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: PkColors.text,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Arahkan kamera belakang ke QR Code pada akun PeduliDiri.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: PkColors.text2),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: PkRadius.mdRadius,
                child: MobileScanner(
                  controller: _controller,
                  onDetect: (capture) {
                    if (_hasResult) return;
                    final value = capture.barcodes.isEmpty ? null : capture.barcodes.first.rawValue;
                    if (value == null || value.trim().isEmpty) return;
                    _hasResult = true;
                    Navigator.of(context).pop(value);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
                label: const Text('Tutup'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkedElderCard extends StatelessWidget {
  const _LinkedElderCard({required this.profile, required this.caregiver});

  final ElderProfile profile;
  final CaregiverProfile caregiver;

  @override
  Widget build(BuildContext context) {
    if (!caregiver.hasLinkedElder) {
      return PkCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const PkIconBox(icon: Icons.elderly_rounded, tone: PkTone.amber),
                const SizedBox(width: PkSpacing.md),
                Expanded(
                  child: Text(
                    'Orang tua yang akan dipantau',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: PkColors.text,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: PkSpacing.lg),
            _InfoRow(label: 'Nama orang tua/lansia', value: caregiver.displayElderName, icon: Icons.person_outline_rounded),
            const SizedBox(height: PkSpacing.sm),
            Text(
              'Belum ada lansia terhubung. Masukkan kode atau pindai QR Code dari akun PeduliDiri agar data kesehatan orang tua tampil lengkap.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: PkColors.text2, height: 1.6),
            ),
          ],
        ),
      );
    }

    return PkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const PkIconBox(icon: Icons.elderly_rounded, tone: PkTone.brand),
              const SizedBox(width: PkSpacing.md),
              Expanded(
                child: Text(
                  'Data lansia yang dipantau',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: PkColors.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: PkSpacing.lg),
          _InfoRow(label: 'Nama lansia', value: profile.name.trim().isEmpty ? caregiver.displayElderName : profile.displayName, icon: Icons.person_outline_rounded),
          _InfoRow(label: 'Umur', value: profile.displayAge, icon: Icons.cake_outlined),
          _InfoRow(label: 'Berat badan', value: profile.displayWeight, icon: Icons.monitor_weight_outlined),
          _InfoRow(label: 'Jenis kelamin', value: profile.displayGender, icon: Icons.wc_rounded),
          _InfoRow(label: 'Alamat lansia', value: profile.displayAddress, icon: Icons.home_outlined),
          _InfoRow(label: 'Riwayat penyakit lansia', value: profile.medicalHistoryLabel, icon: Icons.medical_information_outlined),
        ],
      ),
    );
  }
}

class _ProfileIdentityCard extends StatelessWidget {
  const _ProfileIdentityCard({required this.profile});

  final ElderProfile profile;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const PkIconBox(icon: Icons.elderly_rounded, tone: PkTone.brand),
              const SizedBox(width: PkSpacing.md),
              Expanded(
                child: Text(
                  profile.displayName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: PkColors.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: PkSpacing.lg),
          _InfoRow(label: 'Umur', value: profile.displayAge, icon: Icons.cake_outlined),
          _InfoRow(label: 'Berat badan', value: profile.displayWeight, icon: Icons.monitor_weight_outlined),
          _InfoRow(label: 'Jenis kelamin', value: profile.displayGender, icon: Icons.wc_rounded),
          _InfoRow(label: 'Nomor telepon', value: profile.displayPhone, icon: Icons.phone_outlined),
          _InfoRow(label: 'Alamat', value: profile.displayAddress, icon: Icons.home_outlined),
          _InfoRow(label: 'Riwayat penyakit', value: profile.medicalHistoryLabel, icon: Icons.medical_information_outlined),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: PkSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: PkColors.brand),
          const SizedBox(width: PkSpacing.md),
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
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: PkColors.text,
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

class _ProfileCompleteRecordCard extends StatelessWidget {
  const _ProfileCompleteRecordCard({
    required this.profile,
    required this.caregiver,
    required this.medicationState,
    required this.cekState,
    required this.mode,
  });

  final ElderProfile profile;
  final CaregiverProfile caregiver;
  final PeduliObatState medicationState;
  final PeduliCekState cekState;
  final AppUserMode mode;

  @override
  Widget build(BuildContext context) {
    final isCaregiver = mode == AppUserMode.caregiver;

    return PkCard(
      tint: PkColors.surface.withValues(alpha: 0.96),
      borderColor: PkColors.blue.withValues(alpha: 0.14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const PkIconBox(icon: Icons.folder_shared_outlined, tone: PkTone.blue),
              const SizedBox(width: PkSpacing.md),
              Expanded(
                child: Text(
                  'Data Lengkap & Riwayat',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: PkColors.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
              PkBadge(
                label: isCaregiver ? 'PeduliPenuh' : 'PeduliDiri',
                tone: isCaregiver ? PkTone.blue : PkTone.brand,
              ),
            ],
          ),
          const SizedBox(height: PkSpacing.lg),
          _InfoRow(
            label: 'Nama lansia',
            value: profile.name.trim().isEmpty ? caregiver.displayElderName : profile.displayName,
            icon: Icons.elderly_rounded,
          ),
          _InfoRow(label: 'Nama anak/pendamping', value: caregiver.displayName, icon: Icons.groups_outlined),
          _InfoRow(label: 'Nomor lansia', value: profile.displayPhone, icon: Icons.phone_outlined),
          _InfoRow(label: 'Nomor anak/pendamping', value: caregiver.displayPhone, icon: Icons.phone_android_outlined),
          _InfoRow(label: 'Alamat lansia', value: profile.displayAddress, icon: Icons.home_outlined),
          _InfoRow(label: 'Riwayat penyakit', value: profile.medicalHistoryLabel, icon: Icons.medical_information_outlined),
          const Divider(height: 28),
          Text(
            'Catatan jadwal obat hari ini',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: PkColors.text,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: PkSpacing.md),
          if (medicationState.effectiveSchedules.isEmpty)
            Text(
              'Belum ada jadwal obat hari ini.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: PkColors.text2),
            )
          else
            for (final schedule in medicationState.effectiveSchedules)
              _CompactRecordTile(
                icon: Icons.schedule_outlined,
                tone: medicationState.takenScheduleIds.contains(schedule.id)
                    ? PkTone.green
                    : PkTone.amber,
                title: '${schedule.time} · ${schedule.title}',
                subtitle: medicationState.takenScheduleIds.contains(schedule.id)
                    ? 'Sudah diminum · ${schedule.copy}'
                    : 'Menunggu · ${schedule.copy}',
              ),
          const SizedBox(height: PkSpacing.md),
          Text(
            'Riwayat obat',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: PkColors.text,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: PkSpacing.md),
          for (final log in medicationState.logs.take(3))
            _CompactRecordTile(
              icon: Icons.history_outlined,
              tone: log.tone,
              title: log.title,
              subtitle: '${log.time} · ${log.copy}',
            ),
          const SizedBox(height: PkSpacing.md),
          Text(
            'Riwayat PeduliCek & poin',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: PkColors.text,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: PkSpacing.md),
          _CompactRecordTile(
            icon: Icons.fact_check_outlined,
            tone: cekState.submitted ? cekState.overallLevel.tone : PkTone.amber,
            title: cekState.submitted ? cekState.resultTitle : 'PeduliCek hari ini belum dikirim',
            subtitle: cekState.submittedAt == null
                ? 'Belum ada ringkasan cek harian terbaru.'
                : 'Dikirim pukul ${_formatProfileTime(cekState.submittedAt!)} · ${cekState.bloodPressureValue} · ${cekState.glucoseValue}',
          ),
          _CompactRecordTile(
            icon: Icons.emoji_events_outlined,
            tone: PkTone.green,
            title: '${cekState.totalPoints} poin terkumpul',
            subtitle: '${cekState.currentStreak} hari streak · poin bisa ditukarkan pada fitur reward.',
          ),
        ],
      ),
    );
  }

  String _formatProfileTime(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}

class _CompactRecordTile extends StatelessWidget {
  const _CompactRecordTile({
    required this.icon,
    required this.tone,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final PkTone tone;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: PkSpacing.sm),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: pkToneSoft(tone),
        borderRadius: PkRadius.smRadius,
        border: Border.all(color: pkToneColor(tone).withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PkIconBox(icon: icon, tone: tone, size: 38, iconSize: 20),
          const SizedBox(width: PkSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: PkColors.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: PkColors.text2,
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

class _CaregiverListCard extends StatelessWidget {
  const _CaregiverListCard({required this.caregivers});

  final List<CaregiverConnection> caregivers;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              PkIconBox(icon: Icons.family_restroom_rounded, tone: PkTone.blue),
              SizedBox(width: PkSpacing.md),
              Expanded(
                child: Text(
                  'Keluarga Terhubung',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: PkColors.text,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: PkSpacing.lg),
          if (caregivers.isEmpty)
            Text(
              'Belum ada keluarga terhubung. Bagikan kode atau QR Code kepada anak atau pendamping.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: PkColors.text2,
                    height: 1.6,
                  ),
            )
          else
            for (final caregiver in caregivers)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(child: Icon(Icons.person_outline_rounded)),
                title: Text(caregiver.displayName),
                subtitle: Text('${caregiver.displayRelationship} · ${caregiver.displayPhone}'),
              ),
        ],
      ),
    );
  }
}
