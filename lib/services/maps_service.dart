import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/location_model.dart';
import '../core/utils/constants.dart';

class MapsService {
  static const CameraPosition _defaultPosition = CameraPosition(
    target: LatLng(AppConstants.campusLat, AppConstants.campusLng),
    zoom: AppConstants.defaultZoom,
  );

  CameraPosition get defaultPosition => _defaultPosition;

  Set<Marker> generateMarkers(
    List<LocationModel> locations, {
    Function(LocationModel)? onMarkerTap,
  }) {
    return locations.map((location) {
      return Marker(
        markerId: MarkerId(location.id),
        position: LatLng(location.lat, location.lng),
        infoWindow: InfoWindow(
          title: location.name,
          snippet: location.building,
        ),
        onTap: () => onMarkerTap?.call(location),
      );
    }).toSet();
  }

  Future<void> openGoogleMapsDirections(LocationModel location) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${location.lat},${location.lng}'
    );
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> openLocationInMaps(LocationModel location) async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${location.lat},${location.lng}'
    );
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  CameraPosition createCameraPosition(LocationModel location, {double? zoom}) {
    return CameraPosition(
      target: LatLng(location.lat, location.lng),
      zoom: zoom ?? AppConstants.defaultZoom,
    );
  }

  CameraUpdate createCameraUpdate(LocationModel location, {double? zoom}) {
    return CameraUpdate.newLatLngZoom(
      LatLng(location.lat, location.lng),
      zoom ?? AppConstants.defaultZoom,
    );
  }

  double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    // Haversine formula for distance calculation
    const double earthRadius = 6371000; // meters
    final dLat = _toRadians(endLat - startLat);
    final dLng = _toRadians(endLng - startLng);
    
    final a = 
      _sin(dLat / 2) * _sin(dLat / 2) +
      _cos(_toRadians(startLat)) * _cos(_toRadians(endLat)) *
      _sin(dLng / 2) * _sin(dLng / 2);
    
    final c = 2 * _atan2(_sqrt(a), _sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degrees) => degrees * 3.141592653589793 / 180;
  double _sin(double x) => _sinTaylor(x);
  double _cos(double x) => _cosTaylor(x);
  double _sqrt(double x) => _sqrtNewton(x);
  double _atan2(double y, double x) => _atan2Taylor(y, x);

  double _sinTaylor(double x) {
    // Normalize to [-pi, pi]
    while (x > 3.141592653589793) {
      x -= 2 * 3.141592653589793;
    }
    while (x < -3.141592653589793) {
      x += 2 * 3.141592653589793;
    }
    
    double result = x;
    double term = x;
    for (int i = 1; i <= 10; i++) {
      term *= -x * x / ((2 * i) * (2 * i + 1));
      result += term;
    }
    return result;
  }

  double _cosTaylor(double x) {
    return _sinTaylor(x + 3.141592653589793 / 2);
  }

  double _sqrtNewton(double x) {
    if (x <= 0) return 0;
    double guess = x / 2;
    for (int i = 0; i < 20; i++) {
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }

  double _atan2Taylor(double y, double x) {
    if (x == 0) {
      if (y > 0) return 3.141592653589793 / 2;
      if (y < 0) return -3.141592653589793 / 2;
      return 0;
    }
    
    double atan = 0;
    if (x > 0) {
      atan = _atanTaylor(y / x);
    } else if (x < 0 && y >= 0) {
      atan = _atanTaylor(y / x) + 3.141592653589793;
    } else {
      atan = _atanTaylor(y / x) - 3.141592653589793;
    }
    return atan;
  }

  double _atanTaylor(double x) {
    if (x.abs() > 1) {
      return (3.141592653589793 / 2) * x.sign - _atanTaylor(1 / x);
    }
    
    double result = x;
    double term = x;
    for (int i = 1; i <= 20; i++) {
      term *= -x * x;
      result += term / (2 * i + 1);
    }
    return result;
  }
}

