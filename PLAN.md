# Rencana Detail: Redesain Beranda (Gojek Style) & Penyesuaian Navigasi

Dokumen ini adalah rencana implementasi (blueprint) yang sangat rinci untuk mengubah UI Beranda (Dashboard) dan Bottom Navigation Bar pada aplikasi `peduli_keluarga` agar sesuai dengan permintaan. 

## 1. Analisis Kebutuhan

Berdasarkan *prompt*, aplikasi harus membedakan tampilan menu Beranda dan navigasi bawah bergantung pada peran pengguna (Lansia vs Anak).

**Mode Lansia:**
- **Menu Grid Beranda (Bagian Atas):** PeduliCek, PeduliObat, PeduliDarurat, PeduliRiwayat, PeduliLiterasi.
- **Bottom Navigation (Bagian Bawah):** Beranda, PeduliDiri (Panduan), PeduliKonsul, PeduliChat.

**Mode Anak (Caregiver):**
- **Menu Grid Beranda (Bagian Atas):** PeduliRiwayat, PeduliObat, PeduliPantau, PeduliAntar, AhliPeduli, PeduliDarurat, PeduliLiterasi.
- **Bottom Navigation (Bagian Bawah):** Beranda, PeduliPantau, PeduliChat, PeduliDarurat.

**Desain UI (Gojek Style):**
- **Header:** Terdapat Search Bar dan Profile (bagian teratas).
- **Wallet Card:** Akan dinamai **PeduliPoin**, posisinya di bawah Header.
- **Grid Menu:** Akan memuat menu berdasarkan peran menggunakan ikon khusus dari `assets/icons/` berformat `.webp` / `.png`.
- **Promo Banner:** Akan menggunakan **Banner Nama** (mirip dengan `PremiumHomeHero` saat ini yang menyapa "Halo, [Nama]" dengan keterangan mode "PeduliPenuh" atau "PeduliDiri").

---

## 2. Rencana Perubahan Data Model

### 2.1 Modifikasi `home_dummy_data.dart`
File: `lib/features/home/data/home_dummy_data.dart`
- **Enum `HomeActionTarget`**: Tambahkan `peduliLiterasi`.
- **Class `HomeQuickAction`**: 
  - Ganti (atau tambahkan) field `IconData icon` menjadi `String iconPath`.
- **Konfigurasi Data Lansia (`_elder`)**:
  - Sesuaikan array `quickActions` untuk Lansia menjadi persis 5 menu:
    1. PeduliCek (`assets/icons/pedulicek.webp`)
    2. PeduliObat (`assets/icons/peduliobat.webp`)
    3. PeduliDarurat (`assets/icons/pedulidarurat.webp`)
    4. PeduliRiwayat (`assets/icons/peduliriwayat.webp`)
    5. PeduliLiterasi (`assets/icons/peduliliterasi.webp`)
- **Konfigurasi Data Anak (`_caregiver`)**:
  - Sesuaikan array `quickActions` untuk Anak menjadi persis 7 menu:
    1. PeduliRiwayat (`assets/icons/peduliriwayat.webp`)
    2. PeduliObat (`assets/icons/peduliobat.webp`)
    3. PeduliPantau (`assets/icons/pedulipantau.webp`)
    4. PeduliAntar (`assets/icons/peduliantar.webp`)
    5. AhliPeduli (`assets/icons/ahlipeduli.webp`)
    6. PeduliDarurat (`assets/icons/pedulidarurat.webp`)
    7. PeduliLiterasi (`assets/icons/peduliliterasi.webp`)

---

## 3. Rencana Pembuatan Widget Baru (UI Gojek)

Semua widget akan diletakkan di dalam folder `lib/features/home/presentation/widgets/`.

### 3.1 `gojek_style_header.dart`
- **Fungsi:** Komponen bagian paling atas yang memuat *Search bar* ("Cari di PeduliKeluarga") di sebelah kiri dan tombol Profil di sebelah kanan.

### 3.2 `peduli_poin_card.dart`
- **Fungsi:** Widget melayang (*floating card*) yang mirip dengan GoPay card. 
- **Isi:** Tulisan **PeduliPoin** dengan jumlah poin *dummy* (misal: "242 Poin"), beserta 2-3 tombol aksi kecil seperti "Riwayat", "Isi Ulang", dsb.

### 3.3 `gojek_style_feature_grid.dart`
- **Fungsi:** Widget *Grid* yang membungkus `quickActions`. 
- **Detail:** Menggunakan `Image.asset(action.iconPath)` dan bukan `Icon(action.icon)`. Kotak menu dibuat bergaya modern (*rounded* icon background) yang terinspirasi dari desain Gojek.

### 3.4 Banner Nama (Pemindahan `PremiumHomeHero`)
- Banner "Halo, [Nama Pengguna]" (yang sudah ada pada `PremiumHomeHero`) akan disesuaikan secara visual agar tampak seperti *banner* promo Gojek dan ditempatkan tepat di bawah Grid Fitur. 

---

## 4. Rencana Pembaruan Halaman Beranda

### 4.1 Modifikasi `home_page.dart`
File: `lib/features/home/presentation/pages/home_page.dart`
- **Struktur Baru `CustomScrollView`**:
  1. `GojekStyleHeader()`
  2. `PeduliPoinCard()`
  3. `GojekStyleFeatureGrid(actions: data.quickActions)`
  4. `SizedBox(height: ...)`
  5. Banner Nama (menggunakan modifikasi `PremiumHomeHero` atau komponen ekuivalen yang menyapa nama pengguna).
  6. Bagian sisa dari beranda (misalnya Ringkasan Hari Ini, dll) jika masih dipertahankan di bawahnya.

---

## 5. Rencana Penyesuaian Bottom Navigation Bar

### 5.1 Penambahan Halaman (Placeholder) Baru
- Buat file `lib/features/peduli_diri/presentation/pages/peduli_diri_page.dart` (Halaman Panduan Lansia).
- Buat file `lib/features/peduli_literasi/presentation/pages/peduli_literasi_page.dart` (Halaman Literasi).

### 5.2 Modifikasi Routing Induk
1. **`lib/core/routing/app_route.dart`**:
   - Tambahkan `peduliDiri` dan `peduliLiterasi` ke dalam enum `AppRoute`.
2. **`lib/core/routing/app_routes.dart`**:
   - Daftarkan konstanta _path_ untuk `peduliDiriPath` dan `peduliLiterasiPath`.
3. **`lib/core/routing/app_router.dart`**:
   - Tambahkan `StatefulShellBranch` khusus dengan `NavigatorKey` terpisah untuk **PeduliDiri**, karena ini akan menjadi salah satu tab di Bottom Navigation untuk Lansia.
   - Tambahkan `GoRoute` biasa (bukan shell branch) untuk **PeduliLiterasi**, karena rute ini diakses dari grid Beranda, bukan dari Bottom Navigation Bar.

### 5.3 Modifikasi Navigasi Bottom (`app_navigation_destination.dart`)
File: `lib/core/routing/app_navigation_destination.dart`
- **Daftar `primary`**: Tambahkan instansiasi `AppNavigationDestination` untuk rute `AppRoute.peduliDiri`.
- **Aturan Mode Lansia (`AppUserMode.elder`)**:
  - Pada metode `forMode()`, pastikan filter mereturn persis **4 destinasi**:
    1. Beranda (`AppRoute.home`)
    2. PeduliDiri (`AppRoute.peduliDiri`) - berisi panduan.
    3. PeduliKonsul (`AppRoute.peduliKonsul`)
    4. PeduliChat (`AppRoute.familyChat`)
- **Aturan Mode Anak (`AppUserMode.caregiver`)**:
  - Pada metode `forMode()`, pastikan filter mereturn persis **4 destinasi**:
    1. Beranda (`AppRoute.home`)
    2. PeduliPantau (`AppRoute.peduliPantau`)
    3. PeduliChat (`AppRoute.familyChat`)
    4. PeduliDarurat (`AppRoute.familyAlert`)

---

## 6. Langkah Eksekusi (Implementation Steps)

Jika rencana ini disetujui, urutan pengerjaan yang akan saya lakukan adalah:
1. **Routing Setup**: Membuat halaman *placeholder* dan mendaftarkan *routes* baru di `app_route`, `app_routes`, dan `app_router`.
2. **Navigation Bar Update**: Menyesuaikan `AppNavigationDestinations` agar Bottom Navigation sesuai request (4 tab Lansia, 4 tab Anak).
3. **Data Models Update**: Mengubah `HomeQuickAction` dan data dummy di `home_dummy_data.dart` agar menggunakan properti `iconPath` beserta daftar urutan grid baru.
4. **UI Gojek Components**: Membangun `gojek_style_header.dart`, `peduli_poin_card.dart`, dan `gojek_style_feature_grid.dart`.
5. **Integration**: Menyatukan semua komponen baru ke dalam `home_page.dart` dan memastikan "Banner Nama" tampil elegan sebagai ganti promo banner.
6. **Testing/Verifikasi**: Mengompilasi aplikasi dan mengecek tidak ada navigasi yang _crash_.
