import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/pk_design.dart';

class PromoCarousel extends StatelessWidget {
  const PromoCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Promo & Diskon',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: PkColors.text),
              ),
              TextButton(
                onPressed: () => context.push(AppRoutes.promoPath),
                style: TextButton.styleFrom(
                  foregroundColor: PkColors.amber,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Lihat Semua', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              _buildPromoBanner(context, 'Diskon Ongkir\nPeduliAntar', Icons.local_shipping_rounded, PkColors.blueSoft, PkColors.blue),
              const SizedBox(width: 16),
              _buildPromoBanner(context, 'Konsultasi\nGratis', Icons.medical_services_rounded, PkColors.greenSoft, PkColors.green),
              const SizedBox(width: 16),
              _buildPromoBanner(context, 'Cashback Poin\n50%', Icons.monetization_on_rounded, PkColors.amberSoft, PkColors.amber),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPromoBanner(BuildContext context, String title, IconData icon, Color bgColor, Color iconColor) {
    return InkWell(
      onTap: () => context.push(AppRoutes.promoPath),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 240,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: iconColor.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'PROMO',
                      style: TextStyle(color: iconColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: iconColor.withValues(alpha: 0.9), height: 1.2),
                  ),
                ],
              ),
            ),
            Icon(icon, size: 56, color: iconColor.withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }
}
