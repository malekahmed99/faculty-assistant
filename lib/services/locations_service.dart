import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/location_model.dart';
import 'firebase_service.dart';

class LocationsService {
  final FirebaseService _firebaseService;
  static const String _collection = 'locations';

  LocationsService(this._firebaseService);

  Future<List<LocationModel>> getAllLocations() async {
    try {
      final docs = await _firebaseService.getDocuments(_collection);
      return docs
          .map((doc) =>
              LocationModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching locations: $e');
      return [];
    }
  }

  Future<LocationModel?> getLocationById(String id) async {
    try {
      final doc = await _firebaseService.getDocument(_collection, id);
      if (doc.exists) {
        return LocationModel.fromMap(
            doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('Error fetching location: $e');
      return null;
    }
  }

  Future<List<LocationModel>> getLocationsByCategory(String category) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(_collection)
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs
          .map((doc) =>
              LocationModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching locations by category: $e');
      return [];
    }
  }

  Future<List<LocationModel>> searchLocations(String query) async {
    try {
      final allLocations = await getAllLocations();
      if (query.isEmpty) return allLocations;

      final lowerQuery = query.toLowerCase();
      return allLocations.where((location) {
        return location.name.toLowerCase().contains(lowerQuery) ||
            location.description.toLowerCase().contains(lowerQuery) ||
            location.category.toLowerCase().contains(lowerQuery) ||
            location.building.toLowerCase().contains(lowerQuery);
      }).toList();
    } catch (e) {
      print('Error searching locations: $e');
      return [];
    }
  }

  Future<List<LocationModel>> getFeaturedLocations({int limit = 5}) async {
    try {
      final allLocations = await getAllLocations();
      return allLocations.take(limit).toList();
    } catch (e) {
      print('Error fetching featured locations: $e');
      return [];
    }
  }

  Future<void> seedLocations(List<LocationModel> locations) async {
    try {
      for (final location in locations) {
        await _firebaseService.addDocument(
            _collection, location.id, location.toMap());
      }
      print('Locations seeded successfully');
    } catch (e) {
      print('Error seeding locations: $e');
    }
  }
}
