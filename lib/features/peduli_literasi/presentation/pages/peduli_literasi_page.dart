import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/pk_design.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/app_top_bar.dart';

// ─── Data Model ────────────────────────────────────────────────

class LiterasiArticle {
  const LiterasiArticle({
    required this.id,
    required this.title,
    required this.category,
    required this.summary,
    required this.content,
    required this.readMinutes,
    required this.imageAsset,
    required this.tone,
  });

  final String id;
  final String title;
  final String category;
  final String summary;
  final String content;
  final int readMinutes;
  final String imageAsset;
  final PkTone tone;
}

// ─── Mock Data ─────────────────────────────────────────────────

const _categories = [
  'Semua',
  'Jantung',
  'Diabetes',
  'Hipertensi',
  'Mobilitas',
  'Nutrisi',
  'Mental',
];

final _articles = [
  const LiterasiArticle(
    id: '1',
    title: 'Mengelola Tekanan Darah Tinggi pada Lansia',
    category: 'Hipertensi',
    summary: 'Panduan lengkap mengelola hipertensi dengan perubahan gaya hidup dan pemantauan rutin.',
    content:
        'Hipertensi atau tekanan darah tinggi adalah kondisi umum pada lansia yang sering disebut sebagai *silent killer*. Tekanan darah normal adalah di bawah **120/80 mmHg**.\n\n'
        '### 🩺 Langkah Pengelolaan Utama\n'
        'Mencegah dan mengelola tekanan darah tinggi bisa dilakukan melalui kebiasaan sehari-hari:\n\n'
        '*   **Kurangi Asupan Garam:** Batasi konsumsi garam maksimal 1 sendok teh (sekitar 2.000 mg natrium) per hari. Hindari makanan kaleng, mi instan, atau makanan olahan yang tinggi garam.\n'
        '*   **Aktif Bergerak:** Lakukan olahraga ringan seperti jalan kaki atau bersepeda santai setidaknya 30 menit setiap hari.\n'
        '*   **Pola Makan Sehat (DASH Diet):** Perbanyak konsumsi sayuran hijau, buah-buahan segar, dan biji-bijian.\n'
        '*   **Kelola Stres:** Lakukan relaksasi, meditasi, atau aktivitas menyenangkan bersama keluarga untuk menurunkan kadar stres.\n'
        '*   **Konsumsi Obat Secara Teratur:** Jangan pernah menghentikan pengobatan tanpa persetujuan dokter, meskipun Anda merasa sehat.\n\n'
        '> **Penting!** Jika tekanan darah Anda melonjak drastis hingga lebih dari **180/120 mmHg** dan disertai gejala sakit kepala hebat, segera kunjungi instalasi gawat darurat (IGD).',
    readMinutes: 4,
    imageAsset: 'assets/images/hipertensi.webp',
    tone: PkTone.red,
  ),
  const LiterasiArticle(
    id: '2',
    title: 'Panduan Gula Darah Sehat untuk Lansia Diabetik',
    category: 'Diabetes',
    summary: 'Cara menjaga kadar gula darah tetap stabil dengan diet, olahraga, dan monitoring.',
    content:
        'Diabetes tipe 2 adalah tantangan kesehatan yang sangat umum dihadapi lansia. Menjaga kestabilan kadar gula darah sangat penting untuk menghindari komplikasi seperti gangguan saraf atau penglihatan.\n\n'
        '### 🩸 Kiat Mengelola Gula Darah\n\n'
        '1.  **Atur Pola Makan (Diet 3J):** Perhatikan *Jadwal, Jumlah, dan Jenis* makanan. Makanlah dengan porsi kecil tapi sering, dan hindari makanan manis serta karbohidrat olahan (seperti roti putih dan kue).\n'
        '2.  **Pilih Karbohidrat Kompleks:** Gantilah nasi putih dengan nasi merah, beras cokelat, atau oatmeal yang kaya akan serat.\n'
        '3.  **Cek Gula Darah Rutin:** Pantau gula darah Anda secara teratur, baik puasa maupun setelah makan. Catat hasilnya untuk dievaluasi oleh dokter.\n'
        '4.  **Tetap Bergerak:** Olahraga membantu tubuh menggunakan insulin dengan lebih baik. Jalan santai di pagi hari sangat direkomendasikan.\n\n'
        '> **Waspada Hipoglikemia (Gula Darah Rendah)**\n'
        '> Gejala hipoglikemia meliputi gemetar, keringat dingin, jantung berdebar, dan pusing. Jika Anda merasakannya, **segera minum teh manis** atau konsumsi permen/gula murni, lalu istirahat.',
    readMinutes: 5,
    imageAsset: 'assets/images/diabetes.webp',
    tone: PkTone.amber,
  ),
  const LiterasiArticle(
    id: '3',
    title: 'Kesehatan Jantung: Tips untuk Lansia',
    category: 'Jantung',
    summary: 'Jaga kesehatan jantung dengan gaya hidup sehat dan pemantauan faktor risiko.',
    content:
        'Penyakit jantung koroner, gagal jantung, dan gangguan irama jantung sering terjadi seiring bertambahnya usia. Kabar baiknya, Anda dapat mengambil langkah aktif untuk menjaga jantung tetap prima!\n\n'
        '### ❤️ Cara Menjaga Jantung Tetap Kuat\n\n'
        '*   **Berhenti Merokok:** Rokok adalah musuh utama jantung. Berhenti merokok dapat menurunkan risiko serangan jantung secara dramatis.\n'
        '*   **Diet Rendah Lemak Jahat:** Hindari makanan bersantan kental, gorengan, dan daging berlemak tinggi. Pilihlah sumber lemak baik seperti alpukat, ikan laut, atau minyak zaitun.\n'
        '*   **Jaga Berat Badan Ideal:** Kelebihan berat badan memaksa jantung bekerja lebih keras.\n'
        '*   **Kontrol Kolesterol dan Tekanan Darah:** Pastikan angka kolesterol LDL (lemak jahat) tetap rendah dan tekanan darah terkendali.\n\n'
        '**Kenali Tanda Serangan Jantung!**\n'
        'Jika Anda atau keluarga mengalami nyeri dada menjalar ke lengan/rahang, sesak napas tiba-tiba, dan keringat dingin, **jangan menunda! SEGERA hubungi layanan darurat 119**.',
    readMinutes: 6,
    imageAsset: 'assets/images/jantung.webp',
    tone: PkTone.red,
  ),
  const LiterasiArticle(
    id: '4',
    title: 'Nutrisi Tepat untuk Lansia Sehat',
    category: 'Nutrisi',
    summary: 'Panduan nutrisi seimbang khusus untuk lansia agar tetap kuat dan aktif.',
    content:
        'Seiring bertambahnya usia, metabolisme tubuh melambat sehingga lansia membutuhkan lebih sedikit kalori, namun justru **lebih banyak** zat gizi tertentu untuk mencegah osteoporosis dan hilangnya massa otot.\n\n'
        '### 🥗 Nutrisi Kunci yang Wajib Dipenuhi\n\n'
        '*   **Protein:** Sangat penting untuk mempertahankan massa dan kekuatan otot. Sumber terbaik: dada ayam, ikan, telur rebus, dan tahu/tempe.\n'
        '*   **Kalsium & Vitamin D:** Kombinasi ini vital untuk mencegah tulang keropos (osteoporosis). Minumlah susu rendah lemak, makan sayuran hijau gelap, dan berjemurlah di pagi hari (sebelum jam 9 pagi) selama 15 menit.\n'
        '*   **Serat Alami:** Mencegah sembelit yang sangat umum pada lansia. Konsumsi pepaya, pisang, sayuran rebus, dan kacang-kacangan.\n'
        '*   **Air Putih:** Rasa haus pada lansia seringkali berkurang. Pastikan minum minimal **6-8 gelas per hari** meski tidak merasa haus.\n\n'
        '*Hindari makanan yang digoreng kering, sangat asin, atau mengandung pengawet buatan.*',
    readMinutes: 4,
    imageAsset: 'assets/images/nutrisi.webp',
    tone: PkTone.green,
  ),
  const LiterasiArticle(
    id: '5',
    title: 'Cegah Jatuh: Keselamatan Lansia di Rumah',
    category: 'Mobilitas',
    summary: 'Strategi praktis mencegah risiko jatuh pada lansia di dalam dan luar rumah.',
    content:
        'Jatuh adalah penyebab utama patah tulang (terutama panggul) dan cedera kepala pada lansia. Sebagian besar insiden jatuh justru terjadi di dalam rumah!\n\n'
        '### 🏡 Modifikasi Rumah yang Aman\n\n'
        '1.  **Kamar Mandi:** Pasang *grab bar* (pegangan besi) di dekat kloset dan shower. Gunakan keset karet anti-selip di area basah.\n'
        '2.  **Pencahayaan:** Pastikan rumah terang benderang. Pasang lampu tidur kecil di lorong menuju kamar mandi untuk malam hari.\n'
        '3.  **Lantai Bersih & Rapi:** Singkirkan karpet yang ujungnya terlipat, kabel yang berserakan, atau barang-barang kecil di lantai yang bisa membuat tersandung.\n'
        '4.  **Alas Kaki Tepat:** Gunakan sandal jepit berbahan karet (anti-licin) di dalam rumah. Hindari berjalan hanya dengan kaus kaki di lantai keramik.\n\n'
        '### 🤸 Latihan Keseimbangan Sederhana\n'
        'Berdiri dengan satu kaki (sambil berpegangan pada kursi yang stabil) selama 10 detik, lalu bergantian. Latihan sederhana ini, jika dilakukan setiap hari, dapat melatih keseimbangan tubuh dengan signifikan!',
    readMinutes: 5,
    imageAsset: 'assets/images/mobilitas.webp',
    tone: PkTone.purple,
  ),
  const LiterasiArticle(
    id: '6',
    title: 'Kesehatan Mental Lansia: Melawan Kesepian',
    category: 'Mental',
    summary: 'Cara mendukung kesehatan mental dan emosional lansia agar tetap bahagia.',
    content:
        'Fisik yang sehat harus diimbangi dengan pikiran yang bahagia. Lansia rentan mengalami *post-power syndrome*, rasa kesepian, dan depresi, terutama jika tinggal berjauhan dengan anak-cucu.\n\n'
        '### 🧠 Menjaga Pikiran Tetap Bahagia\n\n'
        '*   **Tetap Terhubung:** Luangkan waktu untuk menelepon *video call* dengan keluarga, anak, atau cucu secara rutin.\n'
        '*   **Bersosialisasi:** Ikutilah kegiatan di luar rumah seperti senam lansia, pengajian rutin, atau perkumpulan pensiunan. Bertemu teman sebaya sangat membantu mengatasi rasa sepi.\n'
        '*   **Aktif Menggali Hobi Baru:** Menanam bunga, memelihara burung, merajut, atau sekadar membaca buku dapat membuat otak tetap aktif dan mencegah kepikunan (demensia).\n'
        '*   **Bercerita (Nostalgia):** Berbagi cerita masa muda kepada cucu dapat memberikan rasa bermakna dan berharga.\n\n'
        '**Pesan untuk Keluarga:**\n'
        'Jangan abaikan jika lansia mulai kehilangan nafsu makan, sering mengurung diri di kamar, atau tampak murung. Dukungan keluarga adalah obat mental paling mujarab!',
    readMinutes: 5,
    imageAsset: 'assets/images/mental.webp',
    tone: PkTone.blue,
  ),
];

// ─── Provider ──────────────────────────────────────────────────

class LiterasiState {
  const LiterasiState({
    this.selectedCategory = 'Semua',
    this.searchQuery = '',
    this.selectedArticle,
  });

  final String selectedCategory;
  final String searchQuery;
  final LiterasiArticle? selectedArticle;

  LiterasiState copyWith({
    String? selectedCategory,
    String? searchQuery,
    LiterasiArticle? selectedArticle,
    bool clearArticle = false,
  }) {
    return LiterasiState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedArticle:
          clearArticle ? null : selectedArticle ?? this.selectedArticle,
    );
  }

  List<LiterasiArticle> get filteredArticles {
    return _articles.where((a) {
      final matchCat = selectedCategory == 'Semua' ||
          a.category == selectedCategory;
      final matchSearch = searchQuery.isEmpty ||
          a.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          a.summary.toLowerCase().contains(searchQuery.toLowerCase());
      return matchCat && matchSearch;
    }).toList();
  }
}

final literasiProvider =
    NotifierProvider<LiterasiController, LiterasiState>(
  LiterasiController.new,
);

class LiterasiController extends Notifier<LiterasiState> {
  @override
  LiterasiState build() => const LiterasiState();

  void selectCategory(String cat) =>
      state = state.copyWith(selectedCategory: cat, clearArticle: true);

  void setSearchQuery(String q) =>
      state = state.copyWith(searchQuery: q, clearArticle: true);

  void openArticle(LiterasiArticle article) =>
      state = state.copyWith(selectedArticle: article);

  void closeArticle() => state = state.copyWith(clearArticle: true);
}

// ─── Page ──────────────────────────────────────────────────────

class PeduliLiterasiPage extends ConsumerStatefulWidget {
  const PeduliLiterasiPage({super.key});

  @override
  ConsumerState<PeduliLiterasiPage> createState() =>
      _PeduliLiterasiPageState();
}

class _PeduliLiterasiPageState extends ConsumerState<PeduliLiterasiPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(literasiProvider);
    final notifier = ref.read(literasiProvider.notifier);

    // Show article detail view
    if (state.selectedArticle != null) {
      return _ArticleDetailPage(
        article: state.selectedArticle!,
        onBack: notifier.closeArticle,
      );
    }

    return Scaffold(
      appBar: const AppTopBar(),
      body: PkGradientBackground(
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.horizontalPagePadding,
          ),
          child: ResponsiveCenter(
            maxWidth: 860,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 22, 0, 16),
                  child: _LiterasiHeader(),
                ),

                // ── Search ──────────────────────────────────────
                TextField(
                  controller: _searchController,
                  onChanged: notifier.setSearchQuery,
                  decoration: const InputDecoration(
                    hintText: 'Cari artikel kesehatan...',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
                const SizedBox(height: PkSpacing.md),

                // ── Category Filter ──────────────────────────────
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = cat == state.selectedCategory;
                      return GestureDetector(
                        onTap: () => notifier.selectCategory(cat),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? PkColors.brand
                                : PkColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? PkColors.brand
                                  : PkColors.line,
                            ),
                          ),
                          child: Text(
                            cat,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: isSelected
                                      ? Colors.white
                                      : PkColors.text2,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: PkSpacing.md),

                // ── Articles List ────────────────────────────────
                Expanded(
                  child: state.filteredArticles.isEmpty
                      ? _EmptySearchState()
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.filteredArticles.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: PkSpacing.sm),
                          itemBuilder: (context, index) {
                            final article = state.filteredArticles[index];
                            return _ArticleCard(
                              article: article,
                              onTap: () =>
                                  notifier.openArticle(article),
                            );
                          },
                        ),
                ),
                const SizedBox(height: PkSpacing.md),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }
}

// ─── Widgets ───────────────────────────────────────────────────

class _LiterasiHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/icons/peduliliterasi.webp',
          width: 44,
          height: 44,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PeduliLiterasi',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: PkColors.text,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              Text(
                'Artikel kesehatan terpercaya untuk lansia.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: PkColors.text2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({required this.article, required this.onTap});
  final LiterasiArticle article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PkCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: PkRadius.mdRadius,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                article.imageAsset,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: PkColors.text,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.summary,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: PkColors.text2,
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleDetailPage extends StatelessWidget {
  const _ArticleDetailPage({
    required this.article,
    required this.onBack,
  });
  final LiterasiArticle article;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PkGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // AppBar
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.horizontalPagePadding,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.arrow_back_rounded, size: 16),
                      label: const Text('Kembali'),
                      onPressed: onBack,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: PkColors.text2,
                        side: BorderSide(color: PkColors.line),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        article.category,
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: PkColors.text2,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.horizontalPagePadding,
                    vertical: PkSpacing.md,
                  ),
                  child: ResponsiveCenter(
                    maxWidth: 720,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: PkColors.text,
                                fontWeight: FontWeight.w900,
                                height: 1.3,
                              ),
                        ),
                        const SizedBox(height: PkSpacing.sm),
                        Row(
                          children: [
                            Icon(Icons.schedule_rounded,
                                size: 14, color: PkColors.muted),
                            const SizedBox(width: 4),
                            Text(
                              'Waktu baca: ${article.readMinutes} menit',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(color: PkColors.muted),
                            ),
                          ],
                        ),
                        const SizedBox(height: PkSpacing.lg),
                        // Summary box
                        PkCard(
                          tint: PkToneHelper.softColor(article.tone),
                          borderColor: PkToneHelper.mainColor(article.tone)
                              .withValues(alpha: 0.2),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline_rounded,
                                  color:
                                      PkToneHelper.mainColor(article.tone),
                                  size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  article.summary,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: PkToneHelper.mainColor(
                                            article.tone),
                                        fontStyle: FontStyle.italic,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: PkSpacing.lg),
                        // Article body
                        PkCard(
                          child: MarkdownBody(
                            data: article.content,
                            styleSheet: MarkdownStyleSheet(
                              p: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: PkColors.text, height: 1.7),
                              h3: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: PkColors.text,
                                    fontWeight: FontWeight.w900,
                                    height: 1.5,
                                  ),
                              blockquote: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: PkToneHelper.mainColor(article.tone),
                                    fontWeight: FontWeight.w600,
                                  ),
                              blockquoteDecoration: BoxDecoration(
                                color: PkToneHelper.softColor(article.tone),
                                border: Border(
                                  left: BorderSide(
                                    color: PkToneHelper.mainColor(article.tone),
                                    width: 4,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              blockquotePadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: PkSpacing.xl),
                        // Disclaimer
                        PkCard(
                          tint: PkColors.amberSoft,
                          borderColor:
                              PkColors.amber.withValues(alpha: 0.2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.warning_amber_rounded,
                                  color: PkColors.amber, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Artikel ini bersifat informatif. Untuk diagnosis dan penanganan medis, selalu konsultasikan dengan dokter atau tenaga kesehatan profesional.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: PkColors.amber,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: PkColors.muted),
          const SizedBox(height: 12),
          Text(
            'Artikel tidak ditemukan',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: PkColors.text2,
                ),
          ),
        ],
      ),
    );
  }
}

