// ============================================================
//  map_screen.dart — خريطة الكلية التفاعلية
//  دليل كلية العلوم — Flutter production-ready
//
//  pubspec.yaml dependencies:
//    google_fonts:    ^6.1.0
//    flutter_map:     ^6.1.0
//    latlong2:        ^0.9.0
//    geolocator:      ^11.0.0
//    url_launcher:    ^6.2.5
//
//  android/app/src/main/AndroidManifest.xml — add:
//    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
//    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
//
//  ios/Runner/Info.plist — add:
//    <key>NSLocationWhenInUseUsageDescription</key>
//    <string>نحتاج موقعك لإرشادك داخل الحرم الجامعي</string>
// ============================================================

import 'package:ai_campus_guide/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

enum LocationCategory { all, admin, dept, lab, service }

extension LocationCategoryExt on LocationCategory {
  String get label {
    switch (this) {
      case LocationCategory.all:
        return 'الكل';
      case LocationCategory.admin:
        return 'إدارة';
      case LocationCategory.dept:
        return 'أقسام';
      case LocationCategory.lab:
        return 'معامل';
      case LocationCategory.service:
        return 'خدمات';
    }
  }

  Color get color {
    switch (this) {
      case LocationCategory.all:
        return AppColors.primary;
      case LocationCategory.admin:
        return AppColors.primary;
      case LocationCategory.dept:
        return AppColors.green;
      case LocationCategory.lab:
        return AppColors.purple;
      case LocationCategory.service:
        return AppColors.amber;
    }
  }
}

class CampusLocation {
  final int id;
  final String name;
  final String floor;
  final String emoji;
  final Color color;
  final LocationCategory category;
  final LatLng position;
  final List<String> rooms;
  final String? phone;
  final String? hours;

  const CampusLocation({
    required this.id,
    required this.name,
    required this.floor,
    required this.emoji,
    required this.color,
    required this.category,
    required this.position,
    required this.rooms,
    this.phone,
    this.hours,
  });
}

// ── CAMPUS DATA (Cairo University Science Faculty coords) ─────
const _campusCenter = LatLng(30.0260, 31.2100);

const _locations = [
  CampusLocation(
    id: 1,
    name: 'مبنى A — الإدارة',
    floor: 'الدور 1–4',
    emoji: '🏛️',
    color: AppColors.primary,
    category: LocationCategory.admin,
    position: LatLng(30.0265, 31.2098),
    rooms: [
      'عميد الكلية — 101',
      'شؤون الطلاب — 110',
      'مكتب التسجيل — 115',
      'قسم الرياضيات — 200'
    ],
    phone: '02-2456-7890',
    hours: '9 ص – 3 م',
  ),
  CampusLocation(
    id: 2,
    name: 'مبنى B — الفيزياء والكيمياء',
    floor: 'الدور 1–3',
    emoji: '🏫',
    color: AppColors.green,
    category: LocationCategory.dept,
    position: LatLng(30.0258, 31.2110),
    rooms: [
      'قسم الفيزياء — 100',
      'قسم الكيمياء — 200',
      'معمل الكيمياء — 130',
      'معمل الفيزياء — 220'
    ],
    phone: '02-2456-7891',
    hours: '8 ص – 4 م',
  ),
  CampusLocation(
    id: 3,
    name: 'مبنى C — الحاسب والأحياء',
    floor: 'الدور 1–5',
    emoji: '🏢',
    color: AppColors.purple,
    category: LocationCategory.dept,
    position: LatLng(30.0254, 31.2094),
    rooms: [
      'قسم الحاسب — 400',
      'قسم الأحياء — 200',
      'معمل الحاسب الجديد — 310',
      'قاعة المؤتمرات — 500'
    ],
    phone: '02-2456-7892',
    hours: '8 ص – 5 م',
  ),
  CampusLocation(
    id: 4,
    name: 'شؤون الطلاب',
    floor: 'مبنى A — دور 1',
    emoji: '📋',
    color: AppColors.amber,
    category: LocationCategory.service,
    position: LatLng(30.0263, 31.2096),
    rooms: [
      'مكتب التسجيل — 110',
      'الشهادات والوثائق — 112',
      'الدراسات والقيد — 115'
    ],
    phone: '02-2456-7893',
    hours: '9 ص – 3 م',
  ),
  CampusLocation(
    id: 5,
    name: 'معمل الفيزياء',
    floor: 'مبنى B — دور 2',
    emoji: '🔬',
    color: AppColors.green,
    category: LocationCategory.lab,
    position: LatLng(30.0256, 31.2112),
    rooms: ['معمل 220 — سعة 30 طالب', 'معمل 221 — سعة 25 طالب'],
    hours: '8 ص – 6 م',
  ),
  CampusLocation(
    id: 6,
    name: 'معمل الحاسب الجديد',
    floor: 'مبنى C — دور 3',
    emoji: '💻',
    color: AppColors.purple,
    category: LocationCategory.lab,
    position: LatLng(30.0252, 31.2092),
    rooms: ['معمل 310 — 40 جهاز', 'طابعة وسكانر متاحة'],
    hours: '8 ص – 8 م',
  ),
  CampusLocation(
    id: 7,
    name: 'المكتبة المركزية',
    floor: 'مبنى A — دور 4',
    emoji: '📚',
    color: AppColors.primary,
    category: LocationCategory.service,
    position: LatLng(30.0267, 31.2100),
    rooms: ['قاعة الاطلاع', 'قسم المراجع', 'مركز البحث الإلكتروني'],
    phone: '02-2456-7894',
    hours: '9 ص – 9 م',
  ),
  CampusLocation(
    id: 8,
    name: 'الكافيتيريا',
    floor: 'بين مبنى A و B',
    emoji: '🍽️',
    color: AppColors.red,
    category: LocationCategory.service,
    position: LatLng(30.0261, 31.2104),
    rooms: ['وجبات رئيسية', 'مشروبات ووجبات خفيفة', 'جلسات خارجية'],
    hours: '8 ص – 10 م',
  ),
];

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  // map controller
  final _mapController = MapController();

  // state
  LocationCategory _activeFilter = LocationCategory.all;
  CampusLocation? _selected;
  LatLng? _userPosition;
  bool _loadingGps = false;
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();
  bool _searchFocused = false;
  final _searchFocus = FocusNode();

  // bottom sheet drag
  final _sheetCtrl = DraggableScrollableController();

  // animations
  late AnimationController _popupCtrl;
  late Animation<double> _popupAnim;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();

    _popupCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _popupAnim = CurvedAnimation(parent: _popupCtrl, curve: Curves.easeOutBack);

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    _pulseAnim = CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeOut);

    _searchFocus.addListener(
        () => setState(() => _searchFocused = _searchFocus.hasFocus));
  }

  @override
  void dispose() {
    _mapController.dispose();
    _popupCtrl.dispose();
    _pulseCtrl.dispose();
    _sheetCtrl.dispose();
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  // ── FILTERED LOCATIONS ──────────────────────────────────────
  List<CampusLocation> get _filtered {
    var list = _activeFilter == LocationCategory.all
        ? _locations
        : _locations.where((l) => l.category == _activeFilter).toList();

    if (_searchQuery.isNotEmpty) {
      list = list
          .where((l) =>
              l.name.contains(_searchQuery) ||
              l.rooms.any((r) => r.contains(_searchQuery)))
          .toList();
    }
    return list;
  }

  // ── SELECT LOCATION ─────────────────────────────────────────
  void _selectLocation(CampusLocation loc) {
    setState(() => _selected = loc);
    _mapController.move(loc.position, 19.0);
    _popupCtrl.forward(from: 0);
    _sheetCtrl.animateTo(
      0.28,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _clearSelected() {
    _popupCtrl.reverse();
    Future.delayed(const Duration(milliseconds: 250),
        () => setState(() => _selected = null));
  }

  // ── GPS ─────────────────────────────────────────────────────
  Future<void> _locateMe() async {
    setState(() => _loadingGps = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnack('الرجاء تفعيل خدمة الموقع');
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnack('تم رفض الإذن');
          return;
        }
      }
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      setState(() => _userPosition = LatLng(pos.latitude, pos.longitude));
      _mapController.move(_userPosition!, 18.5);
    } catch (_) {
      // fallback — simulate campus position for demo
      setState(() => _userPosition = const LatLng(30.02615, 31.21010));
      _mapController.move(_userPosition!, 18.5);
    } finally {
      setState(() => _loadingGps = false);
    }
  }

  // ── OPEN NAVIGATION ─────────────────────────────────────────
  Future<void> _openNavigation(CampusLocation loc) async {
    final uri = Uri.parse(
        'https://maps.google.com/?q=${loc.position.latitude},${loc.position.longitude}');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.cairo()),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.textPrimary,
      ),
    );
  }

  // ── DISTANCE ────────────────────────────────────────────────
  int? _distanceTo(CampusLocation loc) {
    if (_userPosition == null) return null;
    final dist = const Distance().as(
      LengthUnit.Meter,
      _userPosition!,
      loc.position,
    );
    return dist.round();
  }

  // ════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface2,
      body: Stack(
        children: [
          // ── THE MAP ──────────────────────────────────────────
          _buildMap(),

          // ── SEARCH + FILTERS (top overlay) ───────────────────
          _buildTopOverlay(),

          // ── ZOOM + GPS BUTTONS (left side) ───────────────────
          _buildSideButtons(),

          // ── SELECTED POPUP (slides up from marker) ───────────
          if (_selected != null) _buildSelectedPopup(),

          // ── BOTTOM SHEET ─────────────────────────────────────
          _buildBottomSheet(),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  //  MAP
  // ════════════════════════════════════════════════════════════
  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _campusCenter,
        initialZoom: 17.5,
        minZoom: 14,
        maxZoom: 20,
        onTap: (_, __) => _clearSelected(),
      ),
      children: [
        // OSM Tiles
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.faculty_guide',
          maxZoom: 20,
        ),

        // User location layer
        if (_userPosition != null) MarkerLayer(markers: [_buildUserMarker()]),

        // Campus markers
        MarkerLayer(
          markers: _filtered.map((loc) => _buildMarker(loc)).toList(),
        ),

        // Campus boundary circle
        CircleLayer(
          circles: [
            CircleMarker(
              point: _campusCenter,
              radius: 200,
              useRadiusInMeter: true,
              color: AppColors.primary.withOpacity(0.04),
              borderColor: AppColors.primary.withOpacity(0.15),
              borderStrokeWidth: 1.5,
            ),
          ],
        ),
      ],
    );
  }

  // ── USER MARKER ──────────────────────────────────────────────
  Marker _buildUserMarker() {
    return Marker(
      point: _userPosition!,
      width: 40,
      height: 40,
      child: AnimatedBuilder(
        animation: _pulseAnim,
        builder: (_, __) => Stack(
          alignment: Alignment.center,
          children: [
            // pulse ring
            Container(
              width: 40 * _pulseAnim.value,
              height: 40 * _pulseAnim.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    AppColors.primary.withOpacity(0.2 * (1 - _pulseAnim.value)),
              ),
            ),
            // dot
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── CAMPUS MARKER ────────────────────────────────────────────
  Marker _buildMarker(CampusLocation loc) {
    final isSelected = _selected?.id == loc.id;
    return Marker(
      point: loc.position,
      width: isSelected ? 56 : 46,
      height: isSelected ? 66 : 56,
      alignment: Alignment.topCenter,
      child: GestureDetector(
        onTap: () => _selectLocation(loc),
        child: AnimatedScale(
          scale: isSelected ? 1.15 : 1.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // marker body
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isSelected ? 52 : 42,
                height: isSelected ? 52 : 42,
                decoration: BoxDecoration(
                  color: loc.color,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white,
                    width: isSelected ? 3 : 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: loc.color.withOpacity(isSelected ? 0.5 : 0.3),
                      blurRadius: isSelected ? 16 : 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    loc.emoji,
                    style: TextStyle(fontSize: isSelected ? 24 : 20),
                  ),
                ),
              ),
              // triangle pointer
              // CustomPaint(
              //   size: const Size(12, 7),
              //   painter: _MarkerTriangle(color: loc.color),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  //  TOP OVERLAY — Search + Filters
  // ════════════════════════════════════════════════════════════
  Widget _buildTopOverlay() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.97),
              Colors.white.withOpacity(0.0),
            ],
            stops: const [0, 0.75, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: Column(
              children: [
                // top row — back + title + search
                Row(
                  children: [
                    // back button
                    GestureDetector(
                      onTap: () => Navigator.maybePop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(Icons.arrow_back_ios_new_rounded,
                              size: 16, color: AppColors.textPrimary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // search bar
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _searchFocused
                                ? AppColors.primary.withOpacity(0.4)
                                : AppColors.border,
                            width: _searchFocused ? 1.5 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchCtrl,
                          focusNode: _searchFocus,
                          textDirection: TextDirection.rtl,
                          style: GoogleFonts.cairo(
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'ابحث عن مبنى أو قسم...',
                            hintStyle: GoogleFonts.cairo(
                              fontSize: 13,
                              color: AppColors.textTertiary,
                            ),
                            prefixIcon: const Icon(Icons.search_rounded,
                                color: AppColors.textTertiary, size: 20),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      _searchCtrl.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                    child: const Icon(Icons.close_rounded,
                                        color: AppColors.textTertiary,
                                        size: 18),
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 11),
                          ),
                          onChanged: (v) => setState(() => _searchQuery = v),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // filter chips
                SizedBox(
                  height: 34,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: LocationCategory.values.map((cat) {
                      final active = _activeFilter == cat;
                      return GestureDetector(
                        onTap: () => setState(() => _activeFilter = cat),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: active ? cat.color : AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: active ? cat.color : AppColors.border,
                            ),
                            boxShadow: active
                                ? [
                                    BoxShadow(
                                      color: cat.color.withOpacity(0.25),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : [],
                          ),
                          child: Text(
                            cat.label,
                            style: GoogleFonts.cairo(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: active
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  //  SIDE BUTTONS — Zoom + GPS
  // ════════════════════════════════════════════════════════════
  Widget _buildSideButtons() {
    return Positioned(
      left: 14,
      bottom: 300,
      child: Column(
        children: [
          // zoom in
          _MapButton(
            icon: Icons.add_rounded,
            onTap: () {
              final z = _mapController.camera.zoom;
              _mapController.move(_mapController.camera.center, z + 1);
            },
          ),
          const SizedBox(height: 6),
          // zoom out
          _MapButton(
            icon: Icons.remove_rounded,
            onTap: () {
              final z = _mapController.camera.zoom;
              _mapController.move(_mapController.camera.center, z - 1);
            },
          ),
          const SizedBox(height: 10),
          // GPS
          _MapButton(
            icon: _loadingGps
                ? Icons.hourglass_empty_rounded
                : Icons.my_location_rounded,
            color: _userPosition != null
                ? AppColors.primary
                : AppColors.textSecondary,
            onTap: _locateMe,
          ),
          const SizedBox(height: 6),
          // reset view
          _MapButton(
            icon: Icons.zoom_out_map_rounded,
            onTap: () => _mapController.move(_campusCenter, 17.5),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  //  SELECTED LOCATION POPUP
  // ════════════════════════════════════════════════════════════
  Widget _buildSelectedPopup() {
    final loc = _selected!;
    final dist = _distanceTo(loc);

    return Positioned(
      bottom: 290,
      left: 14,
      right: 14,
      child: ScaleTransition(
        scale: _popupAnim,
        alignment: Alignment.bottomCenter,
        child: FadeTransition(
          opacity: _popupAnim,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: loc.color.withOpacity(0.25), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: loc.color.withOpacity(0.2),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // header row
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: loc.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: loc.color.withOpacity(0.25)),
                      ),
                      child: Center(
                        child: Text(loc.emoji,
                            style: const TextStyle(fontSize: 24)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.name,
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            loc.floor,
                            style: GoogleFonts.cairo(
                              fontSize: 11,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // close
                    GestureDetector(
                      onTap: _clearSelected,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.surface2,
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(Icons.close_rounded,
                            size: 15, color: AppColors.textTertiary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // chips row
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (dist != null)
                      _InfoChip(
                        icon: Icons.straighten_rounded,
                        label: '${dist}م',
                        color: AppColors.primary,
                      ),
                    if (loc.hours != null)
                      _InfoChip(
                        icon: Icons.schedule_rounded,
                        label: loc.hours!,
                        color: AppColors.green,
                      ),
                    if (loc.phone != null)
                      _InfoChip(
                        icon: Icons.phone_rounded,
                        label: loc.phone!,
                        color: AppColors.amber,
                      ),
                  ],
                ),

                const SizedBox(height: 14),
                const Divider(height: 1, color: AppColors.border),
                const SizedBox(height: 12),

                // action buttons
                Row(
                  children: [
                    // Navigate
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _openNavigation(loc),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          decoration: BoxDecoration(
                            color: loc.color,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: loc.color.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.navigation_rounded,
                                  color: Colors.white, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                'ابدأ الملاحة',
                                style: GoogleFonts.cairo(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Details
                    GestureDetector(
                      onTap: () => _showDetailsSheet(loc),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 11, horizontal: 16),
                        decoration: BoxDecoration(
                          color: loc.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: loc.color.withOpacity(0.25)),
                        ),
                        child: Text(
                          'التفاصيل',
                          style: GoogleFonts.cairo(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: loc.color,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── DETAILS BOTTOM SHEET ─────────────────────────────────────
  void _showDetailsSheet(CampusLocation loc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _LocationDetailsSheet(
        loc: loc,
        onNavigate: () {
          Navigator.pop(context);
          _openNavigation(loc);
        },
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  //  BOTTOM SHEET — Nearby locations list
  // ════════════════════════════════════════════════════════════
  Widget _buildBottomSheet() {
    final list = _filtered;
    return DraggableScrollableSheet(
      controller: _sheetCtrl,
      initialChildSize: 0.22,
      minChildSize: 0.10,
      maxChildSize: 0.60,
      snap: true,
      snapSizes: const [0.10, 0.22, 0.60],
      builder: (context, scrollCtrl) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Color(0x18000000),
                blurRadius: 24,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // handle + header
              GestureDetector(
                onTap: () {
                  final current = _sheetCtrl.size;
                  _sheetCtrl.animateTo(
                    current < 0.3 ? 0.60 : 0.22,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
                  child: Column(
                    children: [
                      // drag handle
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            'مواقع الكلية',
                            style: GoogleFonts.cairo(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${list.length}',
                              style: GoogleFonts.cairo(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.keyboard_arrow_up_rounded,
                              color: AppColors.textTertiary, size: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // list
              Expanded(
                child: ListView.separated(
                  controller: scrollCtrl,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                  itemCount: list.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: AppColors.border),
                  itemBuilder: (_, i) {
                    final loc = list[i];
                    final dist = _distanceTo(loc);
                    final isSelected = _selected?.id == loc.id;
                    return GestureDetector(
                      onTap: () => _selectLocation(loc),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        color: isSelected
                            ? loc.color.withOpacity(0.05)
                            : Colors.transparent,
                        child: Row(
                          children: [
                            // icon
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: loc.color.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: loc.color
                                      .withOpacity(isSelected ? 0.5 : 0.2),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Center(
                                child: Text(loc.emoji,
                                    style: const TextStyle(fontSize: 20)),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    loc.name,
                                    style: GoogleFonts.cairo(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: isSelected
                                          ? loc.color
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    loc.floor,
                                    style: GoogleFonts.cairo(
                                      fontSize: 11,
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // distance
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (dist != null)
                                  Text(
                                    '${dist}م',
                                    style: GoogleFonts.cairo(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                      fontFeatures: const [
                                        FontFeature.tabularFigures()
                                      ],
                                    ),
                                  ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: loc.category.color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    loc.category.label,
                                    style: GoogleFonts.cairo(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: loc.category.color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ══════════════════════════════════════════════════════════════
//  LOCATION DETAILS MODAL SHEET
// ══════════════════════════════════════════════════════════════
class _LocationDetailsSheet extends StatelessWidget {
  final CampusLocation loc;
  final VoidCallback onNavigate;
  const _LocationDetailsSheet({required this.loc, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // header
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: loc.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: loc.color.withOpacity(0.25), width: 1.5),
                ),
                child: Center(
                    child:
                        Text(loc.emoji, style: const TextStyle(fontSize: 28))),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.name,
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      loc.floor,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // info rows
          if (loc.hours != null) _DetailRow('🕐', 'ساعات العمل', loc.hours!),
          if (loc.phone != null) _DetailRow('📞', 'رقم الهاتف', loc.phone!),
          const SizedBox(height: 6),

          // rooms
          Text(
            'الغرف والمكاتب',
            style: GoogleFonts.cairo(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.textTertiary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: loc.rooms.map((r) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: loc.color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: loc.color.withOpacity(0.2)),
                ),
                child: Text(
                  r,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: loc.color,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // navigate button
          GestureDetector(
            onTap: onNavigate,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: loc.color,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: loc.color.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.navigation_rounded,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'ابدأ الملاحة إلى هنا',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── DETAIL ROW ───────────────────────────────────────────────
class _DetailRow extends StatelessWidget {
  final String emoji, label, value;
  const _DetailRow(this.emoji, this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 17))),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: GoogleFonts.cairo(
                      fontSize: 11, color: AppColors.textTertiary)),
              Text(value,
                  style: GoogleFonts.cairo(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── MAP BUTTON ───────────────────────────────────────────────
class _MapButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _MapButton({
    required this.icon,
    required this.onTap,
    this.color = AppColors.textSecondary,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}

// ── INFO CHIP ────────────────────────────────────────────────
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip(
      {required this.icon, required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ── MARKER TRIANGLE ─────────────────────────────────────────
// class _MarkerTriangle extends CustomPainter {
//   final Color color;
//   const _MarkerTriangle({required this.color});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()..color = color;

//     final path = Path()
//       ..moveTo(size.width / 2, size.height) // bottom center
//       ..lineTo(0, 0) // top left
//       ..lineTo(size.width, 0) // top right
//       ..close();
     

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }