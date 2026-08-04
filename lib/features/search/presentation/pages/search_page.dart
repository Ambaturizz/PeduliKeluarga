import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/pk_design.dart';
import '../../../../core/routing/app_routes.dart';

class _ServiceItem {
  final String title;
  final String desc;
  final String iconAsset;
  final String route;

  const _ServiceItem(this.title, this.desc, this.iconAsset, this.route);
}

final _allServices = [
  _ServiceItem('PeduliPantau', 'Pantau kesehatan rutin harian', 'assets/icons/pedulipantau.webp', AppRoutes.peduliPantauPath),
  _ServiceItem('PeduliAntar', 'Pesan antar jemput lansia', 'assets/icons/peduliantar.webp', AppRoutes.peduliAntarPath),
  _ServiceItem('PeduliKonsul', 'Konsultasi keluhan dengan ahli', 'assets/icons/pedulikonsul.webp', AppRoutes.peduliKonsulPath),
  _ServiceItem('PeduliChat', 'Chat dengan sesama', 'assets/icons/pedulichat.webp', AppRoutes.familyChatPath),
  _ServiceItem('PeduliObat', 'Beli dan pengingat obat', 'assets/icons/peduliobat.webp', AppRoutes.peduliObatPath),
  _ServiceItem('PeduliLiterasi', 'Artikel kesehatan lansia', 'assets/icons/peduliliterasi.webp', AppRoutes.peduliLiterasiPath),
  _ServiceItem('AhliPeduli', 'Daftar dokter dan spesialis', 'assets/icons/ahlipeduli.webp', AppRoutes.ahliPeduliPath),
  _ServiceItem('AIPeduli', 'Asisten kesehatan virtual AI', 'assets/icons/aipeduli.webp', AppRoutes.aiPeduliPath),
];

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  List<_ServiceItem> _results = _allServices;

  void _onSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() => _results = _allServices);
      return;
    }
    final q = query.toLowerCase();
    setState(() {
      _results = _allServices.where((s) {
        return s.title.toLowerCase().contains(q) || s.desc.toLowerCase().contains(q);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: PkColors.text),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: _onSearch,
          decoration: InputDecoration(
            hintText: 'Cari layanan aplikasi...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey.shade400),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: PkColors.line, height: 1),
        ),
      ),
      body: _results.isEmpty
          ? Center(
              child: Text(
                'Layanan tidak ditemukan.',
                style: TextStyle(color: Colors.grey.shade500),
              ),
            )
          : ListView.separated(
              itemCount: _results.length,
              separatorBuilder: (context, index) => Divider(height: 1, color: PkColors.line),
              itemBuilder: (context, index) {
                final s = _results[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  leading: Image.asset(s.iconAsset, width: 40, height: 40),
                  title: Text(s.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(s.desc, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  trailing: const Icon(Icons.chevron_right_rounded, color: PkColors.muted),
                  onTap: () => context.push(s.route),
                );
              },
            ),
    );
  }
}
