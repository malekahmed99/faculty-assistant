// Firestore Seed Data Script
// Run this file to populate Firestore with sample data
// Usage: dart lib/seed_data.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  await Firebase.initializeApp();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Seed Categories
  final categories = <Map<String, dynamic>>[
    {
      'id': 'cat_1',
      'name': 'Student Services',
      'iconName': 'assignment',
    },
    {
      'id': 'cat_2',
      'name': 'Departments',
      'iconName': 'school',
    },
    {
      'id': 'cat_3',
      'name': 'Labs',
      'iconName': 'computer',
    },
    {
      'id': 'cat_4',
      'name': 'Administration',
      'iconName': 'business',
    },
    {
      'id': 'cat_5',
      'name': 'Facilities',
      'iconName': 'restaurant',
    },
  ];

  // Seed Locations (10 locations)
  final locations = <Map<String, dynamic>>[
    {
      'id': 'loc_1',
      'name': 'Student Affairs Office',
      'description':
          'Handles student enrollment, ID cards, transcripts, and other student services.',
      'category': 'Student Services',
      'building': 'Main Building',
      'floor': 'Ground Floor',
      'lat': 30.0780,
      'lng': 31.2865,
      'openingHours': 'Sun–Thu 9:00 AM – 3:00 PM',
      'contactInfo': 'Phone: 0123456789 | Email: studentaffairs@sci.asu.edu.eg',
    },
    {
      'id': 'loc_2',
      'name': 'Main Library',
      'description':
          'The central library with vast collection of books, journals, and study spaces.',
      'category': 'Facilities',
      'building': 'Library Building',
      'floor': 'All Floors',
      'lat': 30.0785,
      'lng': 31.2870,
      'openingHours': 'Sun–Thu 8:00 AM – 8:00 PM',
      'contactInfo': 'Phone: 0123456790 | Email: library@sci.asu.edu.eg',
    },
    {
      'id': 'loc_3',
      'name': 'Chemistry Department',
      'description':
          'Department of Chemistry offering undergraduate and postgraduate programs.',
      'category': 'Departments',
      'building': 'Chemistry Building',
      'floor': '1st - 3rd Floor',
      'lat': 30.0775,
      'lng': 31.2855,
      'openingHours': 'Sun–Thu 8:00 AM – 4:00 PM',
      'contactInfo': 'Phone: 0123456791 | Email: chemistry@sci.asu.edu.eg',
    },
    {
      'id': 'loc_4',
      'name': 'Physics Department',
      'description':
          'Department of Physics with research labs and lecture halls.',
      'category': 'Departments',
      'building': 'Physics Building',
      'floor': '1st - 4th Floor',
      'lat': 30.0772,
      'lng': 31.2852,
      'openingHours': 'Sun–Thu 8:00 AM – 4:00 PM',
      'contactInfo': 'Phone: 0123456792 | Email: physics@sci.asu.edu.eg',
    },
    {
      'id': 'loc_5',
      'name': 'Computer Lab',
      'description':
          'Modern computer lab with high-performance workstations for students.',
      'category': 'Labs',
      'building': 'Main Building',
      'floor': '2nd Floor',
      'lat': 30.0780,
      'lng': 31.2860,
      'openingHours': 'Sun–Thu 9:00 AM – 5:00 PM',
      'contactInfo': 'Phone: 0123456793 | Email: complab@sci.asu.edu.eg',
    },
    {
      'id': 'loc_6',
      'name': 'Registration Office',
      'description':
          'Handles course registration, schedules, and academic records.',
      'category': 'Student Services',
      'building': 'Main Building',
      'floor': '1st Floor',
      'lat': 30.0781,
      'lng': 31.2863,
      'openingHours': 'Sun–Thu 9:00 AM – 3:00 PM',
      'contactInfo': 'Phone: 0123456794 | Email: registration@sci.asu.edu.eg',
    },
    {
      'id': 'loc_7',
      'name': 'Administration Building',
      'description':
          'Central administration offices including Dean\'s office and finance.',
      'category': 'Administration',
      'building': 'Administration Building',
      'floor': 'All Floors',
      'lat': 30.0778,
      'lng': 31.2859,
      'openingHours': 'Sun–Thu 8:00 AM – 3:00 PM',
      'contactInfo': 'Phone: 0123456795 | Email: admin@sci.asu.edu.eg',
    },
    {
      'id': 'loc_8',
      'name': 'Cafeteria',
      'description': 'Main cafeteria offering variety of food and beverages.',
      'category': 'Facilities',
      'building': 'Student Center',
      'floor': 'Ground Floor',
      'lat': 30.0783,
      'lng': 31.2867,
      'openingHours': 'Daily 7:00 AM – 10:00 PM',
      'contactInfo': 'Phone: 0123456796',
    },
    {
      'id': 'loc_9',
      'name': 'Auditorium',
      'description': 'Large auditorium for conferences, seminars, and events.',
      'category': 'Facilities',
      'building': 'Main Building',
      'floor': 'Basement',
      'lat': 30.0779,
      'lng': 31.2861,
      'openingHours': 'Sun–Thu 9:00 AM – 6:00 PM',
      'contactInfo': 'Phone: 0123456797 | Email: auditorium@sci.asu.edu.eg',
    },
    {
      'id': 'loc_10',
      'name': 'IT Support Office',
      'description':
          'Technical support for students and staff, hardware and software issues.',
      'category': 'Administration',
      'building': 'Main Building',
      'floor': 'Ground Floor',
      'lat': 30.0780,
      'lng': 31.2864,
      'openingHours': 'Sun–Thu 9:00 AM – 5:00 PM',
      'contactInfo': 'Phone: 0123456798 | Email: itsupport@sci.asu.edu.eg',
    },
  ];

  print('Starting seed process...');

  // Clear and seed categories
  print('Seeding categories...');
  for (final category in categories) {
    await firestore.collection('categories').doc(category['id']).set(category);
    print('Added category: ${category['name']}');
  }

  // Clear and seed locations
  print('Seeding locations...');
  for (final location in locations) {
    await firestore.collection('locations').doc(location['id']).set(location);
    print('Added location: ${location['name']}');
  }

  print('Seed completed successfully!');
}
