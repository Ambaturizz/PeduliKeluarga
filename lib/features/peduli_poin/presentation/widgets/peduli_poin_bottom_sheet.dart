import 'package:flutter/material.dart';
import '../../../../core/theme/pk_design.dart';


// Dummy Data
class _VoucherItem {
  final String title;
  final String desc;
  final int points;
  final IconData icon;
  final PkTone tone;
  const _VoucherItem(this.title, this.desc, this.points, this.icon, this.tone);
}

class _HistoryItem {
  final String title;
  final String date;
  final int points;
  final bool isEarned;
  const _HistoryItem(this.title, this.date, this.points, this.isEarned);
}

const _dummyVouchers = [
  _VoucherItem('Diskon Ongkir Rp10rb', 'Berlaku untuk layanan PeduliAntar', 150, Icons.local_shipping_rounded, PkTone.amber),
  _VoucherItem('Konsultasi Gratis', 'Gratis 1x tanya dokter di AhliPeduli', 300, Icons.medical_services_rounded, PkTone.green),
  _VoucherItem('Potongan Harga Obat 10%', 'Pembelian di mitra apotek', 250, Icons.medication_rounded, PkTone.red),
  _VoucherItem('Cek Gula Darah Gratis', 'Berlaku di layanan PeduliPantau', 400, Icons.water_drop_rounded, PkTone.blue),
];

const _dummyHistory = [
  _HistoryItem('Tukar Voucher Ongkir', 'Hari ini, 09:30', 150, false),
  _HistoryItem('Membaca 5 Artikel Kesehatan', 'Kemarin, 14:15', 50, true),
  _HistoryItem('Cek Rutin PeduliPantau', '26 Jul 2026', 100, true),
  _HistoryItem('Tanya AhliPeduli', '25 Jul 2026', 25, true),
  _HistoryItem('Bonus Pengguna Baru', '20 Jul 2026', 500, true),
];

class PeduliPoinBottomSheet extends StatelessWidget {
  const PeduliPoinBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            // Handle and Header
            const SizedBox(height: 12),
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),
            // Poin Balance
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: PkColors.amberSoft,
                      borderRadius: PkRadius.mdRadius,
                    ),
                    child: const Icon(Icons.stars_rounded, color: PkColors.amber, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Poin Anda',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: PkColors.text2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '1,250 Poin',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: PkColors.amber,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Tabs
            const TabBar(
              labelColor: PkColors.amber,
              unselectedLabelColor: PkColors.text2,
              indicatorColor: PkColors.amber,
              indicatorWeight: 3,
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              tabs: [
                Tab(text: 'Tukar Voucher'),
                Tab(text: 'Riwayat Poin'),
              ],
            ),
            // Content
            Expanded(
              child: TabBarView(
                children: [
                  _VoucherTabView(),
                  _HistoryTabView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VoucherTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: _dummyVouchers.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final v = _dummyVouchers[index];
        return PkCard(
          padding: EdgeInsets.zero,
          child: Row(
            children: [
              Container(
                width: 80,
                height: 100,
                decoration: BoxDecoration(
                  color: PkToneHelper.softColor(v.tone),
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                ),
                child: Center(
                  child: Icon(v.icon, color: PkToneHelper.mainColor(v.tone), size: 36),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        v.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: PkColors.text),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        v.desc,
                        style: const TextStyle(color: PkColors.text2, fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: PkColors.amberSoft,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star_rounded, color: PkColors.amber, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  '${v.points}',
                                  style: const TextStyle(color: PkColors.amber, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 32,
                            child: FilledButton(
                              onPressed: () {},
                              style: FilledButton.styleFrom(
                                backgroundColor: PkColors.amber,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              child: const Text('Tukar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HistoryTabView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: _dummyHistory.length,
      separatorBuilder: (context, index) => Divider(height: 24, color: PkColors.line),
      itemBuilder: (context, index) {
        final h = _dummyHistory[index];
        return Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: h.isEarned ? PkColors.greenSoft : PkColors.redSoft,
                shape: BoxShape.circle,
              ),
              child: Icon(
                h.isEarned ? Icons.add_rounded : Icons.remove_rounded,
                color: h.isEarned ? PkColors.green : PkColors.red,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    h.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: PkColors.text),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    h.date,
                    style: const TextStyle(color: PkColors.muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              '${h.isEarned ? '+' : '-'}${h.points}',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: h.isEarned ? PkColors.green : PkColors.red,
              ),
            ),
          ],
        );
      },
    );
  }
}
