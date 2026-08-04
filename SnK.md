# Syarat dan Ketentuan PeduliKeluarga

> **Catatan penggunaan dokumen ini:** Teks di bawah adalah *template* yang dapat disesuaikan. Bagian yang perlu diisi/disesuaikan ditandai dengan `[isi di sini]`. Dokumen ini mencakup (1) rangkaian ketentuan yang menjadi isi teks Syarat dan Ketentuan, dan (2) spesifikasi implementasi halaman/komponen yang menampilkan teks tersebut agar dapat diakses dari halaman Login dan Daftar.

---

## Bagian A — Spesifikasi Implementasi (untuk tim produk/desain/dev)

### A.1 Titik Akses (Entry Point)

Teks berikut ditampilkan di bagian paling bawah halaman **Login** dan halaman **Daftar**:

> "Dengan masuk atau mendaftar, saya menyetujui **Syarat dan Ketentuan** PeduliKeluarga"

Ketentuan tampilan:
- Frasa **"Syarat dan Ketentuan"** ditulis sebagai teks bertaut (*hyperlink*/*tappable text*), dibedakan secara visual dari teks sekitarnya (mis. warna aksen aplikasi, garis bawah, atau *bold*)
- Frasa ini tidak berupa tombol persetujuan terpisah (bukan checkbox) — cukup tautan navigasi, sesuai deskripsi permintaan
- Diletakkan di area paling bawah (*footer*) halaman Login dan halaman Daftar
- `[opsional: apakah juga menautkan Kebijakan Privasi di baris yang sama, mis. "...Syarat dan Ketentuan dan Kebijakan Privasi PeduliKeluarga"]`

### A.2 Perilaku Saat Ditekan

Saat pengguna menekan tautan "Syarat dan Ketentuan":
1. Aplikasi membuka **halaman baru** (bukan modal kecil) berjudul **"Syarat dan Ketentuan"**
2. Halaman menampilkan seluruh isi teks S&K (lihat Bagian B) dalam format yang dapat digulir (*scrollable*)
3. Halaman dilengkapi tombol/ikon kembali (←) di pojok kiri atas untuk kembali ke halaman Login/Daftar
4. Navigasi ke halaman ini **tidak mengubah status pengisian form** Login/Daftar yang sedang berlangsung (data yang sudah diisi tetap tersimpan sementara saat kembali)

### A.3 Struktur Halaman Syarat dan Ketentuan (UI)

| Elemen | Keterangan |
|---|---|
| Header | Tombol kembali (←) + judul "Syarat dan Ketentuan" |
| Sub-info | Tanggal berlaku efektif / versi dokumen, mis. "Berlaku sejak `[tanggal]`" |
| Konten | Teks S&K lengkap (Bagian B), dengan heading per bagian agar mudah dinavigasi |
| Footer *(opsional)* | Tautan ke Kebijakan Privasi, tombol "Tutup"/"Kembali" |

### A.4 Ketentuan Teknis Tambahan
- Konten S&K sebaiknya disimpan sebagai data/CMS terpisah (bukan hardcode di kode UI) agar mudah diperbarui tanpa rilis ulang aplikasi
- Setiap perubahan isi S&K perlu mencantumkan nomor versi dan tanggal perubahan
- Pertimbangkan mekanisme pencatatan (log) bahwa pengguna telah "menyetujui" versi S&K tertentu saat mendaftar, untuk kepentingan audit/kepatuhan
- `[opsional: jika suatu saat S&K berubah signifikan, tentukan apakah pengguna lama perlu diminta menyetujui ulang]`

---

## Bagian B — Isi Teks Syarat dan Ketentuan (ditampilkan pada halaman di atas)

# Syarat dan Ketentuan PeduliKeluarga

**Terakhir diperbarui:** `[isi tanggal]`
**Berlaku efektif:** `[isi tanggal]`

Selamat datang di **PeduliKeluarga**. Syarat dan Ketentuan ini ("S&K") mengatur penggunaan aplikasi PeduliKeluarga ("Aplikasi", "kami") oleh Anda ("Pengguna"). Dengan mengakses, masuk, atau mendaftar pada Aplikasi, Anda menyatakan telah membaca, memahami, dan menyetujui untuk terikat pada S&K ini.

### 1. Definisi
- **Aplikasi** merujuk pada platform PeduliKeluarga, termasuk situs web dan aplikasi seluler `[isi]`
- **Pengguna** adalah setiap individu yang mendaftar, masuk, atau menggunakan layanan Aplikasi
- **Layanan** adalah seluruh fitur yang disediakan Aplikasi, termasuk namun tidak terbatas pada `[isi: pendataan keluarga, konsultasi, bantuan sosial, dll]`
- **Konten** adalah seluruh data, teks, gambar, dokumen, atau informasi lain yang diunggah atau dihasilkan melalui Aplikasi

### 2. Kelayakan Pengguna
- Pengguna harus berusia minimal `[isi: 17/18]` tahun atau merupakan orang tua/wali yang mendaftarkan anggota keluarga di bawah umur atas nama dan tanggung jawabnya sendiri
- Pengguna wajib memberikan data pendaftaran yang benar, akurat, dan terkini
- Aplikasi berhak menolak atau menangguhkan pendaftaran apabila ditemukan data yang tidak valid

### 3. Akun Pengguna
- Pengguna bertanggung jawab menjaga kerahasiaan kredensial akun (kata sandi, OTP, dll)
- Segala aktivitas yang dilakukan melalui akun Pengguna menjadi tanggung jawab Pengguna, kecuali dapat dibuktikan terjadi penyalahgunaan di luar kendali Pengguna
- Pengguna wajib segera memberitahukan kami apabila mendapati indikasi penggunaan akun tanpa izin

### 4. Ruang Lingkup Layanan
Aplikasi menyediakan layanan sebagai berikut:
1. `[isi: pendataan dan pengelolaan data anggota keluarga]`
2. `[isi: fitur konsultasi/telekonsultasi, jika ada]`
3. `[isi: fitur pengajuan bantuan/klaim, jika ada]`
4. `[isi fitur lain sesuai cakupan aplikasi]`

Kami berhak menambah, mengubah, atau menghentikan sebagian maupun seluruh fitur Layanan sewaktu-waktu dengan atau tanpa pemberitahuan sebelumnya, sepanjang diperlukan untuk pengembangan atau pemeliharaan Aplikasi.

### 5. Kewajiban dan Larangan Pengguna
Pengguna setuju untuk **tidak**:
- Menggunakan Aplikasi untuk tujuan melanggar hukum atau merugikan pihak lain
- Mengunggah Konten yang mengandung unsur SARA, kekerasan, pornografi, ujaran kebencian, atau pelanggaran hukum lainnya
- Memalsukan identitas atau data anggota keluarga yang didaftarkan
- Melakukan tindakan yang dapat mengganggu keamanan atau kestabilan sistem Aplikasi (mis. peretasan, penyebaran malware)
- Menyalahgunakan data pribadi milik pengguna lain yang diperoleh melalui Aplikasi

### 6. Data Pribadi dan Privasi
Pengumpulan, penggunaan, dan pembagian data pribadi Pengguna diatur secara khusus dalam **Kebijakan Privasi PeduliKeluarga**, yang merupakan bagian tidak terpisahkan dari S&K ini. `[tautkan ke dokumen Kebijakan Privasi]`

### 7. Konten Pengguna
- Pengguna tetap memegang hak atas Konten yang diunggah, namun memberikan izin kepada kami untuk menyimpan, memproses, dan menampilkan Konten tersebut sepanjang diperlukan untuk penyediaan Layanan
- Kami berhak menghapus Konten yang melanggar S&K ini tanpa pemberitahuan sebelumnya

### 8. Kekayaan Intelektual
- Seluruh hak kekayaan intelektual atas Aplikasi (termasuk namun tidak terbatas pada logo, desain antarmuka, kode program, dan merek "PeduliKeluarga") adalah milik `[isi nama entitas/pengembang]` atau pemberi lisensinya
- Pengguna dilarang menyalin, memodifikasi, mendistribusikan, atau membuat karya turunan dari Aplikasi tanpa izin tertulis

### 9. Biaya Layanan *(jika relevan)*
- `[isi: apakah Layanan berbayar/gratis, skema biaya, mekanisme pembayaran, kebijakan pengembalian dana, dll — hapus bagian ini jika Layanan sepenuhnya gratis]`

### 10. Batasan Tanggung Jawab
- Aplikasi disediakan atas dasar "sebagaimana adanya" (*as is*) dan "sebagaimana tersedia" (*as available*)
- Kami tidak menjamin Layanan akan bebas dari gangguan, kesalahan, atau selalu tersedia tanpa henti
- `[isi: apakah Aplikasi menyediakan informasi/rujukan kesehatan-sosial namun bukan pengganti layanan profesional resmi — cantumkan disclaimer yang relevan bila Aplikasi menyentuh ranah kesehatan/sosial]`
- Sepanjang diizinkan oleh hukum yang berlaku, kami tidak bertanggung jawab atas kerugian tidak langsung, insidental, atau konsekuensial yang timbul dari penggunaan Aplikasi

### 11. Penangguhan dan Penghentian Akun
Kami berhak menangguhkan atau menghentikan akses Pengguna terhadap Aplikasi apabila:
- Pengguna terbukti melanggar S&K ini
- Terdapat indikasi penyalahgunaan, penipuan, atau aktivitas mencurigakan lainnya
- Diwajibkan oleh ketentuan hukum yang berlaku

Pengguna juga dapat mengajukan penghapusan akun sewaktu-waktu melalui `[isi kanal permintaan]`.

### 12. Perubahan Syarat dan Ketentuan
Kami dapat mengubah S&K ini dari waktu ke waktu. Perubahan akan diinformasikan melalui Aplikasi, dan perubahan tersebut berlaku efektif sejak tanggal yang tercantum pada versi terbaru. Penggunaan Aplikasi setelah perubahan berlaku dianggap sebagai persetujuan atas S&K yang telah diperbarui.

### 13. Hukum yang Berlaku dan Penyelesaian Sengketa
- S&K ini diatur dan ditafsirkan berdasarkan hukum Negara Republik Indonesia
- Segala perselisihan yang timbul akan diselesaikan terlebih dahulu secara musyawarah; apabila tidak tercapai kesepakatan, akan diselesaikan melalui `[isi: pengadilan negeri setempat / mekanisme arbitrase, sesuai kebutuhan]`

### 14. Ketentuan Lain
- Apabila salah satu ketentuan dalam S&K ini dinyatakan tidak sah atau tidak dapat diberlakukan, ketentuan lainnya tetap berlaku penuh
- S&K ini, bersama Kebijakan Privasi, merupakan keseluruhan kesepakatan antara Pengguna dan kami terkait penggunaan Aplikasi

### 15. Hubungi Kami
Jika ada pertanyaan terkait S&K ini, silakan hubungi:
- **Nama Entitas:** `[isi nama organisasi/pengembang]`
- **E-mail:** `[isi alamat e-mail]`
- **Alamat:** `[isi alamat, jika relevan]`

---

### Catatan Implementasi (opsional, hapus sebelum publikasi)
- Sesuaikan seluruh bagian `[isi di sini]` dengan cakupan fitur, model bisnis, dan entitas pengelola PeduliKeluarga yang sebenarnya
- Jika Aplikasi menyentuh data kesehatan/sosial anggota keluarga, pertimbangkan konsultasi hukum untuk kepatuhan terhadap UU PDP dan regulasi sektor terkait
- Pastikan konsistensi istilah dan penomoran antara dokumen S&K ini dan dokumen Kebijakan Privasi (PRIVACY.md)
- Tim desain dapat menggunakan Bagian A sebagai acuan spesifikasi UI/UX untuk implementasi halaman Login, Daftar, dan halaman Syarat dan Ketentuan
