import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/pk_design.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Syarat dan Ketentuan'),
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
                  'Syarat dan Ketentuan PeduliKeluarga',
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
                  'Selamat datang di PeduliKeluarga. Syarat dan Ketentuan ini ("S&K") mengatur penggunaan aplikasi PeduliKeluarga ("Aplikasi", "kami") oleh Anda ("Pengguna"). Dengan mengakses, masuk, atau mendaftar pada Aplikasi, Anda menyatakan telah membaca, memahami, dan menyetujui untuk terikat pada S&K ini.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: PkColors.text,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: PkSpacing.xl),
                _SectionTitle(title: '1. Definisi', theme: theme),
                _BulletText(text: 'Aplikasi merujuk pada platform PeduliKeluarga, termasuk situs web dan aplikasi seluler', theme: theme),
                _BulletText(text: 'Pengguna adalah setiap individu yang mendaftar, masuk, atau menggunakan layanan Aplikasi', theme: theme),
                _BulletText(text: 'Layanan adalah seluruh fitur yang disediakan Aplikasi, termasuk namun tidak terbatas pada pendataan keluarga, telekonsultasi kesehatan, pantauan aktivitas, notifikasi, dan pengelolaan jadwal minum obat.', theme: theme),
                _BulletText(text: 'Konten adalah seluruh data, teks, gambar, dokumen, atau informasi lain yang diunggah atau dihasilkan melalui Aplikasi', theme: theme),
                const SizedBox(height: PkSpacing.lg),

                _SectionTitle(title: '2. Kelayakan Pengguna', theme: theme),
                _BulletText(text: 'Pengguna harus berusia minimal 17 tahun atau merupakan orang tua/wali yang mendaftarkan anggota keluarga di bawah umur atas nama dan tanggung jawabnya sendiri', theme: theme),
                _BulletText(text: 'Pengguna wajib memberikan data pendaftaran yang benar, akurat, dan terkini', theme: theme),
                _BulletText(text: 'Aplikasi berhak menolak atau menangguhkan pendaftaran apabila ditemukan data yang tidak valid', theme: theme),
                const SizedBox(height: PkSpacing.lg),

                _SectionTitle(title: '3. Akun Pengguna', theme: theme),
                _BulletText(text: 'Pengguna bertanggung jawab menjaga kerahasiaan kredensial akun (kata sandi, OTP, dll)', theme: theme),
                _BulletText(text: 'Segala aktivitas yang dilakukan melalui akun Pengguna menjadi tanggung jawab Pengguna, kecuali dapat dibuktikan terjadi penyalahgunaan di luar kendali Pengguna', theme: theme),
                _BulletText(text: 'Pengguna wajib segera memberitahukan kami apabila mendapati indikasi penggunaan akun tanpa izin', theme: theme),
                const SizedBox(height: PkSpacing.lg),

                _SectionTitle(title: '4. Ruang Lingkup Layanan', theme: theme),
                Text(
                  'Aplikasi menyediakan layanan sebagai berikut:\n'
                  '1. Pendataan dan pengelolaan data kesehatan serta aktivitas anggota keluarga\n'
                  '2. Fitur telekonsultasi kesehatan (AhliPeduli)\n'
                  '3. Fitur pengingat dan riwayat minum obat (PeduliObat)\n'
                  '4. Fitur pemantauan dan kedaruratan (PeduliPantau, Family Alert)\n'
                  '5. Fitur chat internal keluarga (FamilyChat)\n'
                  '6. Fitur logistik dan dukungan (PeduliAntar)\n\n'
                  'Kami berhak menambah, mengubah, atau menghentikan sebagian maupun seluruh fitur Layanan sewaktu-waktu dengan atau tanpa pemberitahuan sebelumnya, sepanjang diperlukan untuk pengembangan atau pemeliharaan Aplikasi.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: PkColors.text, height: 1.6),
                ),
                const SizedBox(height: PkSpacing.lg),

                _SectionTitle(title: '5. Kewajiban dan Larangan Pengguna', theme: theme),
                Text('Pengguna setuju untuk tidak:', style: theme.textTheme.bodyMedium?.copyWith(color: PkColors.text, height: 1.6)),
                const SizedBox(height: 8),
                _BulletText(text: 'Menggunakan Aplikasi untuk tujuan melanggar hukum atau merugikan pihak lain', theme: theme),
                _BulletText(text: 'Mengunggah Konten yang mengandung unsur SARA, kekerasan, pornografi, ujaran kebencian, atau pelanggaran hukum lainnya', theme: theme),
                _BulletText(text: 'Memalsukan identitas atau data anggota keluarga yang didaftarkan', theme: theme),
                _BulletText(text: 'Melakukan tindakan yang dapat mengganggu keamanan atau kestabilan sistem Aplikasi (mis. peretasan, penyebaran malware)', theme: theme),
                _BulletText(text: 'Menyalahgunakan data pribadi milik pengguna lain yang diperoleh melalui Aplikasi', theme: theme),
                const SizedBox(height: PkSpacing.lg),

                _SectionTitle(title: '6. Data Pribadi dan Privasi', theme: theme),
                Text(
                  'Pengumpulan, penggunaan, dan pembagian data pribadi Pengguna diatur secara khusus dalam Kebijakan Privasi PeduliKeluarga, yang merupakan bagian tidak terpisahkan dari S&K ini.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: PkColors.text, height: 1.6),
                ),
                const SizedBox(height: PkSpacing.lg),

                _SectionTitle(title: '7. Konten Pengguna', theme: theme),
                _BulletText(text: 'Pengguna tetap memegang hak atas Konten yang diunggah, namun memberikan izin kepada kami untuk menyimpan, memproses, dan menampilkan Konten tersebut sepanjang diperlukan untuk penyediaan Layanan', theme: theme),
                _BulletText(text: 'Kami berhak menghapus Konten yang melanggar S&K ini tanpa pemberitahuan sebelumnya', theme: theme),
                const SizedBox(height: PkSpacing.lg),

                _SectionTitle(title: '8. Kekayaan Intelektual', theme: theme),
                _BulletText(text: 'Seluruh hak kekayaan intelektual atas Aplikasi (termasuk namun tidak terbatas pada logo, desain antarmuka, kode program, dan merek "PeduliKeluarga") adalah milik Ambaturizz / tim pengembang PeduliKeluarga atau pemberi lisensinya', theme: theme),
                _BulletText(text: 'Pengguna dilarang menyalin, memodifikasi, mendistribusikan, atau membuat karya turunan dari Aplikasi tanpa izin tertulis', theme: theme),
                const SizedBox(height: PkSpacing.lg),

                _SectionTitle(title: '9. Batasan Tanggung Jawab', theme: theme),
                _BulletText(text: 'Aplikasi disediakan atas dasar "sebagaimana adanya" (as is) dan "sebagaimana tersedia" (as available)', theme: theme),
                _BulletText(text: 'Kami tidak menjamin Layanan akan bebas dari gangguan, kesalahan, atau selalu tersedia tanpa henti', theme: theme),
                _BulletText(text: 'Penting: PeduliKeluarga menyediakan informasi, notifikasi, dan rujukan kesehatan/sosial, namun bukan merupakan pengganti diagnosis, perawatan, atau layanan medis profesional resmi. Selalu konsultasikan dengan dokter atau tenaga medis yang berkualifikasi untuk setiap masalah kesehatan.', theme: theme),
                _BulletText(text: 'Sepanjang diizinkan oleh hukum yang berlaku, kami tidak bertanggung jawab atas kerugian tidak langsung, insidental, atau konsekuensial yang timbul dari penggunaan Aplikasi', theme: theme),
                const SizedBox(height: PkSpacing.lg),

                _SectionTitle(title: '10. Penangguhan dan Penghentian Akun', theme: theme),
                Text(
                  'Kami berhak menangguhkan atau menghentikan akses Pengguna terhadap Aplikasi apabila:\n'
                  '• Pengguna terbukti melanggar S&K ini\n'
                  '• Terdapat indikasi penyalahgunaan, penipuan, atau aktivitas mencurigakan lainnya\n'
                  '• Diwajibkan oleh ketentuan hukum yang berlaku\n\n'
                  'Pengguna juga dapat mengajukan penghapusan akun sewaktu-waktu melalui pengaturan profil atau menghubungi tim dukungan.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: PkColors.text, height: 1.6),
                ),
                const SizedBox(height: PkSpacing.lg),

                _SectionTitle(title: '11. Perubahan Syarat dan Ketentuan', theme: theme),
                Text(
                  'Kami dapat mengubah S&K ini dari waktu ke waktu. Perubahan akan diinformasikan melalui Aplikasi, dan perubahan tersebut berlaku efektif sejak tanggal yang tercantum pada versi terbaru. Penggunaan Aplikasi setelah perubahan berlaku dianggap sebagai persetujuan atas S&K yang telah diperbarui.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: PkColors.text, height: 1.6),
                ),
                const SizedBox(height: PkSpacing.lg),

                _SectionTitle(title: '12. Hukum yang Berlaku dan Penyelesaian Sengketa', theme: theme),
                _BulletText(text: 'S&K ini diatur dan ditafsirkan berdasarkan hukum Negara Republik Indonesia', theme: theme),
                _BulletText(text: 'Segala perselisihan yang timbul akan diselesaikan terlebih dahulu secara musyawarah; apabila tidak tercapai kesepakatan, akan diselesaikan melalui pengadilan negeri setempat yang berwenang.', theme: theme),
                const SizedBox(height: PkSpacing.lg),

                _SectionTitle(title: '13. Ketentuan Lain', theme: theme),
                _BulletText(text: 'Apabila salah satu ketentuan dalam S&K ini dinyatakan tidak sah atau tidak dapat diberlakukan, ketentuan lainnya tetap berlaku penuh', theme: theme),
                _BulletText(text: 'S&K ini, bersama Kebijakan Privasi, merupakan keseluruhan kesepakatan antara Pengguna dan kami terkait penggunaan Aplikasi', theme: theme),
                const SizedBox(height: PkSpacing.lg),

                _SectionTitle(title: '14. Hubungi Kami', theme: theme),
                Text(
                  'Jika ada pertanyaan terkait S&K ini, silakan hubungi:\n'
                  '• Nama Entitas: Tim Pengembang PeduliKeluarga\n'
                  '• E-mail: support@pedulikeluarga.com',
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
