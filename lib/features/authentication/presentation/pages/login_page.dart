import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_route.dart';
import '../../../../core/theme/pk_design.dart';
import '../../../../shared/layouts/page_shell.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);

    return PageShell(
      title: 'Masuk',
      subtitle: 'Halaman ini masih mockup. Login belum menghubungkan akun sungguhan.',
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
                const Center(child: AppLogo(size: 300, withBackground: false)),
                const SizedBox(height: PkSpacing.lg),
                Text(
                  'Login mockup',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: PkColors.text,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: PkSpacing.xs),
                Text(
                  'Form ini sengaja belum bisa masuk. Untuk mencoba alur aplikasi, gunakan daftar akun baru dengan email.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: PkColors.text2,
                        height: 1.5,
                      ),
                ),
                const SizedBox(height: PkSpacing.lg),
                const _MockInfoBanner(),
                const SizedBox(height: PkSpacing.xl),
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
                  label: Text(auth.isLoading ? 'Memproses...' : 'Coba Login Mockup'),
                ),
                const SizedBox(height: PkSpacing.md),
                OutlinedButton.icon(
                  onPressed: auth.isLoading ? null : () => context.goNamed(AppRoute.register.name),
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

    await ref.read(authControllerProvider.notifier).login(
          email: _emailController.text,
          password: _passwordController.text,
        );

    if (!mounted) return;
    final message = ref.read(authControllerProvider).errorMessage;
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
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
}

class _MockInfoBanner extends StatelessWidget {
  const _MockInfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(PkSpacing.md),
      decoration: BoxDecoration(
        color: PkColors.amberSoft,
        borderRadius: PkRadius.smRadius,
        border: Border.all(color: PkColors.amber.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: PkColors.amber, size: 20),
          const SizedBox(width: PkSpacing.sm),
          Expanded(
            child: Text(
              'Login belum aktif. Aplikasi akan membuka halaman Daftar sebagai default agar alur mockup bisa langsung dicoba.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: PkColors.amber,
                    fontWeight: FontWeight.w800,
                    height: 1.45,
                  ),
            ),
          ),
        ],
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
