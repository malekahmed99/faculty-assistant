import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/locations_provider.dart';
import '../../services/maps_service.dart';
import '../widgets/primary_button.dart';
import 'map_screen.dart';
import 'ai_assistant_screen.dart';

class LocationDetailsScreen extends ConsumerWidget {
  final String locationId;
  final String? prefilledQuestion;

  const LocationDetailsScreen({
    super.key,
    required this.locationId,
    this.prefilledQuestion,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationAsync = ref.watch(locationByIdProvider(locationId));
    final mapsService = MapsService();

    return Scaffold(
      body: locationAsync.when(
        data: (location) {
          if (location == null) {
            return const Center(child: Text('Location not found'));
          }

          return CustomScrollView(
            slivers: [
              // App Bar with hero image
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    location.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        _getCategoryIcon(location.category),
                        size: 80,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          location.category,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Description
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        location.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Details section
                      Text(
                        'Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Info cards
                      _buildInfoCard(
                        context,
                        icon: Icons.business,
                        title: 'Building',
                        value: location.building,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        context,
                        icon: Icons.layers,
                        title: 'Floor',
                        value: location.floor,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        context,
                        icon: Icons.access_time,
                        title: 'Opening Hours',
                        value: location.openingHours.isNotEmpty
                            ? location.openingHours
                            : 'Not available',
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        context,
                        icon: Icons.contact_phone,
                        title: 'Contact',
                        value: location.contactInfo.isNotEmpty
                            ? location.contactInfo
                            : 'Not available',
                      ),

                      const SizedBox(height: 12),
                      _buildInfoCard(
                        context,
                        icon: Icons.location_on,
                        title: 'Coordinates',
                        value: '${location.lat.toStringAsFixed(4)}, ${location.lng.toStringAsFixed(4)}',
                      ),

                      const SizedBox(height: 32),

                      // Action buttons
                      PrimaryButton(
                        text: 'View on Map',
                        icon: Icons.map,
                        isExpanded: true,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MapScreen(focusLocation: location),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 12),

                      SecondaryButton(
                        text: 'Get Directions',
                        icon: Icons.directions,
                        isExpanded: true,
                        onPressed: () async {
                          await mapsService.openGoogleMapsDirections(location);
                        },
                      ),

                      const SizedBox(height: 12),

                      SecondaryButton(
                        text: 'Ask AI about this place',
                        icon: Icons.smart_toy,
                        isExpanded: true,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AiAssistantScreen(
                                initialMessage: 'Tell me about ${location.name}',
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'student services':
        return Icons.assignment;
      case 'departments':
        return Icons.school;
      case 'labs':
        return Icons.computer;
      case 'administration':
        return Icons.business;
      case 'facilities':
        return Icons.restaurant;
      default:
        return Icons.location_on;
    }
  }
}

