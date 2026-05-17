import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/routing/app_route.dart';
import '../../../../core/theme/pk_design.dart';
import '../../../../shared/layouts/page_shell.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../../../state/providers/app_mode_provider.dart';
import '../../../caregiver_profile/providers/caregiver_profile_provider.dart';
import '../../../elder_profile/presentation/widgets/connection_code_card.dart';
import '../../../elder_profile/providers/elder_profile_provider.dart';
import '../../providers/auth_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  static const _conditions = [
    'Hipertensi',
    'Diabetes Tipe 2',
    'Kolesterol',
    'Jantung',
    'Asam Urat',
    'Asma',
    'Maag / GERD',
    'Stroke',
    'Radang Sendi',
    'Ginjal',
  ];

  static const _mobilityNeeds = [
    'Tongkat',
    'Kursi roda',
    'Sering pusing',
    'Risiko jatuh',
    'Pendengaran',
    'Penglihatan',
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _elderAgeController = TextEditingController();
  final _elderHeightController = TextEditingController();
  final _elderWeightController = TextEditingController();
  final _elderPhoneController = TextEditingController();
  final _elderAddressController = TextEditingController();
  final _allergiesController = TextEditingController();

  final _caregiverPhoneController = TextEditingController();
  final _caregiverRelationshipController = TextEditingController();
  final _caregiverAddressController = TextEditingController();
  final _familyCodeController = TextEditingController();

  AppUserMode? _selectedMode;
  String _elderGender = '';
  final Set<String> _healthConditions = <String>{};
  final Set<String> _mobilityNeedsSelected = <String>{};

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _connectedInRegister = false;
  int _step = 0;

  int get _lastStep => _selectedMode == AppUserMode.caregiver ? 3 : 3;

  bool get _isElder => _selectedMode == AppUserMode.elder;

  bool get _isCaregiver => _selectedMode == AppUserMode.caregiver;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _elderAgeController.dispose();
    _elderHeightController.dispose();
    _elderWeightController.dispose();
    _elderPhoneController.dispose();
    _elderAddressController.dispose();
    _allergiesController.dispose();
    _caregiverPhoneController.dispose();
    _caregiverRelationshipController.dispose();
    _caregiverAddressController.dispose();
    _familyCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    final modeLabel = _selectedMode == null
        ? 'Pilih Lansia atau Anak/Pendamping'
        : _isElder
            ? 'Daftar sebagai Lansia'
            : 'Daftar sebagai Anak/Pendamping';

    return PageShell(
      title: 'Daftar',
      subtitle: 'Daftar menjadi halaman default. Login masih mockup dan belum aktif.',
      icon: Icons.person_add_alt_1_rounded,
      maxWidth: 760,
      children: [
        PkCard(
          soft: true,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_step == 0) ...[
                  const Center(child: AppLogo(size: 300, withBackground: false)),
                  const SizedBox(height: PkSpacing.lg),
                ],
                _RegisterProgressHeader(
                  currentStep: _step + 1,
                  totalSteps: 4,
                  title: _stepTitle,
                  subtitle: modeLabel,
                ),
                const SizedBox(height: PkSpacing.xl),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  child: KeyedSubtree(
                    key: ValueKey('register-step-$_step-${_selectedMode?.name ?? 'none'}'),
                    child: _buildStepBody(auth),
                  ),
                ),
                if (auth.errorMessage != null) ...[
                  const SizedBox(height: PkSpacing.md),
                  _RegisterErrorBanner(message: auth.errorMessage!),
                ],
                const SizedBox(height: PkSpacing.xl),
                _RegisterNavigationBar(
                  isFirstStep: _step == 0,
                  isLastStep: _step == _lastStep,
                  isLoading: auth.isLoading,
                  nextLabel: _step == _lastStep ? 'Masuk ke Dasbor' : 'Lanjut',
                  onBack: _step == 0 ? null : _goBack,
                  onNext: auth.isLoading ? null : () => _goNext(auth),
                ),
                const SizedBox(height: PkSpacing.md),
                TextButton(
                  onPressed: auth.isLoading ? null : () => context.goNamed(AppRoute.login.name),
                  child: const Text('Sudah punya akun? Lihat halaman login mockup'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String get _stepTitle {
    if (_step == 0) return 'Buat akun dengan email';
    if (_step == 1) {
      if (_isCaregiver) return 'Lengkapi profil anak';
      return 'Lengkapi profil lansia';
    }
    if (_step == 2) {
      if (_isCaregiver) return 'Panduan PeduliKeluarga';
      return 'Kondisi kesehatan Anda';
    }
    if (_isCaregiver) return 'Hubungkan dengan lansia';
    return 'QR dan kode keluarga';
  }

  Widget _buildStepBody(AuthState auth) {
    if (_step == 0) return _accountStep();
    if (_step == 1) {
      return _isCaregiver ? _caregiverProfileStep() : _elderProfileStep();
    }
    if (_step == 2) {
      return _isCaregiver ? const _CaregiverGuideStep() : _elderHealthStep();
    }
    return _isCaregiver ? _caregiverConnectStep() : _elderQrStep();
  }

  Widget _accountStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Buat akun PeduliKeluarga',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: PkColors.text,
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: PkSpacing.xs),
        Text(
          'Nama yang Anda isi di sini akan dipakai sebagai nama profil dan tampilan lain di aplikasi.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: PkColors.text2,
                height: 1.5,
              ),
        ),
        const SizedBox(height: PkSpacing.xl),
        TextFormField(
          controller: _nameController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Nama',
            hintText: 'Contoh: Faryvd',
            prefixIcon: Icon(Icons.badge_outlined),
          ),
          textInputAction: TextInputAction.next,
          validator: _validateName,
        ),
        const SizedBox(height: PkSpacing.md),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
            hintText: 'contoh@email.com',
            prefixIcon: Icon(Icons.email_outlined),
          ),
          textInputAction: TextInputAction.next,
          validator: _validateEmail,
        ),
        const SizedBox(height: PkSpacing.md),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              tooltip: _obscurePassword ? 'Tampilkan password' : 'Sembunyikan password',
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
            ),
          ),
          textInputAction: TextInputAction.next,
          validator: _validatePassword,
        ),
        const SizedBox(height: PkSpacing.md),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: InputDecoration(
            labelText: 'Konfirmasi password',
            prefixIcon: const Icon(Icons.lock_reset_rounded),
            suffixIcon: IconButton(
              tooltip: _obscureConfirmPassword
                  ? 'Tampilkan konfirmasi password'
                  : 'Sembunyikan konfirmasi password',
              onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              icon: Icon(_obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
            ),
          ),
          textInputAction: TextInputAction.done,
          validator: _validateConfirmPassword,
        ),
        const SizedBox(height: PkSpacing.lg),
        _RegisterRoleSelector(
          selectedMode: _selectedMode,
          onChanged: (value) {
            setState(() {
              _selectedMode = value;
              _connectedInRegister = false;
            });
          },
        ),
      ],
    );
  }

  Widget _elderProfileStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _StepIntroCard(
          icon: Icons.elderly_rounded,
          tone: PkTone.brand,
          title: 'Data lansia',
          subtitle: 'Data ini akan masuk ke Profil PeduliDiri dan bisa diubah kembali melalui menu Ubah Profil.',
        ),
        const SizedBox(height: PkSpacing.lg),
        _GenderSelector(
          value: _elderGender,
          onChanged: (value) => setState(() => _elderGender = value),
        ),
        const SizedBox(height: PkSpacing.md),
        _ResponsiveFieldWrap(
          children: [
            TextFormField(
              controller: _elderAgeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Usia',
                hintText: 'Contoh: 68',
                prefixIcon: Icon(Icons.cake_outlined),
              ),
              validator: (value) => _validateRequiredNumber(value, 'Usia'),
            ),
            TextFormField(
              controller: _elderHeightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tinggi badan (cm)',
                hintText: 'Contoh: 160',
                prefixIcon: Icon(Icons.height_rounded),
              ),
              validator: (value) => _validateRequiredNumber(value, 'Tinggi badan'),
            ),
            TextFormField(
              controller: _elderWeightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Berat badan (kg)',
                hintText: 'Contoh: 62',
                prefixIcon: Icon(Icons.monitor_weight_outlined),
              ),
              validator: (value) => _validateRequiredNumber(value, 'Berat badan'),
            ),
            TextFormField(
              controller: _elderPhoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Nomor HP',
                hintText: 'Contoh: 081234567890',
                prefixIcon: Icon(Icons.phone_android_outlined),
              ),
              validator: _validatePhone,
            ),
          ],
        ),
        const SizedBox(height: PkSpacing.md),
        TextFormField(
          controller: _elderAddressController,
          minLines: 2,
          maxLines: 3,
          textInputAction: TextInputAction.newline,
          decoration: const InputDecoration(
            labelText: 'Alamat',
            hintText: 'Contoh: Jl. Melati No. 10, Tangerang',
            prefixIcon: Icon(Icons.home_outlined),
          ),
          validator: (value) => _validateRequired(value, 'Alamat'),
        ),
      ],
    );
  }

  Widget _caregiverProfileStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _StepIntroCard(
          icon: Icons.groups_rounded,
          tone: PkTone.blue,
          title: 'Data anak / pendamping',
          subtitle: 'Nomor HP, hubungan, dan alamat akan tampil di Profil PeduliPenuh.',
        ),
        const SizedBox(height: PkSpacing.lg),
        TextFormField(
          controller: _caregiverPhoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Nomor HP anak / pendamping',
            hintText: 'Contoh: 081234567890',
            prefixIcon: Icon(Icons.phone_outlined),
          ),
          validator: _validatePhone,
        ),
        const SizedBox(height: PkSpacing.md),
        TextFormField(
          controller: _caregiverRelationshipController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Hubungan dengan lansia',
            hintText: 'Contoh: Anak kandung',
            prefixIcon: Icon(Icons.family_restroom_rounded),
          ),
          validator: (value) => _validateRequired(value, 'Hubungan dengan lansia'),
        ),
        const SizedBox(height: PkSpacing.md),
        TextFormField(
          controller: _caregiverAddressController,
          minLines: 2,
          maxLines: 3,
          textInputAction: TextInputAction.newline,
          decoration: const InputDecoration(
            labelText: 'Alamat anak / pendamping',
            hintText: 'Contoh: Jl. Kenanga No. 8, Tangerang',
            prefixIcon: Icon(Icons.home_outlined),
          ),
          validator: (value) => _validateRequired(value, 'Alamat'),
        ),
      ],
    );
  }

  Widget _elderHealthStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _StepIntroCard(
          icon: Icons.health_and_safety_outlined,
          tone: PkTone.green,
          title: 'Kondisi kesehatan Anda',
          subtitle: 'Pilih kondisi yang relevan agar PeduliCek, PeduliObat, dan PeduliDarurat terasa lebih personal.',
        ),
        const SizedBox(height: PkSpacing.lg),
        Text(
          'Kondisi utama',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: PkColors.text,
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: PkSpacing.md),
        Wrap(
          spacing: PkSpacing.sm,
          runSpacing: PkSpacing.sm,
          children: [
            for (final condition in _conditions)
              _SelectableHealthChip(
                label: condition,
                selected: _healthConditions.contains(condition),
                tone: condition.contains('Jantung') || condition.contains('Stroke') || condition.contains('Ginjal')
                    ? PkTone.red
                    : PkTone.brand,
                onTap: () {
                  setState(() {
                    _healthConditions.contains(condition)
                        ? _healthConditions.remove(condition)
                        : _healthConditions.add(condition);
                  });
                },
              ),
          ],
        ),
        const SizedBox(height: PkSpacing.xl),
        Text(
          'Kebutuhan mobilitas',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: PkColors.text,
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: PkSpacing.md),
        Wrap(
          spacing: PkSpacing.sm,
          runSpacing: PkSpacing.sm,
          children: [
            for (final need in _mobilityNeeds)
              _SelectableHealthChip(
                label: need,
                selected: _mobilityNeedsSelected.contains(need),
                tone: PkTone.amber,
                onTap: () {
                  setState(() {
                    _mobilityNeedsSelected.contains(need)
                        ? _mobilityNeedsSelected.remove(need)
                        : _mobilityNeedsSelected.add(need);
                  });
                },
              ),
          ],
        ),
        const SizedBox(height: PkSpacing.xl),
        TextFormField(
          controller: _allergiesController,
          minLines: 3,
          maxLines: 5,
          textInputAction: TextInputAction.newline,
          decoration: const InputDecoration(
            labelText: 'Alergi / catatan khusus',
            hintText: 'Contoh: alergi seafood, tidak kuat obat tertentu',
            prefixIcon: Icon(Icons.note_alt_outlined),
          ),
        ),
        const SizedBox(height: PkSpacing.md),
        const _StepIntroCard(
          icon: Icons.add_circle_outline_rounded,
          tone: PkTone.green,
          title: 'Bisa ditambah nanti',
          subtitle: 'Kondisi kesehatan dapat diperbarui kapan saja dari halaman Profil.',
        ),
      ],
    );
  }

  Widget _elderQrStep() {
    final profile = ref.watch(elderProfileProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _StepIntroCard(
          icon: Icons.qr_code_2_rounded,
          tone: PkTone.brand,
          title: 'Bagikan QR dan kode keluarga',
          subtitle: 'Anak atau pendamping dapat scan QR ini atau memasukkan kode agar terhubung dengan profil Anda.',
        ),
        const SizedBox(height: PkSpacing.lg),
        ConnectionCodeCard(profile: profile, compact: true),
      ],
    );
  }

  Widget _caregiverConnectStep() {
    final connected = _connectedInRegister || ref.watch(caregiverProfileProvider).hasLinkedElder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepIntroCard(
          icon: connected ? Icons.check_circle_outline_rounded : Icons.qr_code_scanner_rounded,
          tone: connected ? PkTone.green : PkTone.amber,
          title: connected ? 'Integrasi berhasil' : 'Scan QR atau masukkan kode',
          subtitle: connected
              ? 'Akun anak sudah terhubung dengan akun lansia pada mockup ini.'
              : 'Gunakan QR atau kode keluarga dari profil PeduliDiri milik lansia.',
        ),
        const SizedBox(height: PkSpacing.lg),
        TextFormField(
          controller: _familyCodeController,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: 'Kode keluarga',
            hintText: 'Contoh: PK-482913',
            prefixIcon: Icon(Icons.key_rounded),
          ),
        ),
        const SizedBox(height: PkSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 520;
            final connectButton = FilledButton.icon(
              onPressed: () => _tryConnect(_familyCodeController.text),
              icon: const Icon(Icons.link_rounded),
              label: const Text('Hubungkan Kode'),
            );
            final scanButton = OutlinedButton.icon(
              onPressed: _scanQrFromRegister,
              icon: const Icon(Icons.qr_code_scanner_rounded),
              label: const Text('Scan QR Code'),
            );

            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  connectButton,
                  const SizedBox(height: PkSpacing.sm),
                  scanButton,
                ],
              );
            }

            return Row(
              children: [
                Expanded(child: connectButton),
                const SizedBox(width: PkSpacing.sm),
                Expanded(child: scanButton),
              ],
            );
          },
        ),
        const SizedBox(height: PkSpacing.lg),
        const _StepIntroCard(
          icon: Icons.info_outline_rounded,
          tone: PkTone.blue,
          title: 'Belum punya kode?',
          subtitle: 'Anda tetap bisa masuk ke dasbor. Fitur seperti obat, riwayat, pantau, dan pengingat akan tampil/personal setelah akun lansia berhasil diintegrasikan.',
        ),
      ],
    );
  }

  void _goBack() {
    if (_step == 0) return;
    setState(() => _step -= 1);
  }

  Future<void> _goNext(AuthState auth) async {
    if (!_validateCurrentStep()) return;

    if (_step == 1 || (_isElder && _step == 2)) {
      _saveProfilesFromRegister();
    }

    if (_step == _lastStep) {
      await _finishRegistration(auth);
      return;
    }

    setState(() => _step += 1);
  }

  bool _validateCurrentStep() {
    if (!_formKey.currentState!.validate()) return false;

    if (_step == 0 && _selectedMode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih daftar sebagai Lansia atau Anak/Pendamping terlebih dahulu.')),
      );
      return false;
    }

    if (_step == 1 && _isElder && _elderGender.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jenis kelamin lansia wajib dipilih.')),
      );
      return false;
    }

    return true;
  }

  void _saveProfilesFromRegister() {
    final name = _nameController.text.trim();

    if (_isElder) {
      final medicalHistory = <String>{
        ..._healthConditions,
        ..._mobilityNeedsSelected,
        if (_allergiesController.text.trim().isNotEmpty) _allergiesController.text.trim(),
      }.toList();

      ref.read(elderProfileProvider.notifier).updateFamilyIdentity(
            elderName: name,
            elderAge: _elderAgeController.text,
            elderHeight: _elderHeightController.text,
            elderWeight: _elderWeightController.text,
            elderGender: _elderGender,
            elderPhoneNumber: _elderPhoneController.text,
            elderAddress: _elderAddressController.text,
            medicalHistory: medicalHistory,
          );
      return;
    }

    ref.read(caregiverProfileProvider.notifier).updateIdentity(
          name: name,
          phoneNumber: _caregiverPhoneController.text,
          relationship: _caregiverRelationshipController.text,
          address: _caregiverAddressController.text,
        );
  }

  Future<void> _finishRegistration(AuthState auth) async {
    if (auth.isLoading) return;

    _saveProfilesFromRegister();

    if (_isCaregiver && _familyCodeController.text.trim().isNotEmpty) {
      _tryConnect(_familyCodeController.text, showMessage: false);
    }

    final mode = _selectedMode;
    if (mode == null) return;

    final success = await ref.read(authControllerProvider.notifier).register(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          mode: mode,
        );

    if (!mounted) return;

    if (success) {
      context.goNamed(AppRoute.home.name);
      return;
    }

    final message = ref.read(authControllerProvider).errorMessage;
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _scanQrFromRegister() async {
    final scanned = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => const _QrScannerSheet(),
    );

    if (scanned == null || scanned.trim().isEmpty) return;
    _familyCodeController.text = scanned;
    _tryConnect(scanned);
  }

  bool _tryConnect(String value, {bool showMessage = true}) {
    _saveProfilesFromRegister();

    if (value.trim().isEmpty) {
      if (showMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Masukkan kode keluarga atau scan QR terlebih dahulu.')),
        );
      }
      return false;
    }

    final success = ref.read(caregiverProfileProvider.notifier).connectWithCode(value);
    setState(() => _connectedInRegister = success);

    if (showMessage) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Akun PeduliDiri berhasil terhubung.'
              : 'Kode/QR belum sesuai. Pastikan kode berasal dari Profil PeduliDiri lansia.'),
        ),
      );
    }

    return success;
  }

  String? _validateName(String? value) {
    final clean = value?.trim() ?? '';
    if (clean.isEmpty) return 'Nama wajib diisi.';
    if (clean.length < 2) return 'Nama terlalu pendek.';
    return null;
  }

  String? _validateEmail(String? value) {
    final clean = value?.trim() ?? '';
    if (clean.isEmpty) return 'Email wajib diisi.';
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(clean)) return 'Masukkan email yang valid.';
    return null;
  }

  String? _validatePassword(String? value) {
    final clean = value ?? '';
    if (clean.isEmpty) return 'Password wajib diisi.';
    if (clean.length < 6) return 'Password minimal 6 karakter.';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final clean = value ?? '';
    if (clean.isEmpty) return 'Konfirmasi password wajib diisi.';
    if (clean != _passwordController.text) return 'Konfirmasi password harus sama dengan password.';
    return null;
  }

  String? _validatePhone(String? value) {
    final clean = value?.replaceAll(RegExp(r'[\s-]'), '') ?? '';
    if (clean.isEmpty) return 'Nomor HP wajib diisi.';
    final phoneRegex = RegExp(r'^(?:\+62|62|0)8[0-9]{7,12}$');
    if (!phoneRegex.hasMatch(clean)) return 'Masukkan nomor HP Indonesia yang valid.';
    return null;
  }

  String? _validateRequiredNumber(String? value, String label) {
    final clean = value?.trim() ?? '';
    if (clean.isEmpty) return '$label wajib diisi.';
    final number = int.tryParse(clean);
    if (number == null || number <= 0) return '$label harus berupa angka.';
    return null;
  }

  String? _validateRequired(String? value, String label) {
    final clean = value?.trim() ?? '';
    if (clean.isEmpty) return '$label wajib diisi.';
    return null;
  }
}

class _RegisterProgressHeader extends StatelessWidget {
  const _RegisterProgressHeader({
    required this.currentStep,
    required this.totalSteps,
    required this.title,
    required this.subtitle,
  });

  final int currentStep;
  final int totalSteps;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            PkBadge(label: 'Langkah $currentStep dari $totalSteps', icon: Icons.flag_outlined),
            const Spacer(),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: PkColors.text2,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
        const SizedBox(height: PkSpacing.md),
        LinearProgressIndicator(
          value: currentStep / totalSteps,
          minHeight: 8,
          borderRadius: PkRadius.pillRadius,
          backgroundColor: PkColors.brandSoft,
        ),
        const SizedBox(height: PkSpacing.lg),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: PkColors.text,
                fontWeight: FontWeight.w900,
              ),
        ),
      ],
    );
  }
}

class _RegisterNavigationBar extends StatelessWidget {
  const _RegisterNavigationBar({
    required this.isFirstStep,
    required this.isLastStep,
    required this.isLoading,
    required this.nextLabel,
    required this.onBack,
    required this.onNext,
  });

  final bool isFirstStep;
  final bool isLastStep;
  final bool isLoading;
  final String nextLabel;
  final VoidCallback? onBack;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 520;
        final backButton = OutlinedButton.icon(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_rounded),
          label: const Text('Kembali'),
        );
        final nextButton = FilledButton.icon(
          onPressed: onNext,
          icon: isLoading
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : Icon(isLastStep ? Icons.dashboard_customize_outlined : Icons.arrow_forward_rounded),
          label: Text(isLoading ? 'Memproses...' : nextLabel),
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              nextButton,
              if (!isFirstStep) ...[
                const SizedBox(height: PkSpacing.sm),
                backButton,
              ],
            ],
          );
        }

        return Row(
          children: [
            if (!isFirstStep) Expanded(child: backButton) else const Spacer(),
            if (!isFirstStep) const SizedBox(width: PkSpacing.md),
            Expanded(child: nextButton),
          ],
        );
      },
    );
  }
}

class _RegisterRoleSelector extends StatelessWidget {
  const _RegisterRoleSelector({
    required this.selectedMode,
    required this.onChanged,
  });

  final AppUserMode? selectedMode;
  final ValueChanged<AppUserMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return FormField<AppUserMode>(
      initialValue: selectedMode,
      validator: (value) => value == null ? 'Peran wajib dipilih.' : null,
      builder: (field) {
        void select(AppUserMode value) {
          field.didChange(value);
          onChanged(value);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daftar sebagai',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: PkColors.text,
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: PkSpacing.sm),
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 440;

                final elder = _RegisterRoleOption(
                  label: 'Lansia',
                  subtitle: 'Saya menggunakan PeduliDiri',
                  icon: Icons.elderly_rounded,
                  selected: selectedMode == AppUserMode.elder,
                  onTap: () => select(AppUserMode.elder),
                );

                final caregiver = _RegisterRoleOption(
                  label: 'Anak / Pendamping',
                  subtitle: 'Saya memantau keluarga',
                  icon: Icons.groups_rounded,
                  selected: selectedMode == AppUserMode.caregiver,
                  onTap: () => select(AppUserMode.caregiver),
                );

                if (compact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [elder, const SizedBox(height: PkSpacing.md), caregiver],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: elder),
                    const SizedBox(width: PkSpacing.md),
                    Expanded(child: caregiver),
                  ],
                );
              },
            ),
            if (field.hasError) ...[
              const SizedBox(height: PkSpacing.xs),
              Text(
                field.errorText!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _RegisterRoleOption extends StatelessWidget {
  const _RegisterRoleOption({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tone = selected ? PkTone.brand : PkTone.gray;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: PkRadius.smRadius,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(PkSpacing.md),
          decoration: BoxDecoration(
            color: selected ? PkColors.brandSoft : PkColors.surfaceSoft,
            borderRadius: PkRadius.smRadius,
            border: Border.all(
              color: selected ? PkColors.brand : PkColors.line,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              PkIconBox(icon: icon, tone: tone, size: 38, iconSize: 20),
              const SizedBox(width: PkSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: PkColors.text,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: PkColors.text2),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: PkSpacing.sm),
              Icon(
                selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                color: selected ? PkColors.brand : PkColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GenderSelector extends StatelessWidget {
  const _GenderSelector({
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Jenis kelamin',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: PkColors.text,
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: PkSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _GenderOption(
                label: 'Laki-laki',
                icon: Icons.male_rounded,
                selected: value == 'Laki-laki',
                onTap: () => onChanged('Laki-laki'),
              ),
            ),
            const SizedBox(width: PkSpacing.sm),
            Expanded(
              child: _GenderOption(
                label: 'Perempuan',
                icon: Icons.female_rounded,
                selected: value == 'Perempuan',
                onTap: () => onChanged('Perempuan'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GenderOption extends StatelessWidget {
  const _GenderOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: PkRadius.smRadius,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(PkSpacing.md),
        decoration: BoxDecoration(
          color: selected ? PkColors.brandSoft : PkColors.surfaceSoft,
          borderRadius: PkRadius.smRadius,
          border: Border.all(color: selected ? PkColors.brand : PkColors.line),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? PkColors.brand : PkColors.text2),
            const SizedBox(width: PkSpacing.sm),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: PkColors.text,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ),
            Icon(
              selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              color: selected ? PkColors.brand : PkColors.muted,
            ),
          ],
        ),
      ),
    );
  }
}

class _ResponsiveFieldWrap extends StatelessWidget {
  const _ResponsiveFieldWrap({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useTwoColumns = constraints.maxWidth >= 620;
        final width = useTwoColumns ? (constraints.maxWidth - PkSpacing.md) / 2 : constraints.maxWidth;

        return Wrap(
          spacing: PkSpacing.md,
          runSpacing: PkSpacing.md,
          children: [
            for (final child in children) SizedBox(width: width, child: child),
          ],
        );
      },
    );
  }
}

class _SelectableHealthChip extends StatelessWidget {
  const _SelectableHealthChip({
    required this.label,
    required this.selected,
    required this.tone,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final PkTone tone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = pkToneColor(tone);

    return FilterChip(
      selected: selected,
      showCheckmark: false,
      label: Text(label),
      avatar: Icon(selected ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded, size: 18),
      onSelected: (_) => onTap(),
      backgroundColor: PkColors.surfaceSoft,
      selectedColor: pkToneSoft(tone),
      side: BorderSide(color: selected ? color : PkColors.line),
      labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: selected ? color : PkColors.text2,
            fontWeight: FontWeight.w900,
          ),
    );
  }
}

class _CaregiverGuideStep extends StatelessWidget {
  const _CaregiverGuideStep();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        _StepIntroCard(
          icon: Icons.menu_book_outlined,
          tone: PkTone.blue,
          title: 'Cara mengintegrasikan anak dengan lansia',
          subtitle: 'Agar data obat, riwayat, dan pantauan keluarga muncul sesuai kebutuhan lansia, akun anak perlu dihubungkan ke akun PeduliDiri.',
        ),
        SizedBox(height: PkSpacing.lg),
        _GuideItem(
          number: '1',
          title: 'Minta lansia membuka Profil PeduliDiri',
          subtitle: 'Di profil lansia terdapat QR Code dan kode keluarga yang siap dibagikan.',
          icon: Icons.elderly_rounded,
          tone: PkTone.brand,
        ),
        _GuideItem(
          number: '2',
          title: 'Pilih scan QR atau masukkan kode',
          subtitle: 'Anda bisa scan QR dengan kamera atau mengetik kode keluarga seperti PK-482913.',
          icon: Icons.qr_code_scanner_rounded,
          tone: PkTone.amber,
        ),
        _GuideItem(
          number: '3',
          title: 'Fitur muncul setelah integrasi',
          subtitle: 'Setelah terhubung, fitur PeduliObat, PeduliRiwayat, PeduliPantau, dan notifikasi akan menyesuaikan data lansia.',
          icon: Icons.auto_awesome_rounded,
          tone: PkTone.green,
        ),
      ],
    );
  }
}

class _GuideItem extends StatelessWidget {
  const _GuideItem({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tone,
  });

  final String number;
  final String title;
  final String subtitle;
  final IconData icon;
  final PkTone tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: PkSpacing.md),
      padding: const EdgeInsets.all(PkSpacing.md),
      decoration: BoxDecoration(
        color: pkToneSoft(tone),
        borderRadius: PkRadius.smRadius,
        border: Border.all(color: pkToneColor(tone).withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: pkToneColor(tone),
            foregroundColor: Colors.white,
            child: Text(number, style: const TextStyle(fontWeight: FontWeight.w900)),
          ),
          const SizedBox(width: PkSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 18, color: pkToneColor(tone)),
                    const SizedBox(width: PkSpacing.xs),
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: PkColors.text,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: PkColors.text2,
                        height: 1.5,
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

class _StepIntroCard extends StatelessWidget {
  const _StepIntroCard({
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
      padding: const EdgeInsets.all(PkSpacing.md),
      decoration: BoxDecoration(
        color: pkToneSoft(tone),
        borderRadius: PkRadius.smRadius,
        border: Border.all(color: pkToneColor(tone).withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PkIconBox(icon: icon, tone: tone),
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
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: PkColors.text2,
                        height: 1.5,
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
                    'Arahkan kamera belakang ke QR Code pada Profil PeduliDiri lansia.',
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

class _RegisterErrorBanner extends StatelessWidget {
  const _RegisterErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(PkSpacing.md),
      decoration: BoxDecoration(
        color: PkColors.redSoft,
        borderRadius: PkRadius.smRadius,
        border: Border.all(color: PkColors.red.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: PkColors.red, size: 20),
          const SizedBox(width: PkSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: PkColors.red,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
