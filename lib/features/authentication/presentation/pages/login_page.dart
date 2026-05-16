import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_route.dart';
import '../../../../core/theme/pk_design.dart';
import '../../../../shared/layouts/page_shell.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../../../state/providers/app_mode_provider.dart';
import '../../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  AppUserMode _selectedMode = AppUserMode.elder;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);

    return PageShell(
      title: 'Masuk',
      subtitle: 'Masuk untuk mengelola data PeduliDiri dan PeduliPenuh.',
      icon: Icons.lock_outline_rounded,
      maxWidth: 560,
      children: [
        PkCard(
          soft: true,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: AppLogo(size: 200, withBackground: false),
                ),
                const SizedBox(height: PkSpacing.lg),
                Text(
                  'Selamat datang kembali',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: PkColors.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: PkSpacing.xs),
                Text(
                  'Gunakan email atau nomor HP yang kamu daftarkan.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: PkColors.text2,
                      ),
                ),
                const SizedBox(height: PkSpacing.xl),
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
                  textInputAction: TextInputAction.done,
                  validator: _validatePassword,
                  onFieldSubmitted: (_) => _submit(auth),
                ),
                const SizedBox(height: PkSpacing.lg),
                _RoleSelector(
                  title: 'Masuk sebagai',
                  selectedMode: _selectedMode,
                  onChanged: (value) {
                    setState(() => _selectedMode = value);
                  },
                ),
                if (auth.errorMessage != null) ...[
                  const SizedBox(height: PkSpacing.md),
                  _AuthErrorBanner(message: auth.errorMessage!),
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
                      : const Icon(Icons.login_rounded),
                  label: Text(auth.isLoading ? 'Memproses...' : 'Masuk'),
                ),
                const SizedBox(height: PkSpacing.md),
                OutlinedButton.icon(
                  onPressed: auth.isLoading
                      ? null
                      : () => context.goNamed(AppRoute.register.name),
                  icon: const Icon(Icons.person_add_alt_1_rounded),
                  label: const Text('Daftar akun baru'),
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

    final success = await ref.read(authControllerProvider.notifier).login(
          identifier: _identifierController.text,
          password: _passwordController.text,
          mode: _selectedMode,
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

  bool _isValidEmailOrPhone(String value) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    final phone = value.replaceAll(RegExp(r'[\s-]'), '');
    final phoneRegex = RegExp(r'^(?:\+62|62|0)8[0-9]{7,12}$');

    return emailRegex.hasMatch(value) || phoneRegex.hasMatch(phone);
  }
}

class _RoleSelector extends StatelessWidget {
  const _RoleSelector({
    required this.title,
    required this.selectedMode,
    required this.onChanged,
  });

  final String title;
  final AppUserMode selectedMode;
  final ValueChanged<AppUserMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return FormField<AppUserMode>(
      initialValue: selectedMode,
      validator: (value) => value == null ? 'Peran wajib dipilih.' : null,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: PkColors.text,
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: PkSpacing.sm),
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 420;

                final elder = _RoleOption(
                  label: 'Lansia',
                  subtitle: 'PeduliDiri',
                  icon: Icons.elderly_rounded,
                  selected: selectedMode == AppUserMode.elder,
                  onTap: () {
                    field.didChange(AppUserMode.elder);
                    onChanged(AppUserMode.elder);
                  },
                );

                final caregiver = _RoleOption(
                  label: 'Anak / Pendamping',
                  subtitle: 'PeduliPenuh',
                  icon: Icons.groups_rounded,
                  selected: selectedMode == AppUserMode.caregiver,
                  onTap: () {
                    field.didChange(AppUserMode.caregiver);
                    onChanged(AppUserMode.caregiver);
                  },
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

class _RoleOption extends StatelessWidget {
  const _RoleOption({
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
                      maxLines: 1,
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

class _AuthErrorBanner extends StatelessWidget {
  const _AuthErrorBanner({required this.message});

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