import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/pk_design.dart';

enum AmbulansState { siaga, mencari, menuju }

class PeduliAmbulansPage extends StatefulWidget {
  const PeduliAmbulansPage({super.key});

  @override
  State<PeduliAmbulansPage> createState() => _PeduliAmbulansPageState();
}

class _PeduliAmbulansPageState extends State<PeduliAmbulansPage> with TickerProviderStateMixin {
  AmbulansState _currentState = AmbulansState.siaga;
  
  late AnimationController _pulseController;
  late AnimationController _holdController;
  late AnimationController _radarController;
  
  Timer? _simulateTimer;

  @override
  void initState() {
    super.initState();
    // Idle pulse animation for the SOS button
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Hold-to-call progress animation (2 seconds)
    _holdController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _holdController.addListener(() {
      setState(() {});
      if (_holdController.isCompleted && _currentState == AmbulansState.siaga) {
        _triggerEmergencyCall();
      }
    });

    // Radar scan animation for map
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _holdController.dispose();
    _radarController.dispose();
    _simulateTimer?.cancel();
    super.dispose();
  }

  void _triggerEmergencyCall() {
    setState(() {
      _currentState = AmbulansState.mencari;
    });
    _pulseController.stop();
    _radarController.repeat(); // Start radar

    _simulateTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _currentState = AmbulansState.menuju;
        });
        _radarController.stop();
      }
    });
  }

  void _cancelCall() {
    _simulateTimer?.cancel();
    _radarController.stop();
    _radarController.reset();
    _holdController.reset();
    _pulseController.repeat(reverse: true);
    setState(() {
      _currentState = AmbulansState.siaga;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PkColors.bg,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('PeduliAmbulans', style: TextStyle(color: PkColors.text, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: PkColors.text, size: 20),
              padding: EdgeInsets.zero,
              onPressed: () => context.pop(),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // 1. Map Background with Radar Animation
          _buildMapBackground(),
          
          // 2. Glassmorphism Top Banner
          _buildTopBanner(),

          // 3. Bottom Action Area
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              switchInCurve: Curves.easeOutBack,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(animation),
                  child: child,
                );
              },
              child: _buildBottomPanel(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapBackground() {
    // Jakarta center coordinate
    final centerLoc = const LatLng(-6.2088, 106.8456);
    
    return Positioned.fill(
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: _currentState == AmbulansState.siaga ? 0.6 : 1.0,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: centerLoc,
                initialZoom: 14.0,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c', 'd'],
                  userAgentPackageName: 'com.pedulikeluarga.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: centerLoc,
                      width: 60,
                      height: 60,
                      child: const Icon(Icons.location_on, color: PkColors.red, size: 48),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Radar animation when searching
          if (_currentState == AmbulansState.mencari || _currentState == AmbulansState.menuju)
            AnimatedBuilder(
              animation: _radarController,
              builder: (context, child) {
                return Container(
                  width: 300 * _radarController.value,
                  height: 300 * _radarController.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: PkColors.red.withValues(alpha: 1 - _radarController.value), width: 2),
                    color: PkColors.red.withValues(alpha: (1 - _radarController.value) * 0.1),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTopBanner() {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1.5),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5)),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: PkColors.redSoft,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.my_location_rounded, color: PkColors.red, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Jemput dari Lokasi Anda', style: TextStyle(color: PkColors.text2.withValues(alpha: 0.8), fontSize: 11, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          const Text(
                            'Jl. Merdeka Barat No. 12, Jakarta',
                            style: TextStyle(fontWeight: FontWeight.w800, color: PkColors.text, fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPanel() {
    if (_currentState == AmbulansState.siaga) return _buildSosState();
    if (_currentState == AmbulansState.mencari) return _buildSearchingState();
    return _buildArrivingState();
  }

  Widget _buildSosState() {
    return Container(
      key: const ValueKey('siaga'),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, -5)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Panggil Bantuan Medis',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: PkColors.text, letterSpacing: -0.5),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tekan dan TAHAN tombol di bawah untuk memanggil ambulans ke IGD terdekat.',
            textAlign: TextAlign.center,
            style: TextStyle(color: PkColors.text2, fontSize: 14, fontWeight: FontWeight.w500, height: 1.4),
          ),
          const SizedBox(height: 36),
          
          // Hold to Call Button with Progress Ring
          GestureDetector(
            onPanDown: (_) => _holdController.forward(),
            onPanEnd: (_) => _holdController.reverse(),
            onPanCancel: () => _holdController.reverse(),
            child: AnimatedBuilder(
              animation: Listenable.merge([_pulseController, _holdController]),
              builder: (context, child) {
                final double progress = _holdController.value;
                final double pulse = _pulseController.value;
                
                return SizedBox(
                  width: 220,
                  height: 220,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Pulse Background
                      Container(
                        width: 220 - (40 * progress),
                        height: 220 - (40 * progress),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: PkColors.redSoft,
                          boxShadow: [
                            BoxShadow(
                              color: PkColors.red.withValues(alpha: 0.3 * pulse),
                              blurRadius: 50 * pulse,
                              spreadRadius: 20 * pulse,
                            ),
                          ],
                        ),
                      ),
                      // Progress Ring
                      SizedBox(
                        width: 190,
                        height: 190,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 8,
                          backgroundColor: Colors.transparent,
                          valueColor: const AlwaysStoppedAnimation<Color>(PkColors.red),
                        ),
                      ),
                      // The Button itself (Neumorphic / 3D)
                      Transform.scale(
                        scale: 1.0 - (0.05 * progress), // Slight shrink on press
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF5252), Color(0xFFC62828)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8)),
                              BoxShadow(color: Colors.white.withValues(alpha: 0.4), blurRadius: 10, offset: const Offset(-4, -4)),
                            ],
                            border: Border.all(color: const Color(0xFFE53935), width: 2),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.sos_rounded, color: Colors.white, size: 64 + (10 * progress)),
                              const SizedBox(height: 4),
                              const Text(
                                'TAHAN',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchingState() {
    return Container(
      key: const ValueKey('mencari'),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, -5)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  backgroundColor: PkColors.redSoft,
                  valueColor: const AlwaysStoppedAnimation<Color>(PkColors.red),
                ),
              ),
              const Icon(Icons.airport_shuttle_rounded, color: PkColors.red, size: 40),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Menghubungi Ambulans...',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: PkColors.text, letterSpacing: -0.5),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sistem sedang menemukan armada terdekat yang siaga untuk menjemput Anda.',
            textAlign: TextAlign.center,
            style: TextStyle(color: PkColors.text2, height: 1.5),
          ),
          const SizedBox(height: 32),
          OutlinedButton(
            onPressed: _cancelCall,
            style: OutlinedButton.styleFrom(
              foregroundColor: PkColors.text2,
              side: BorderSide(color: Colors.grey.shade300, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
            child: const Text('Batalkan', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildArrivingState() {
    return Container(
      key: const ValueKey('menuju'),
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 30, offset: const Offset(0, -10)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header ETA
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ambulans Menuju Anda', style: TextStyle(color: PkColors.brand, fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 0.5)),
                    const SizedBox(height: 4),
                    const Text('Tiba dalam', style: TextStyle(color: PkColors.text2, fontSize: 16)),
                  ],
                ),
              ),
              const Text(
                '8',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 48, color: PkColors.text, height: 1.0, letterSpacing: -2),
              ),
              const SizedBox(width: 4),
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text('mnt', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: PkColors.muted)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Driver & Vehicle Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: PkColors.bg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage('assets/images/driver_profile.png'),
                      backgroundColor: Colors.white,
                    ),
                    Positioned(
                      bottom: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade200)),
                        child: const Icon(Icons.star_rounded, color: PkColors.amber, size: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Budi Santoso', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: PkColors.text)),
                      const SizedBox(height: 4),
                      Text('Ambulans Gawat Darurat', style: TextStyle(color: PkColors.text2.withValues(alpha: 0.8), fontSize: 12)),
                    ],
                  ),
                ),
                // License Plate
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4),
                    ],
                  ),
                  child: const Text(
                    'B 1234 XYZ',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Destination Info
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(color: PkColors.redSoft, shape: BoxShape.circle),
                child: const Icon(Icons.local_hospital_rounded, color: PkColors.red, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tujuan', style: TextStyle(color: PkColors.muted, fontSize: 12)),
                    const SizedBox(height: 2),
                    const Text('IGD RSUD Harapan Bersama', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: PkColors.text)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble_rounded),
                  label: const Text('Chat'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PkColors.brand,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.phone_rounded),
                  label: const Text('Telfon'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PkColors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: _cancelCall,
              style: TextButton.styleFrom(foregroundColor: PkColors.red, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
              child: const Text('Batalkan Panggilan', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
