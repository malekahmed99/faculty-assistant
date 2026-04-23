import 'package:ai_campus_guide/features/map_feature/data/model/compus_data.dart';
import 'package:latlong2/latlong.dart';

class MapState {
  final List<CampusLocation> locations;
  final CampusLocation? selected;
  final LocationCategory? filter;
  final LatLng? userLocation;
  final String search;
  final String? error;


  const MapState({
    required this.locations,
    this.selected,
    this.filter,
    this.userLocation,
    this.search = '', this.error,
  });

  List<CampusLocation> get filtered {
    return locations.where((l) {
      final matchFilter = filter == null || l.category == filter;
      final matchSearch = l.name.toLowerCase().contains(search.toLowerCase());
      return matchFilter && matchSearch;
    }).toList();
  }

  MapState copyWith({
    List<CampusLocation>? locations,
    CampusLocation? selected,
    LocationCategory? filter,
    LatLng? userLocation,
    String? search,
    String? error,
  }) {
    return MapState(
      locations: locations ?? this.locations,
      selected: selected ?? this.selected,
      filter: filter ?? this.filter,
      userLocation: userLocation ?? this.userLocation,
      search: search ?? this.search,
      error: this.error,
    );
  }
}






