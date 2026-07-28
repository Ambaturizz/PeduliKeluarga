import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/pk_design.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Kebijakan Privasi'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: PkSpacing.xl,
          vertical: PkSpacing.xl,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kebijakan Privasi PeduliKeluarga',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: PkColors.text,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: PkSpacing.md),
                Text(
                  'Terakhir diperbarui: 28 Juli 2026\nBerlaku efektif: 28 Juli 2026',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: PkColors.text2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: PkSpacing.xl),
                Text(
                  'Dokumen ini menjelaskan bagaimana PeduliKeluarga ("Aplikasi", "kami") mengumpulkan, menggunakan, menyimpan, dan melindungi data pribadi kamu ("Pengguna", "kamu") saat menggunakan layanan kami. Dengan menggunakan Aplikasi, kamu memberikan persetujuan atas praktik yang dijelaskan dalam Kebijakan Privasi ini.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: PkColors.text,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: PkSpacing.xl),

                _SectionTitle(title: '1. Data yang Kami Kumpulkan', theme: theme),
                _Subtitle(title: '1.1 Data yang Kamu Berikan Langsung', theme: theme),
                _BulletText(text: 'Nama lengkap, nomor telepon, alamat e-mail', theme: theme),
                _BulletText(text: 'Data anggota keluarga yang didaftarkan (nama, hubungan keluarga, tanggal lahir, riwayat kesehatan dasar)', theme: theme),
                _BulletText(text: 'Foto profil dan dokumen pendukung (mis. KTP/KK, resep, hasil pemeriksaan) apabila diunggah', theme: theme),
                _BulletText(text: 'Riwayat komunikasi dengan tim dukungan/layanan kami', theme: theme),
                const SizedBox(height: PkSpacing.md),
                _Subtitle(title: '1.2 Data yang Dikumpulkan Otomatis Melalui Izin Aplikasi', theme: theme),
                _BulletText(text: 'Lokasi: Memetakan fasilitas/layanan terdekat, melacak status pesanan, dan analitik', theme: theme),
                _BulletText(text: 'Notifikasi: Mengirimkan pembaruan penting, pengingat, dan info layanan', theme: theme),
                _BulletText(text: 'Kamera & Penyimpanan: Mengunggah/mengunduh gambar dan dokumen untuk fitur aplikasi', theme: theme),
                _BulletText(text: 'Mikrofon: Merekam audio secara langsung pada fitur telekonsultasi (jika diaktifkan)', theme: theme),
                const SizedBox(height: PkSpacing.sm),
                Text(
                  'Catatan: Kamu dapat mengatur atau menonaktifkan izin ini kapan saja melalui pengaturan perangkat, namun sebagian fitur mungkin tidak berfungsi optimal.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: PkColors.text2, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: PkSpacing.md),
                _Subtitle(title: '1.3 Data Teknis', theme: theme),
                _BulletText(text: 'Jenis perangkat, sistem operasi, dan versi aplikasi', theme: theme),
                _BulletText(text: 'Alamat IP dan identitas perangkat (device ID)', theme: theme),
                _BulletText(text: 'Log aktivitas dan data analitik penggunaan aplikasi', theme: theme),
                const SizedBox(height: PkSpacing.lg),

                _SectionTitle(title: '2. Tujuan Penggunaan Data', theme: theme),
                Text('Kami menggunakan data yang dikumpulkan untuk:', style: theme.textTheme.bodyMedium?.copyWith(color: PkColors.text, height: 1.6)),
                const SizedBox(height: 8),
                _BulletText(text: 'Menyediakan dan mengoperasikan fitur-fitur Aplikasi (pendataan, telekonsultasi, pengingat obat, dsb)', theme: theme),
                _BulletText(text: 'Memverifikasi identitas dan keamanan akun', theme: theme),
                _BulletText(text: 'Memproses transaksi atau layanan terkait yang diajukan Pengguna', theme: theme),
                _BulletText(text: 'Mengirimkan notifikasi terkait layanan dan informasi promosi', theme: theme),
                _BulletText(text: 'Meningkatkan kualitas layanan melalui analitik penggunaan', theme: theme),
                _BulletText(text: 'Mencegah penipuan dan menjaga keamanan platform', theme: theme),
                _BulletText(text: 'Memenuhi kewajiban hukum yang berlaku', theme: theme),
                const SizedBox(height: PkSpacing.lg),

                _SectionTitle(title: '3. Pembagian Data dengan Pihak Ketiga', theme: theme),
                Text(
                  'Data pribadi yang diperoleh hanya akan dibagikan dengan mitra pihak ketiga untuk kepentingan penyediaan layanan kami (misalnya: penyedia layanan cloud/hosting atau mitra fasilitas kesehatan terintegrasi).\n\n'
                  'Kami tidak menjual data pribadi kamu kepada pihak ketiga untuk kepentingan komersial di luar penyediaan layanan Aplikasi.\n\n'
                  'Kami dapat membagikan data apabila diwajibkan oleh hukum, perintah pengadilan, atau permintaan resmi dari otoritas yang berwenang.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: PkColors.text, height: 1.6),
                ),
                const SizedBox(height: PkSpacing.lg),

                _SectionTitle(title: '4. Penyimpanan dan Keamanan Data', theme: theme),
                _BulletText(text: 'Data disimpan selama akun kamu aktif atau selama diperlukan untuk memenuhi tujuan dalam kebijakan ini', theme: theme),
                _BulletText(text: 'Kami menerapkan langkah-langkah teknis (seperti enkripsi) untuk melindungi data dari akses tidak sah', theme: theme),
                _BulletText(text: 'Kami berupaya sebaik mungkin namun tidak dapat menjamin keamanan transmisi internet secara mutlak', theme: theme),
                const SizedBox(height: PkSpacing.lg),

                _SectionTitle(title: '5. Hak Pengguna', theme: theme),
                Text('Sesuai dengan peraturan yang berlaku, kamu berhak untuk:', style: theme.textTheme.bodyMedium?.copyWith(color: PkColors.text, height: 1.6)),
                const SizedBox(height: 8),
                _BulletText(text: 'Mengakses dan meminta salinan data pribadi', theme: theme),
                _BulletText(text: 'Meminta koreksi atas data yang tidak akurat', theme: theme),
                _BulletText(text: 'Meminta penghapusan data pribadi (sesuai hukum yang berlaku)', theme: theme),
                _BulletText(text: 'Menarik persetujuan atas pemrosesan data tertentu', theme: theme),
                const SizedBox(height: PkSpacing.lg),

                _SectionTitle(title: '6. Data Anak dan Anggota Keluarga', theme: theme),
                Text(
                  'Karena Aplikasi memungkinkan pendaftaran data anggota keluarga, kami mengimbau agar:\n'
                  '• Pendaftaran data anak atau lansia dilakukan oleh orang tua/wali/keluarga yang sah\n'
                  '• Pendaftar bertanggung jawab penuh atas keakuratan dan persetujuan penggunaan data anggota keluarga tersebut',
                  style: theme.textTheme.bodyMedium?.copyWith(color: PkColors.text, height: 1.6),
                ),
                const SizedBox(height: PkSpacing.lg),

                _SectionTitle(title: '7. Perubahan Kebijakan Privasi', theme: theme),
                Text(
                  'Kami dapat memperbarui Kebijakan Privasi ini dari waktu ke waktu. Perubahan material akan diinformasikan melalui Aplikasi atau kanal resmi lainnya sebelum berlaku efektif.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: PkColors.text, height: 1.6),
                ),
                const SizedBox(height: PkSpacing.lg),

                _SectionTitle(title: '8. Hubungi Kami', theme: theme),
                Text(
                  'Jika kamu memiliki pertanyaan, keluhan, atau permintaan terkait data pribadi, silakan hubungi:\n'
                  '• Nama Entitas: Tim Pengembang PeduliKeluarga\n'
                  '• E-mail: privacy@pedulikeluarga.com',
                  style: theme.textTheme.bodyMedium?.copyWith(color: PkColors.text, height: 1.6),
                ),
                const SizedBox(height: PkSpacing.xxl * 2),
                Center(
                  child: FilledButton(
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/');
                      }
                    },
                    child: const Text('Kembali'),
                  ),
                ),
                const SizedBox(height: PkSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.theme});
  final String title;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: PkSpacing.sm),
      child: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w900,
          color: PkColors.text,
          letterSpacing: -0.5,
        ),
      ),
    );
  }
}

class _Subtitle extends StatelessWidget {
  const _Subtitle({required this.title, required this.theme});
  final String title;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: PkSpacing.xs),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: PkColors.text,
        ),
      ),
    );
  }
}

class _BulletText extends StatelessWidget {
  const _BulletText({required this.text, required this.theme});
  final String text;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: PkSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•  ',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: PkColors.text,
              fontWeight: FontWeight.w900,
              height: 1.6,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: PkColors.text,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
