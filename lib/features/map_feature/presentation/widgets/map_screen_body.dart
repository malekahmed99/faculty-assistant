import 'package:ai_campus_guide/core/theme/app_colors.dart';
import 'package:ai_campus_guide/features/map_feature/data/cubit/map_cubit.dart';
import 'package:ai_campus_guide/features/map_feature/data/cubit/map_state.dart';
import 'package:ai_campus_guide/features/map_feature/data/model/compus_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

class MapScreenBody extends StatelessWidget {
  const MapScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final mapController = MapController();

    return Scaffold(
      body: BlocBuilder<MapCubit, MapState>(
        builder: (context, state) {
          return Stack(
            children: [
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCenter: campusCenter,
                  initialZoom: 17,
                  onTap: (_, __) => context.read<MapCubit>().clearSelection(),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                    subdomains: ['a', 'b', 'c', 'd'],
                  ),
                  if (state.userLocation != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: state.userLocation!,
                          width: 40,
                          height: 40,
                          child: const Icon(Icons.my_location,
                              color: AppColors.primary),
                        )
                      ],
                    ),
                  MarkerLayer(
                    markers: state.filtered.map((loc) {
                      final isSelected = state.selected?.id == loc.id;

                      return Marker(
                        point: loc.position,
                        width: 50,
                        height: 50,
                        child: GestureDetector(
                          onTap: () =>
                              context.read<MapCubit>().selectLocation(loc),
                          child: Container(
                            decoration: BoxDecoration(
                              color: loc.color,
                              borderRadius: BorderRadius.circular(12),
                              border: isSelected
                                  ? Border.all(color: Colors.white, width: 3)
                                  : null,
                            ),
                            child: Center(child: Text(loc.emoji)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Positioned(
                top: 50,
                left: 16,
                right: 16,
                child: TextField(
                  onChanged: context.read<MapCubit>().search,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 100,
                right: 16,
                child: FloatingActionButton(
                  onPressed: () => context.read<MapCubit>().locateUser(),
                  child: const Icon(Icons.my_location),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
