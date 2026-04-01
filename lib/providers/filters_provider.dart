import 'package:flutter_riverpod/flutter_riverpod.dart';

// Search query provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Map filter providers
final selectedMapCategoryProvider = StateProvider<String?>((ref) => null);
final mapZoomLevelProvider = StateProvider<double>((ref) => 17.0);

// Navigation state
final currentTabIndexProvider = StateProvider<int>((ref) => 0);

// AI chat initial message
final aiInitialMessageProvider = StateProvider<String?>((ref) => null);

