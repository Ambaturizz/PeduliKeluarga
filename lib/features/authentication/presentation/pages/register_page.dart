import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_route.dart';
import '../../../../core/theme/pk_design.dart';
import '../../../../shared/layouts/page_shell.dart';
import '../../../../state/providers/app_mode_provider.dart';
import '../../providers/auth_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  AppUserMode? _selectedMode;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _identifierController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);

    return PageShell(
      title: 'Daftar',
      subtitle: 'Buat akun mock untuk memilih peran Lansia atau Anak/Pendamping.',
      icon: Icons.person_add_alt_1_rounded,
      maxWidth: 620,
      children: [
        PkCard(
          soft: true,
          child: Form(
            key: _formKey,
            child: Column(
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
                  'Data ini masih mock/local dan bisa diganti backend nanti.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: PkColors.text2,
                      ),
                ),
                const SizedBox(height: PkSpacing.xl),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nama',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: _validateName,
                ),
                const SizedBox(height: PkSpacing.md),
                TextFormField(
                  controller: _identifierController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email atau nomor HP',
                    hintText: 'contoh@email.com / 081234567890',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: _validateIdentifier,
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
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
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
                      onPressed: () {
                        setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                      },
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  validator: _validateConfirmPassword,
                  onFieldSubmitted: (_) => _submit(auth),
                ),
                const SizedBox(height: PkSpacing.lg),
                _RegisterRoleSelector(
                  selectedMode: _selectedMode,
                  onChanged: (value) {
                    setState(() => _selectedMode = value);
                  },
                ),
                if (auth.errorMessage != null) ...[
                  const SizedBox(height: PkSpacing.md),
                  _RegisterErrorBanner(message: auth.errorMessage!),
                ],
                const SizedBox(height: PkSpacing.xl),
                FilledButton.icon(
                  onPressed: auth.isLoading ? null : () => _submit(auth),
                  icon: auth.isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check_circle_outline_rounded),
                  label: Text(auth.isLoading ? 'Memproses...' : 'Daftar dan masuk'),
                ),
                const SizedBox(height: PkSpacing.md),
                TextButton(
                  onPressed: auth.isLoading ? null : () => context.goNamed(AppRoute.login.name),
                  child: const Text('Sudah punya akun? Masuk'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submit(AuthState auth) async {
    if (auth.isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    final mode = _selectedMode;
    if (mode == null) return;

    final success = await ref.read(authControllerProvider.notifier).register(
          name: _nameController.text,
          identifier: _identifierController.text,
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  String? _validateName(String? value) {
    final clean = value?.trim() ?? '';
    if (clean.isEmpty) return 'Nama wajib diisi.';
    if (clean.length < 2) return 'Nama terlalu pendek.';
    return null;
  }

  String? _validateIdentifier(String? value) {
    final clean = value?.trim() ?? '';
    if (clean.isEmpty) return 'Email atau nomor HP wajib diisi.';
    if (!_isValidEmailOrPhone(clean)) {
      return 'Masukkan email atau nomor HP yang valid.';
    }
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
    if (clean != _passwordController.text) {
      return 'Konfirmasi password harus sama dengan password.';
    }
    return null;
  }

  bool _isValidEmailOrPhone(String value) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    final phone = value.replaceAll(RegExp(r'[\s-]'), '');
    final phoneRegex = RegExp(r'^(?:\+62|62|0)8[0-9]{7,12}$');

    return emailRegex.hasMatch(value) || phoneRegex.hasMatch(phone);
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
              'Pilih peran',
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
                    children: [
                      elder,
                      const SizedBox(height: PkSpacing.md),
                      caregiver,
                    ],
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
              PkIconBox(
                icon: icon,
                tone: tone,
                size: 38,
                iconSize: 20,
              ),
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
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: PkColors.text2,
                          ),
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
