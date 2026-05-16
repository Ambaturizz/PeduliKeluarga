import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../../core/theme/pk_design.dart';
import '../../../ahli_peduli/providers/ahli_peduli_booking_provider.dart';
import '../../../caregiver_profile/domain/caregiver_profile.dart';
import '../../../caregiver_profile/providers/caregiver_profile_provider.dart';
import '../../../elder_profile/domain/elder_profile.dart';
import '../../../elder_profile/providers/elder_profile_provider.dart';
import '../../../peduli_antar/providers/peduli_antar_provider.dart';
import '../../../peduliobat/providers/peduli_obat_provider.dart';
import '../../data/peduli_riwayat_mock_data.dart';

class ExportMedicalSummaryCard extends ConsumerWidget {
  const ExportMedicalSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(elderProfileProvider);
    final pendamping = ref.watch(caregiverProfileProvider);
    final obatState = ref.watch(peduliObatProvider);
    final antarState = ref.watch(peduliAntarProvider);
    final bookingState = ref.watch(ahliPeduliBookingProvider);

    return PkCard(
      padding: const EdgeInsets.all(PkSpacing.lg),
      tint: PkColors.surfaceTint,
      borderColor: PkColors.brand.withValues(alpha: 0.18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const PkIconBox(icon: Icons.description_outlined, tone: PkTone.brand),
              const SizedBox(width: PkSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ringkasan Kesehatan',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: PkColors.text,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.35,
                          ),
                    ),
                    Text(
                      'Buat ringkasan untuk dokter atau keluarga.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: PkColors.text2),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: PkSpacing.lg),
          const _ExportOption(label: 'Identitas lansia dan pendamping', icon: Icons.people_outline_rounded),
          const SizedBox(height: 8),
          const _ExportOption(label: 'Tekanan darah dan gula darah', icon: Icons.monitor_heart_outlined),
          const SizedBox(height: 8),
          const _ExportOption(label: 'Obat aktif dan kepatuhan minum obat', icon: Icons.fact_check_outlined),
          const SizedBox(height: 8),
          const _ExportOption(label: 'Riwayat PeduliAntar dan Booking AhliPeduli', icon: Icons.local_shipping_outlined),
          const SizedBox(height: 8),
          const _ExportOption(label: 'Catatan keluhan dan rekomendasi umum', icon: Icons.note_alt_outlined),
          const SizedBox(height: PkSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showPreview(context, profile, pendamping, obatState, antarState, bookingState);
                  },
                  icon: const Icon(Icons.visibility_outlined),
                  label: const Text('Lihat Ringkasan'),
                ),
              ),
              const SizedBox(width: PkSpacing.sm),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () async {
                    final bytes = await _buildPdf(profile, pendamping, obatState, antarState, bookingState);
                    await Printing.layoutPdf(
                      name: 'ringkasan_kesehatan_pedulikeluarga.pdf',
                      onLayout: (_) async => bytes,
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  label: const Text('Simpan PDF'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPreview(
    BuildContext context,
    ElderProfile profile,
    CaregiverProfile pendamping,
    PeduliObatState obatState,
    PeduliAntarState antarState,
    AhliPeduliBookingState bookingState,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ringkasan Kesehatan'),
          content: SingleChildScrollView(
            child: Text(_summaryText(profile, pendamping, obatState, antarState, bookingState)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  static String _summaryText(
    ElderProfile profile,
    CaregiverProfile pendamping,
    PeduliObatState obatState,
    PeduliAntarState antarState,
    AhliPeduliBookingState bookingState,
  ) {
    final latestBp = bloodPressureHistory.isEmpty ? null : bloodPressureHistory.last;
    final latestSugar = bloodSugarHistory.isEmpty ? null : bloodSugarHistory.last;
    final lastLog = healthLogs.isEmpty ? 'Belum ada catatan keluhan' : '${healthLogs.first.title}: ${healthLogs.first.note}';
    final latestOrder = antarState.latestOrder;
    final latestBooking = bookingState.bookings.isEmpty ? null : bookingState.bookings.first;

    return [
      'Identitas lansia',
      'Nama: ${profile.displayName}',
      'Umur: ${profile.displayAge}',
      'Jenis kelamin: ${profile.displayGender}',
      'Alamat: ${profile.displayAddress}',
      'Riwayat penyakit: ${profile.medicalHistoryLabel}',
      '',
      'Identitas pendamping',
      'Nama pendamping: ${pendamping.displayName}',
      'Nomor telepon: ${pendamping.displayPhone}',
      'Hubungan: ${pendamping.displayRelationship}',
      'Kode koneksi: ${pendamping.displayConnectionCode}',
      '',
      'Ringkasan tekanan darah: ${latestBp?.readingLabel ?? 'Belum ada'} mmHg',
      'Ringkasan gula darah: ${latestSugar == null ? 'Belum ada' : '${latestSugar.mgdl} mg/dL (${latestSugar.statusLabel})'}',
      'Obat aktif: ${obatState.medications.map((item) => '${item.name} ${item.dose}').join(', ')}',
      'Kepatuhan minum obat: ${obatState.adherencePercent}%',
      'Riwayat PeduliAntar: ${latestOrder == null ? 'Belum ada pesanan' : '${latestOrder.medicineNames} · ${latestOrder.status.label} · ${latestOrder.totalPriceLabel}'}',
      'Booking AhliPeduli: ${latestBooking == null ? 'Belum ada booking' : '${latestBooking.providerName} · ${latestBooking.status.label}'}',
      'Aktivitas PeduliDarurat: Belum ada aktivitas darurat aktif.',
      'Catatan keluhan: $lastLog',
      'Rekomendasi umum: lanjutkan pemantauan rutin, pastikan obat tidak habis, dan gunakan PeduliKonsul untuk pertanyaan medis.',
      'Tanggal dibuat: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
    ].join('\n');
  }

  static Future<Uint8List> _buildPdf(
    ElderProfile profile,
    CaregiverProfile pendamping,
    PeduliObatState obatState,
    PeduliAntarState antarState,
    AhliPeduliBookingState bookingState,
  ) async {
    final doc = pw.Document();
    final latestBp = bloodPressureHistory.isEmpty ? null : bloodPressureHistory.last;
    final latestSugar = bloodSugarHistory.isEmpty ? null : bloodSugarHistory.last;
    final latestOrder = antarState.latestOrder;
    final latestBooking = bookingState.bookings.isEmpty ? null : bookingState.bookings.first;

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Text('Ringkasan Kesehatan PeduliKeluarga', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Text('Tanggal dibuat: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
          pw.SizedBox(height: 20),
          _pdfSection('Identitas Lansia', [
            'Nama: ${profile.displayName}',
            'Umur: ${profile.displayAge}',
            'Jenis kelamin: ${profile.displayGender}',
            'Nomor telepon: ${profile.displayPhone}',
            'Alamat: ${profile.displayAddress}',
            'Riwayat penyakit: ${profile.medicalHistoryLabel}',
          ]),
          _pdfSection('Identitas Pendamping', [
            'Nama: ${pendamping.displayName}',
            'Nomor telepon: ${pendamping.displayPhone}',
            'Hubungan: ${pendamping.displayRelationship}',
            'Kode koneksi: ${pendamping.displayConnectionCode}',
            'Tanggal terhubung: ${pendamping.displayConnectedAt}',
          ]),
          _pdfSection('Ringkasan Tekanan Darah', [
            'Terakhir: ${latestBp?.readingLabel ?? 'Belum ada'} mmHg',
            'Catatan: cek tekanan darah cukup 1 kali seminggu, kecuali dokter meminta lebih sering.',
          ]),
          _pdfSection('Ringkasan Gula Darah', [
            'Status: Stabil',
            'Terakhir: ${latestSugar == null ? 'Belum ada' : '${latestSugar.mgdl} mg/dL (${latestSugar.statusLabel})'}',
          ]),
          _pdfSection('Obat Aktif dan Kepatuhan', [
            ...obatState.medications.map((item) => '${item.name} ${item.dose} - ${item.instructions}'),
            'Kepatuhan minum obat: ${obatState.adherencePercent}%',
          ]),
          _pdfSection('Riwayat PeduliAntar', [
            latestOrder == null
                ? 'Belum ada pesanan'
                : '${latestOrder.medicineNames} - ${latestOrder.status.label} - Total ${latestOrder.totalPriceLabel}',
          ]),
          _pdfSection('Booking AhliPeduli', [
            latestBooking == null
                ? 'Belum ada booking'
                : '${latestBooking.providerName} - ${latestBooking.providerCategory} - ${latestBooking.status.label} - Slot ${latestBooking.selectedSlot}',
            latestBooking?.needsAmbulance == true ? 'Ambulans diminta: ${latestBooking!.ambulanceFeeLabel}' : 'Ambulans tidak diminta',
          ]),
          _pdfSection('Catatan Keluhan', healthLogs.map((item) => '${item.title}: ${item.note}').toList()),
          _pdfSection('Aktivitas PeduliDarurat', const ['Belum ada aktivitas darurat aktif.']),
          _pdfSection('Rekomendasi Tindak Lanjut Umum', const [
            'Lanjutkan pemantauan harian dan mingguan.',
            'Pastikan stok obat cukup sebelum habis.',
            'Gunakan PeduliKonsul atau AhliPeduli untuk keputusan medis.',
          ]),
        ],
      ),
    );

    return doc.save();
  }

  static pw.Widget _pdfSection(String title, List<String> lines) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 16),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 6),
          ...lines.map((line) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 3),
                child: pw.Text(line),
              )),
        ],
      ),
    );
  }
}

class _ExportOption extends StatelessWidget {
  const _ExportOption({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: PkColors.brand),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: PkColors.text2,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        const Icon(Icons.check_circle_rounded, size: 18, color: PkColors.green),
      ],
    );
  }
}
