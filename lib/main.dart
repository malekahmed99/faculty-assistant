import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'services/firebase_service.dart';
import 'models/location_model.dart';
import 'models/category_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await FirebaseService.initialize();
    await _seedSampleData();
  } catch (e) {
    debugPrint('Skipping Firebase init in preview mode: $e');
  }

  runApp(
    const ProviderScope(
      child: AICampusGuideApp(),
    ),
  );
}

Future<void> _seedSampleData() async {
  final firebaseService = FirebaseService.instance;

  // Check if locations exist
  final locations = await firebaseService.getDocuments('locations');
  if (locations.isEmpty) {
    await _seedLocations(firebaseService);
  }

  // Check if categories exist
  final categories = await firebaseService.getDocuments('categories');
  if (categories.isEmpty) {
    await _seedCategories(firebaseService);
  }
}

Future<void> _seedLocations(FirebaseService firebaseService) async {
  final sampleLocations = [
    LocationModel(
      id: 'loc_1',
      name: 'Student Affairs Office',
      description:
          'Handles student registration, ID cards, and various student services. The office provides support for academic and personal matters.',
      category: 'Student Services',
      building: 'Main Building',
      floor: 'Ground Floor',
      lat: 30.0780,
      lng: 31.2865,
      openingHours: 'Sun–Thu 9:00 AM – 3:00 PM',
      contactInfo: 'Phone: +2 022 1234 5678',
    ),
    LocationModel(
      id: 'loc_2',
      name: 'Main Library',
      description:
          'The central library with extensive collection of science books, journals, and study spaces. Open to all faculty students.',
      category: 'Facilities',
      building: 'Library Building',
      floor: 'All Floors',
      lat: 30.0785,
      lng: 31.2870,
      openingHours: 'Sun–Thu 8:00 AM – 8:00 PM',
      contactInfo: 'Email: library@sci.asu.edu.eg',
    ),
    LocationModel(
      id: 'loc_3',
      name: 'Chemistry Department',
      description:
          'Department of Chemistry offering undergraduate and graduate programs. Includes research laboratories and lecture halls.',
      category: 'Departments',
      building: 'Science Building A',
      floor: '1st & 2nd Floor',
      lat: 30.0775,
      lng: 31.2855,
      openingHours: 'Sun–Thu 8:00 AM – 4:00 PM',
      contactInfo: 'Phone: +2 022 1234 5679',
    ),
    LocationModel(
      id: 'loc_4',
      name: 'Physics Department',
      description:
          'Department of Physics with advanced research facilities and modern lecture halls. Home to renowned physics researchers.',
      category: 'Departments',
      building: 'Science Building B',
      floor: '1st & 2nd Floor',
      lat: 30.0772,
      lng: 31.2852,
      openingHours: 'Sun–Thu 8:00 AM – 4:00 PM',
      contactInfo: 'Email: physics@sci.asu.edu.eg',
    ),
    LocationModel(
      id: 'loc_5',
      name: 'Computer Lab',
      description:
          'Modern computer lab with 50+ workstations, high-speed internet, and software for programming and research.',
      category: 'Labs',
      building: 'IT Center',
      floor: '2nd Floor',
      lat: 30.0782,
      lng: 31.2862,
      openingHours: 'Sun–Thu 9:00 AM – 5:00 PM',
      contactInfo: 'Phone: +2 022 1234 5680',
    ),
    LocationModel(
      id: 'loc_6',
      name: 'Registration Office',
      description:
          'Handles course registration, enrollment verification, and academic records for all students.',
      category: 'Student Services',
      building: 'Main Building',
      floor: '1st Floor',
      lat: 30.0781,
      lng: 31.2864,
      openingHours: 'Sun–Thu 9:00 AM – 3:00 PM',
      contactInfo: 'Phone: +2 022 1234 5681',
    ),
    LocationModel(
      id: 'loc_7',
      name: 'Administration Building',
      description:
          'Houses the dean\'s office, finance department, and administrative offices for the Faculty of Science.',
      category: 'Administration',
      building: 'Administration Building',
      floor: 'All Floors',
      lat: 30.0788,
      lng: 31.2872,
      openingHours: 'Sun–Thu 8:00 AM – 3:00 PM',
      contactInfo: 'Phone: +2 022 1234 5682',
    ),
    LocationModel(
      id: 'loc_8',
      name: 'Cafeteria',
      description:
          'Main campus cafeteria offering a variety of Egyptian and international food options, snacks, and beverages.',
      category: 'Facilities',
      building: 'Student Center',
      floor: 'Ground Floor',
      lat: 30.0778,
      lng: 31.2858,
      openingHours: 'Daily 7:00 AM – 10:00 PM',
      contactInfo: 'Email: cafeteria@sci.asu.edu.eg',
    ),
    LocationModel(
      id: 'loc_9',
      name: 'Auditorium',
      description:
          'Large auditorium seating 500+ for conferences, lectures, and cultural events. Equipped with modern audio-visual systems.',
      category: 'Facilities',
      building: 'Conference Center',
      floor: 'Ground Floor',
      lat: 30.0790,
      lng: 31.2875,
      openingHours: 'Sun–Thu 9:00 AM – 9:00 PM',
      contactInfo: 'Phone: +2 022 1234 5683',
    ),
    LocationModel(
      id: 'loc_10',
      name: 'IT Support Office',
      description:
          'Technical support for students and staff. Handles WiFi issues, computer problems, and provides technical assistance.',
      category: 'Student Services',
      building: 'IT Center',
      floor: 'Ground Floor',
      lat: 30.0783,
      lng: 31.2863,
      openingHours: 'Sun–Thu 9:00 AM – 5:00 PM',
      contactInfo: 'Phone: +2 022 1234 5684 | Email: itsupport@sci.asu.edu.eg',
    ),
  ];

  for (final location in sampleLocations) {
    await firebaseService.addDocument(
        'locations', location.id, location.toMap());
  }
   print('Sample locations seeded');
}

Future<void> _seedCategories(FirebaseService firebaseService) async {
  final sampleCategories = [
    CategoryModel(
      id: 'cat_1',
      name: 'Student Services',
      iconName: 'assignment',
    ),
    CategoryModel(
      id: 'cat_2',
      name: 'Departments',
      iconName: 'school',
    ),
    CategoryModel(
      id: 'cat_3',
      name: 'Labs',
      iconName: 'computer',
    ),
    CategoryModel(
      id: 'cat_4',
      name: 'Administration',
      iconName: 'business',
    ),
    CategoryModel(
      id: 'cat_5',
      name: 'Facilities',
      iconName: 'restaurant',
    ),
  ];

  for (final category in sampleCategories) {
    await firebaseService.addDocument(
        'categories', category.id, category.toMap());
  }
  print('Sample categories seeded');
}
