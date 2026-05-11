import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../state/providers/app_mode_provider.dart';
import '../../providers/onboarding_provider.dart';
import '../widgets/onboarding_steps.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  static const int _splashIndex = 0;
  static const int _welcomeIndex = 1;
  static const int _roleIndex = 2;
  static const int _profileIndex = 3;
  static const int _healthIndex = 4;
  static const int _connectFamilyIndex = 5;
  static const int _finalIndex = 6;

  late final PageController _pageController;
  Timer? _splashTimer;

  int _currentPage = _splashIndex;


  bool get _isSplash => _currentPage == _splashIndex;

  bool get _isWelcome => _currentPage == _welcomeIndex;

  bool get _isFinal => _currentPage == _finalIndex;

  bool get _showHeader => !_isSplash && !_isWelcome;

  bool get _canGoBack => _currentPage > _welcomeIndex;

  double get _progressValue {
    if (_currentPage <= _welcomeIndex) return 0;
    return (_currentPage - 1) / (_finalIndex - 1);
  }

  String get _primaryLabel {
    return switch (_currentPage) {
      _welcomeIndex => 'Mulai Sekarang',
      _roleIndex => 'Pilih & Lanjut',
      _profileIndex => 'Simpan Profil',
      _healthIndex => 'Lanjut',
      _connectFamilyIndex => 'Lanjut',
      _finalIndex => 'Masuk ke Beranda',
      _ => 'Lanjut',
    };
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _splashTimer = Timer(const Duration(milliseconds: 1250), () {
      if (!mounted || _currentPage != _splashIndex) return;
      _goToPage(_welcomeIndex);
    });
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _goToPage(int page) async {
    await _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
    );
  }

  void _goNext() {
    final canContinue = ref
        .read(onboardingProvider.notifier)
        .canContinueFromPage(_currentPage);

    if (!canContinue) {
      _showValidationMessage();
      return;
    }

    if (_isFinal) {
      _finishOnboarding();
      return;
    }

    _goToPage((_currentPage + 1).clamp(0, _finalIndex));
  }

  void _goBack() {
    if (!_canGoBack) return;
    _goToPage((_currentPage - 1).clamp(_welcomeIndex, _finalIndex));
  }

  void _skipConnectFamily() {
    if (_currentPage != _connectFamilyIndex) return;
    _goToPage(_finalIndex);
  }

  void _finishOnboarding() {
    final state = ref.read(onboardingProvider);

    ref.read(onboardingProvider.notifier).finish();

    if (state.role != null) {
      ref.read(appModeControllerProvider.notifier).setMode(state.role!);
    }

    context.go(AppRoutes.homePath);
  }

  void _showValidationMessage() {
    final message = switch (_currentPage) {
      _roleIndex => 'Pilih peran terlebih dahulu.',
      _profileIndex => 'Nama wajib diisi agar profil bisa dibuat.',
      _ => 'Lengkapi data yang diperlukan terlebih dahulu.',
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingProvider);
    final canContinue = ref
        .read(onboardingProvider.notifier)
        .canContinueFromPage(_currentPage);

    return Scaffold(
      backgroundColor: AppColors.grayBg,
      body: SafeArea(
        child: Column(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: _showHeader
                  ? _OnboardingHeader(
                      key: const ValueKey('header'),
                      progressValue: _progressValue,
                      currentStep: _currentPage - 1,
                      totalSteps: _finalIndex - 1,
                      onBack: _canGoBack ? _goBack : null,
                    )
                  : const SizedBox(
                      key: ValueKey('spacer'),
                      height: AppSpacing.md,
                    ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: const [
                  SplashOnboardingScreen(),
                  WelcomeOnboardingScreen(),
                  ChooseRoleOnboardingScreen(),
                  SetupProfileOnboardingScreen(),
                  HealthConditionOnboardingScreen(),
                  ConnectFamilyOnboardingScreen(),
                  FinalConfirmationOnboardingScreen(),
                ],
              ),
            ),
            if (!_isSplash)
              _OnboardingBottomBar(
                primaryLabel: _primaryLabel,
                canContinue: canContinue,
                showSkip: _currentPage == _connectFamilyIndex,
                showBack: _canGoBack && !_isFinal,
                modeLabel: onboardingState.roleTitle,
                onPrimaryPressed: _goNext,
                onSkipPressed: _skipConnectFamily,
                onBackPressed: _goBack,
              ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingHeader extends StatelessWidget {
  const _OnboardingHeader({
    required this.progressValue,
    required this.currentStep,
    required this.totalSteps,
    required this.onBack,
    super.key,
  });

  final double progressValue;
  final int currentStep;
  final int totalSteps;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final stepLabel = 'Langkah $currentStep dari $totalSteps';

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Kembali',
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.textPrimary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Semantics(
              label: 'Progress onboarding',
              value: '${(progressValue * 100).round()} persen',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stepLabel,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: progressValue,
                      minHeight: 8,
                      color: AppColors.teal,
                      backgroundColor: AppColors.grayBorder,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _OnboardingBottomBar extends StatelessWidget {
  const _OnboardingBottomBar({
    required this.primaryLabel,
    required this.canContinue,
    required this.showSkip,
    required this.showBack,
    required this.modeLabel,
    required this.onPrimaryPressed,
    required this.onSkipPressed,
    required this.onBackPressed,
  });

  final String primaryLabel;
  final bool canContinue;
  final bool showSkip;
  final bool showBack;
  final String modeLabel;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onSkipPressed;
  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xxl,
        AppSpacing.md,
        AppSpacing.xxl,
        AppSpacing.xxl,
      ),
      decoration: BoxDecoration(
        color: AppColors.grayBg.withValues(alpha: 0.96),
        border: const Border(
          top: BorderSide(color: AppColors.grayBorder),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (modeLabel != 'Belum dipilih') ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Mode: $modeLabel',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            Row(
              children: [
                if (showBack) ...[
                  SizedBox(
                    height: 54,
                    child: OutlinedButton(
                      onPressed: onBackPressed,
                      child: const Text('Kembali'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                ],
                Expanded(
                  child: SizedBox(
                    height: 54,
                    child: FilledButton.icon(
                      onPressed: canContinue ? onPrimaryPressed : null,
                      icon: Icon(
                        primaryLabel == 'Masuk ke Beranda'
                            ? Icons.home_rounded
                            : Icons.arrow_forward_rounded,
                      ),
                      label: Text(primaryLabel),
                    ),
                  ),
                ),
              ],
            ),
            if (showSkip) ...[
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: onSkipPressed,
                  child: const Text('Lewati untuk saat ini'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}