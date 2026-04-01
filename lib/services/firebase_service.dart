import 'package:ai_campus_guide/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseApp? _app;
  static FirebaseFirestore? _firestore;

  FirebaseService._();

  static FirebaseService get instance {
    _instance ??= FirebaseService._();
    return _instance!;
  }

  FirebaseApp get app => _app!;
  FirebaseFirestore get firestore => _firestore!;

  static Future<void> initialize() async {
    if (_app != null) return;

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _app = Firebase.app();
      _firestore = FirebaseFirestore.instance;

      if (kDebugMode) {
        print('Firebase initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Firebase initialization error: $e');
      }
      rethrow;
    }
  }

  static Future<void> setPersistence() async {
    if (_firestore != null) {
      // Persistence is enabled by default in FirebaseFirestore
      // Settings can be configured if needed
    }
  }

  CollectionReference getCollection(String collectionName) {
    return _firestore!.collection(collectionName);
  }

  Future<DocumentSnapshot> getDocument(String collection, String docId) async {
    return await _firestore!.collection(collection).doc(docId).get();
  }

  Future<List<QueryDocumentSnapshot>> getDocuments(String collection) async {
    final snapshot = await _firestore!.collection(collection).get();
    return snapshot.docs;
  }

  Future<void> addDocument(
      String collection, String docId, Map<String, dynamic> data) async {
    await _firestore!.collection(collection).doc(docId).set(data);
  }

  Future<void> updateDocument(
      String collection, String docId, Map<String, dynamic> data) async {
    await _firestore!.collection(collection).doc(docId).update(data);
  }

  Future<void> deleteDocument(String collection, String docId) async {
    await _firestore!.collection(collection).doc(docId).delete();
  }

  Stream<QuerySnapshot> streamCollection(String collection) {
    return _firestore!.collection(collection).snapshots();
  }
}
