import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../providers/locations_provider.dart';
import '../../providers/categories_provider.dart';
import '../../models/location_model.dart';
import '../../services/maps_service.dart';
import '../../core/utils/constants.dart';
import '../widgets/map_location_preview.dart';
import 'location_details_screen.dart';

class MapScreen extends ConsumerStatefulWidget {
  final LocationModel? focusLocation;

  const MapScreen({super.key, this.focusLocation});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _mapController;
  final MapsService _mapsService = MapsService();
  
  LocationModel? _selectedLocation;
  String? _selectedCategory;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    if (widget.focusLocation != null) {
      _selectedLocation = widget.focusLocation;
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationsAsync = ref.watch(locationsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Map'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Category filter
          PopupMenuButton<String?>(
            icon: const Icon(Icons.filter_list),
            onSelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: null,
                  child: Text('All Categories'),
                ),
                ...categoriesAsync.when(
                  data: (categories) => categories.map((cat) => PopupMenuItem(
                    value: cat.name,
                    child: Text(cat.name),
                  )).toList(),
                  loading: () => [],
                  error: (_, __) => [],
                ),
              ];
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Google Map
          locationsAsync.when(
            data: (locations) {
              final filteredLocations = _selectedCategory != null
                  ? locations.where((l) => l.category == _selectedCategory).toList()
                  : locations;

              _markers = _mapsService.generateMarkers(
                filteredLocations,
                onMarkerTap: (location) => _onMarkerTap(location),
              );

              return GoogleMap(
                initialCameraPosition: _mapsService.defaultPosition,
                markers: _markers,
                onMapCreated: (controller) {
                  _mapController = controller;
                  // Focus on location if provided
                  if (widget.focusLocation != null) {
                    _animateToLocation(widget.focusLocation!);
                  }
                },
                myLocationEnabled: false,
                zoomControlsEnabled: true,
                mapToolbarEnabled: false,
                buildingsEnabled: true,
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),

          // Category chips overlay
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: categoriesAsync.when(
              data: (categories) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All', null),
                    ...categories.map((cat) => _buildFilterChip(cat.name, cat.name)),
                  ],
                ),
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),

          // Selected location preview
          if (_selectedLocation != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: MapLocationPreview(
                location: _selectedLocation!,
                onViewDetails: () => _openLocationDetails(_selectedLocation!),
                onGetDirections: () => _openDirections(_selectedLocation!),
                onClose: () => setState(() => _selectedLocation = null),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = selected ? category : null;
          });
        },
        selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
        checkmarkColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void _onMarkerTap(LocationModel location) {
    setState(() {
      _selectedLocation = location;
    });
    _animateToLocation(location);
  }

  void _animateToLocation(LocationModel location) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(location.lat, location.lng),
        18,
      ),
    );
  }

  void _openLocationDetails(LocationModel location) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LocationDetailsScreen(locationId: location.id),
      ),
    );
  }

  void _openDirections(LocationModel location) async {
    await _mapsService.openGoogleMapsDirections(location);
  }
}

