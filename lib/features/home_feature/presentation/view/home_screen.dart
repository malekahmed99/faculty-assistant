import 'package:ai_campus_guide/features/home_feature/presentation/widgets/access_section.dart';
import 'package:ai_campus_guide/features/home_feature/presentation/widgets/home_header_section.dart.dart';
import 'package:ai_campus_guide/models/category_model.dart';
import 'package:ai_campus_guide/providers/categories_provider.dart';
import 'package:ai_campus_guide/providers/locations_provider.dart';
import 'package:ai_campus_guide/ui/screens/map_screen.dart';
import 'package:ai_campus_guide/ui/screens/search_results_screen.dart';
import 'package:ai_campus_guide/ui/screens/services_screen.dart';
import 'package:ai_campus_guide/ui/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _blinkAnimation =
        Tween<double>(begin: 1.0, end: 0.3).animate(_blinkController);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    _fadeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.trim().isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SearchResultsScreen(query: query.trim()),
        ),
      );
    }
  }

  void _onCategoryTap(CategoryModel category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ServicesScreen(initialCategory: category.name),
      ),
    );
  }

  void _openMap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MapScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final featuredLocationsAsync = ref.watch(featuredLocationsProvider);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: HomeHeaderSection(blinkAnim: _blinkAnimation),
          ),

          // Categories Section
          SliverToBoxAdapter(
            child: AccessSection(
              fadeAnimation: _fadeAnimation,
            ),
            //     Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const Text(
            //         'Browse by Category',
            //         style: TextStyle(
            //           fontSize: 18,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //       const SizedBox(height: 12),
            //       categoriesAsync.when(
            //         data: (categories) => SingleChildScrollView(
            //           scrollDirection: Axis.horizontal,
            //           child: Row(
            //             children: categories.map((category) {
            //               return Padding(
            //                 padding: const EdgeInsets.only(right: 8),
            //                 child: CategoryChip(
            //                   category: category,
            //                   onTap: () => _onCategoryTap(category),
            //                 ),
            //               );
            //             }).toList(),
            //           ),
            //         ),
            //         loading: () => const Center(
            //           child: CircularProgressIndicator(),
            //         ),
            //         error: (error, stack) => Text('Error: $error'),
            //       ),
            //     ],
            //   ),
            // ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Featured Locations Section
          // SliverToBoxAdapter(
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 16),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         const Text(
          //           'Featured Locations',
          //           style: TextStyle(
          //             fontSize: 18,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //         TextButton(
          //           onPressed: () => Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (_) => const ServicesScreen(),
          //             ),
          //           ),
          //           child: const Text('See All'),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          // // Featured Locations List
          // featuredLocationsAsync.when(
          //   data: (locations) => SliverList(
          //     delegate: SliverChildBuilderDelegate(
          //       (context, index) {
          //         final location = locations[index];
          //         return LocationCard(
          //           location: location,
          //           onTap: () => Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (_) => LocationDetailsScreen(
          //                 locationId: location.id,
          //               ),
          //             ),
          //           ),
          //         );
          //       },
          //       childCount: locations.length,
          //     ),
          //   ),
          //   loading: () => const SliverToBoxAdapter(
          //     child: Center(child: CircularProgressIndicator()),
          //   ),
          //   error: (error, stack) => SliverToBoxAdapter(
          //     child: Center(child: Text('Error: $error')),
          //   ),
          // ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Open Map Button
          SliverToBoxAdapter(
            child: PrimaryButton(
              text: 'Open Campus Map',
              icon: Icons.map,
              isExpanded: true,
              onPressed: _openMap,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}
