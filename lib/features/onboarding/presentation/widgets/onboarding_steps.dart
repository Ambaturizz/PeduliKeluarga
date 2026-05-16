import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../state/providers/app_mode_provider.dart';
import '../../../elder_profile/providers/elder_profile_provider.dart';
import '../../providers/onboarding_provider.dart';
import 'onboarding_widgets.dart';

class SplashOnboardingScreen extends StatelessWidget {
  const SplashOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.grayBg,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const OnboardingGlassLogo(),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'PeduliKeluarga',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppColors.tealDark,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Rawat keluarga dengan lebih tenang',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: AppSpacing.huge),
              const SizedBox(
                width: 34,
                height: 34,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppColors.teal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomeOnboardingScreen extends StatelessWidget {
  const WelcomeOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingStepLayout(
      centerContent: true,
      icon: Icons.volunteer_activism_rounded,
      eyebrow: 'PEDULIKELUARGA',
      title: 'Selamat datang di PeduliKeluarga',
      subtitle:
          'Pantau kesehatan harian, jadwal obat, dan kondisi keluarga dengan alur yang sederhana dan aman.',
      children: const [
        OnboardingHealthcareHero(),
        SizedBox(height: AppSpacing.lg),
        OnboardingInfoCard(
          title: 'Mudah untuk Lansia',
          subtitle: 'Tombol besar, bahasa jelas, dan fokus ke aksi penting.',
          icon: Icons.elderly_rounded,
          color: AppColors.teal,
        ),
        SizedBox(height: AppSpacing.sm),
        OnboardingInfoCard(
          title: 'Tenang untuk Anak',
          subtitle:
              'Dapatkan ringkasan kondisi, reminder obat, dan PeduliDarurat.',
          icon: Icons.family_restroom_rounded,
          color: AppColors.blue,
        ),
      ],
    );
  }
}

class ChooseRoleOnboardingScreen extends ConsumerWidget {
  const ChooseRoleOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return OnboardingStepLayout(
      eyebrow: 'LANGKAH 1 DARI 5',
      title: 'Pilih peran Anda',
      subtitle:
          'Kami akan menyesuaikan menu, bahasa, ukuran tombol, dan prioritas informasi berdasarkan peran ini.',
      footer: const OnboardingInfoCard(
        title: 'Bisa diubah nanti',
        subtitle:
            'Peran ini hanya mengatur pengalaman awal. Anda tetap bisa mengubahnya di pengaturan.',
        icon: Icons.info_outline_rounded,
        color: AppColors.amber,
      ),
      children: [
        OnboardingChoiceCard(
          badge: 'PeduliDiri',
          title: 'Saya Lansia',
          subtitle:
              'Untuk memantau kesehatan diri sendiri, minum obat tepat waktu, dan memberi akses pantauan ke keluarga.',
          icon: Icons.elderly_rounded,
          color: AppColors.teal,
          selected: state.role == AppUserMode.elder,
          onTap: () => notifier.setRole(AppUserMode.elder),
        ),
        const SizedBox(height: AppSpacing.md),
        OnboardingChoiceCard(
          badge: 'PeduliPenuh',
          title: 'Saya Anak / Pendamping',
          subtitle:
              'Untuk memantau orang tua dari jauh, melihat riwayat, mengatur obat, dan menerima PeduliDarurat.',
          icon: Icons.supervisor_account_rounded,
          color: AppColors.blue,
          selected: state.role == AppUserMode.caregiver,
          onTap: () => notifier.setRole(AppUserMode.caregiver),
        ),
      ],
    );
  }
}

class SetupProfileOnboardingScreen extends ConsumerWidget {
  const SetupProfileOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);
    final isElder = state.isElder;

    return OnboardingStepLayout(
      eyebrow: 'LANGKAH 2 DARI 5',
      title: isElder ? 'Lengkapi profil Anda' : 'Profil pendamping',
      subtitle: isElder
          ? 'Data ini membantu keluarga dan AhliPeduli mengenali Anda saat ada kebutuhan kesehatan.'
          : 'Data ini membantu kami mengenali Anda sebagai pendamping keluarga.',
      footer: const OnboardingInfoCard(
        title: 'Privasi diutamakan',
        subtitle:
            'Untuk prototype ini data tersimpan sementara secara lokal di state onboarding.',
        icon: Icons.lock_outline_rounded,
        color: AppColors.purple,
      ),
      children: [
        OnboardingTextField(
          label: isElder ? 'Nama lengkap / panggilan' : 'Nama Anda',
          initialValue: state.fullName,
          hintText: isElder ? 'Contoh: Bapak Purwanto' : 'Contoh: Reza',
          prefixIcon: Icons.person_outline_rounded,
          textInputAction: TextInputAction.next,
          onChanged: notifier.setFullName,
        ),
        if (isElder) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            'Jenis kelamin',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              OnboardingChipOption(
                label: 'Laki-laki',
                selected: state.gender == 'Laki-laki',
                selectedColor: AppColors.teal,
                onTap: () => notifier.setGender('Laki-laki'),
              ),
              OnboardingChipOption(
                label: 'Perempuan',
                selected: state.gender == 'Perempuan',
                selectedColor: AppColors.teal,
                onTap: () => notifier.setGender('Perempuan'),
              ),
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: OnboardingTextField(
                label: isElder ? 'Usia' : 'Nomor HP',
                initialValue: isElder ? state.age : state.phoneNumber,
                hintText: isElder ? '68' : '0812...',
                prefixIcon:
                    isElder ? Icons.cake_outlined : Icons.phone_outlined,
                keyboardType:
                    isElder ? TextInputType.number : TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                ],
                textInputAction: TextInputAction.next,
                onChanged:
                    isElder ? notifier.setAge : notifier.setPhoneNumber,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: OnboardingTextField(
                label: isElder ? 'Nomor HP' : 'Hubungan',
                initialValue: isElder ? state.phoneNumber : state.relationship,
                hintText: isElder ? '0812...' : 'Anak',
                prefixIcon: isElder
                    ? Icons.phone_outlined
                    : Icons.favorite_border_rounded,
                keyboardType:
                    isElder ? TextInputType.phone : TextInputType.text,
                inputFormatters: isElder
                    ? [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                      ]
                    : null,
                textInputAction: TextInputAction.next,
                onChanged: isElder
                    ? notifier.setPhoneNumber
                    : notifier.setRelationship,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (isElder)
          OnboardingTextField(
            label: 'Alamat rumah',
            initialValue: state.address,
            hintText: 'Contoh: Jl. Melati No. 10',
            helperText: 'Opsional, berguna untuk PeduliDarurat dan PeduliAntar.',
            prefixIcon: Icons.home_outlined,
            maxLines: 2,
            textInputAction: TextInputAction.done,
            onChanged: notifier.setAddress,
          )
        else
          OnboardingTextField(
            label: 'Nama orang tua / lansia',
            initialValue: state.elderName,
            hintText: 'Contoh: Bapak Purwanto',
            helperText: 'Opsional, bisa dilengkapi setelah terhubung.',
            prefixIcon: Icons.elderly_rounded,
            textInputAction: TextInputAction.done,
            onChanged: notifier.setElderName,
          ),
      ],
    );
  }
}

class HealthConditionOnboardingScreen extends ConsumerWidget {
  const HealthConditionOnboardingScreen({super.key});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);
    final target = state.isCaregiver ? 'orang tua' : 'Anda';

    return OnboardingStepLayout(
      eyebrow: 'LANGKAH 3 DARI 5',
      title: 'Kondisi kesehatan $target',
      subtitle:
          'Pilih kondisi yang relevan agar PeduliCek, PeduliObat, dan PeduliDarurat bisa terasa lebih personal.',
      footer: const OnboardingInfoCard(
        title: 'Bisa dilewati',
        subtitle:
            'Kondisi kesehatan dapat ditambah kapan saja dari halaman profil atau PeduliRiwayat.',
        icon: Icons.health_and_safety_outlined,
        color: AppColors.green,
      ),
      children: [
        Text(
          'Kondisi utama',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final condition in _conditions)
              OnboardingChipOption(
                label: condition,
                selected: state.healthConditions.contains(condition),
                selectedColor: condition.contains('Jantung') ||
                        condition.contains('Stroke') ||
                        condition.contains('Ginjal')
                    ? AppColors.redMid
                    : AppColors.teal,
                onTap: () => notifier.toggleCondition(condition),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Kebutuhan mobilitas',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final need in _mobilityNeeds)
              OnboardingChipOption(
                label: need,
                selected: state.mobilityNeeds.contains(need),
                selectedColor: AppColors.amberMid,
                onTap: () => notifier.toggleMobilityNeed(need),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        OnboardingTextField(
          label: 'Alergi / catatan khusus',
          initialValue: state.allergies,
          hintText: 'Contoh: alergi seafood, tidak kuat obat tertentu',
          helperText: 'Opsional.',
          prefixIcon: Icons.note_alt_outlined,
          maxLines: 3,
          textInputAction: TextInputAction.done,
          onChanged: notifier.setAllergies,
        ),
      ],
    );
  }
}

class _RegistrationQrPreview extends StatelessWidget {
  const _RegistrationQrPreview({required this.payload});

  final String payload;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'QR keluarga untuk menghubungkan anak atau pendamping.',
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.teal100),
          boxShadow: [
            BoxShadow(
              color: AppColors.teal.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: QrImageView(
          data: payload,
          version: QrVersions.auto,
          size: 168,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}

class ConnectFamilyOnboardingScreen extends ConsumerWidget {
  const ConnectFamilyOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);
    final elderProfile = ref.watch(elderProfileProvider);

    if (state.isElder) {
      return OnboardingStepLayout(
        eyebrow: 'LANGKAH 4 DARI 5',
        title: 'Hubungkan keluarga',
        subtitle:
            'Bagikan kode ini ke anak atau pendamping agar mereka bisa memantau ringkasan kesehatan dan menerima PeduliDarurat.',
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.xxl),
            decoration: BoxDecoration(
              color: AppColors.grayCard,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.teal100),
              boxShadow: [
                BoxShadow(
                  color: AppColors.teal.withValues(alpha: 0.08),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Column(
              children: [
                _RegistrationQrPreview(payload: elderProfile.qrPayload),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Kode Keluarga Anda',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SelectableText(
                  elderProfile.connectionCode,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppColors.teal,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                ),
                const SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: elderProfile.connectionCode),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Kode keluarga disalin.'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy_rounded),
                    label: const Text('Salin Kode'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const OnboardingInfoCard(
            title: 'Akses keluarga aman',
            subtitle:
                'Keluarga hanya melihat ringkasan yang diperlukan untuk membantu perawatan.',
            icon: Icons.verified_user_outlined,
            color: AppColors.blue,
          ),
        ],
      );
    }

    return OnboardingStepLayout(
      eyebrow: 'LANGKAH 4 DARI 5',
      title: 'Hubungkan ke orang tua',
      subtitle:
          'Masukkan kode dari aplikasi PeduliKeluarga milik orang tua. Anda juga bisa melewati langkah ini dulu.',
      children: [
        OnboardingTextField(
          label: 'Kode keluarga',
          initialValue: state.familyCode,
          hintText: 'Contoh: PK-882-991',
          helperText: 'Gunakan kode yang dibagikan oleh orang tua/lansia.',
          prefixIcon: Icons.qr_code_rounded,
          textInputAction: TextInputAction.done,
          onChanged: notifier.setFamilyCode,
        ),
        const SizedBox(height: AppSpacing.md),
        OnboardingInfoCard(
          title: 'Scan QR',
          subtitle:
              'Fitur kamera akan diaktifkan saat integrasi perangkat siap.',
          icon: Icons.qr_code_scanner_rounded,
          color: AppColors.teal,
          trailing: const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textMuted,
          ),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Scanner QR akan diaktifkan saat integrasi perangkat siap.'),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        const OnboardingInfoCard(
          title: 'Belum punya kode?',
          subtitle:
              'Minta orang tua membuka menu Hubungkan Keluarga di aplikasi mereka.',
          icon: Icons.help_outline_rounded,
          color: AppColors.amber,
        ),
      ],
    );
  }
}

class FinalConfirmationOnboardingScreen extends ConsumerWidget {
  const FinalConfirmationOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    final conditionText = state.healthConditions.isEmpty
        ? 'Belum ada kondisi dipilih'
        : state.healthConditions.join(', ');

    final mobilityText = state.mobilityNeeds.isEmpty
        ? 'Tidak ada kebutuhan khusus'
        : state.mobilityNeeds.join(', ');

    return OnboardingStepLayout(
      centerContent: true,
      icon: Icons.check_circle_rounded,
      eyebrow: 'LANGKAH 5 DARI 5',
      title: 'Semua siap, ${state.displayName}!',
      subtitle:
          'Periksa ringkasan awal dan aktifkan fitur yang ingin digunakan sejak hari pertama.',
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.grayCard,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.grayBorder),
          ),
          child: Column(
            children: [
              OnboardingSummaryRow(
                label: 'Mode',
                value: '${state.roleSubtitle} — ${state.roleTitle}',
                icon: Icons.account_circle_outlined,
              ),
              OnboardingSummaryRow(
                label: 'Nama',
                value: state.displayName,
                icon: Icons.person_outline_rounded,
              ),
              if (state.isElder)
                OnboardingSummaryRow(
                  label: 'Jenis kelamin',
                  value: state.genderLabel,
                  icon: Icons.wc_rounded,
                ),
              OnboardingSummaryRow(
                label: 'Kondisi kesehatan',
                value: conditionText,
                icon: Icons.medical_information_outlined,
              ),
              OnboardingSummaryRow(
                label: 'Mobilitas',
                value: mobilityText,
                icon: Icons.accessible_forward_rounded,
              ),
              OnboardingSummaryRow(
                label: 'Keluarga',
                value:
                    state.isElder ? ref.watch(elderProfileProvider).connectionCode : state.connectedFamilyLabel,
                icon: Icons.family_restroom_rounded,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        OnboardingSwitchTile(
          title: 'PeduliObat',
          subtitle: 'Aktifkan pengingat jadwal dan stok obat.',
          icon: Icons.medication_outlined,
          value: state.enableMedicationReminder,
          onChanged: notifier.setMedicationReminder,
        ),
        OnboardingSwitchTile(
          title: 'PeduliDarurat',
          subtitle: 'Aktifkan tombol darurat dan notifikasi keluarga.',
          icon: Icons.emergency_outlined,
          value: state.enableFamilyAlert,
          onChanged: notifier.setFamilyAlert,
        ),
        OnboardingSwitchTile(
          title: 'PeduliRiwayat',
          subtitle: 'Simpan ringkasan kesehatan untuk tren bulanan.',
          icon: Icons.assignment_outlined,
          value: state.enableHealthSummary,
          onChanged: notifier.setHealthSummary,
        ),
      ],
    );
  }
}