import 'package:ai_campus_guide/providers/locations_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category_model.dart';
import '../services/categories_service.dart';

// Categories service provider
final categoriesServiceProvider = Provider<CategoriesService>((ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return CategoriesService(firebaseService);
});

// // Firebase service provider (re-exported)
// final firebaseServiceProvider = Provider<FirebaseService>((ref) {
//   return FirebaseService.instance;
// });

// All categories provider
final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final service = ref.watch(categoriesServiceProvider);
  return await service.getAllCategories();
});

// Selected category provider
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

// Category by ID provider
final categoryByIdProvider =
    FutureProvider.family<CategoryModel?, String>((ref, id) async {
  final service = ref.watch(categoriesServiceProvider);
  return await service.getCategoryById(id);
});
