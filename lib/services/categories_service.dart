import '../models/category_model.dart';
import 'firebase_service.dart';

class CategoriesService {
  final FirebaseService _firebaseService;
  static const String _collection = 'categories';

  CategoriesService(this._firebaseService);

  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final docs = await _firebaseService.getDocuments(_collection);
      return docs
          .map((doc) =>
              CategoryModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return _getDefaultCategories();
    }
  }

  Future<CategoryModel?> getCategoryById(String id) async {
    try {
      final doc = await _firebaseService.getDocument(_collection, id);
      if (doc.exists) {
        return CategoryModel.fromMap(
            doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('Error fetching category: $e');
      return null;
    }
  }

  Future<void> seedCategories(List<CategoryModel> categories) async {
    try {
      for (final category in categories) {
        await _firebaseService.addDocument(
            _collection, category.id, category.toMap());
      }
      print('Categories seeded successfully');
    } catch (e) {
      print('Error seeding categories: $e');
    }
  }

  List<CategoryModel> _getDefaultCategories() {
    return [
      CategoryModel(
          id: 'cat_1', name: 'Student Services', iconName: 'assignment'),
      CategoryModel(id: 'cat_2', name: 'Departments', iconName: 'school'),
      CategoryModel(id: 'cat_3', name: 'Labs', iconName: 'computer'),
      CategoryModel(id: 'cat_4', name: 'Administration', iconName: 'business'),
      CategoryModel(id: 'cat_5', name: 'Facilities', iconName: 'restaurant'),
    ];
  }
}
