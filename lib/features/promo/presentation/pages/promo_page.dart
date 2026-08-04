import 'package:flutter/material.dart';
import '../../../../core/theme/pk_design.dart';
import '../../../../shared/layouts/page_shell.dart';

class _PromoItem {
  final String title;
  final String desc;
  final String date;
  final String code;
  final PkTone tone;
  final IconData icon;

  const _PromoItem(this.title, this.desc, this.date, this.code, this.tone, this.icon);
}

const _dummyPromos = [
  _PromoItem('Diskon 20% PeduliAntar', 'Potongan harga untuk layanan antar jemput khusus akhir pekan.', 'S/d 31 Agu 2026', 'ANTAR20', PkTone.blue, Icons.local_shipping_rounded),
  _PromoItem('Gratis Konsultasi Pertama', 'Dapatkan 1x sesi tanya dokter gratis di AhliPeduli untuk pengguna baru.', 'Tanpa Batas', 'SEHATSELALU', PkTone.green, Icons.medical_services_rounded),
  _PromoItem('Cashback Poin 50%', 'Dapatkan poin berlimpah setiap transaksi tebus obat.', 'S/d 15 Sep 2026', 'OBATHEMAT', PkTone.amber, Icons.medication_rounded),
  _PromoItem('Potongan Cek Lab', 'Diskon Rp50.000 untuk paket periksa darah lengkap.', 'S/d 30 Agu 2026', 'CEKRUTIN', PkTone.red, Icons.bloodtype_rounded),
];

class PromoPage extends StatelessWidget {
  const PromoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageShell(
      title: 'Promo Spesial',
      subtitle: 'Penawaran dan diskon eksklusif untuk Anda',
      icon: Icons.discount_rounded,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _dummyPromos.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final p = _dummyPromos[index];
            return PkCard(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: PkToneHelper.softColor(p.tone),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(p.icon, size: 48, color: PkToneHelper.mainColor(p.tone).withValues(alpha: 0.5)),
                        const SizedBox(width: 16),
                        Text(
                          'PROMO',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: PkToneHelper.mainColor(p.tone).withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: PkColors.redSoft,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                p.date,
                                style: const TextStyle(color: PkColors.red, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          p.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: PkColors.text,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          p.desc,
                          style: const TextStyle(color: PkColors.text2, height: 1.5),
                        ),
                        const SizedBox(height: 16),
                        Divider(height: 1, color: PkColors.line),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Text('Kode Promo:', style: TextStyle(color: PkColors.muted)),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  border: Border.all(color: PkColors.line, style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade50,
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    p.code,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1,
                                      color: PkColors.text,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.copy_rounded, size: 16),
                              label: const Text('Salin'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
