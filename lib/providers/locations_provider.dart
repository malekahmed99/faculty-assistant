import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/location_model.dart';
import '../services/locations_service.dart';
import '../services/firebase_service.dart';

// Firebase service provider
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService.instance;
});

// Locations service provider
final locationsServiceProvider = Provider<LocationsService>((ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return LocationsService(firebaseService);
});

// All locations provider
final locationsProvider = FutureProvider<List<LocationModel>>((ref) async {
  final service = ref.watch(locationsServiceProvider);
  return await service.getAllLocations();
});

// Featured locations provider
final featuredLocationsProvider = FutureProvider<List<LocationModel>>((ref) async {
  final service = ref.watch(locationsServiceProvider);
  return await service.getFeaturedLocations();
});

// Single location provider
final locationByIdProvider = FutureProvider.family<LocationModel?, String>((ref, id) async {
  final service = ref.watch(locationsServiceProvider);
  return await service.getLocationById(id);
});

// Locations by category provider
final locationsByCategoryProvider = FutureProvider.family<List<LocationModel>, String>((ref, category) async {
  final service = ref.watch(locationsServiceProvider);
  return await service.getLocationsByCategory(category);
});

// Search locations provider
final searchLocationsProvider = FutureProvider.family<List<LocationModel>, String>((ref, query) async {
  final service = ref.watch(locationsServiceProvider);
  return await service.searchLocations(query);
});

// Selected location for map focus
final selectedLocationProvider = StateProvider<LocationModel?>((ref) => null);

