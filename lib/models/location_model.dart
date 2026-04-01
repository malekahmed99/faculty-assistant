class LocationModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String building;
  final String floor;
  final double lat;
  final double lng;
  final String openingHours;
  final String contactInfo;

  LocationModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.building,
    required this.floor,
    required this.lat,
    required this.lng,
    required this.openingHours,
    required this.contactInfo,
  });

  factory LocationModel.fromMap(Map<String, dynamic> map, String id) {
    return LocationModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      building: map['building'] ?? '',
      floor: map['floor'] ?? '',
      lat: (map['lat'] ?? 0.0).toDouble(),
      lng: (map['lng'] ?? 0.0).toDouble(),
      openingHours: map['openingHours'] ?? '',
      contactInfo: map['contactInfo'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'building': building,
      'floor': floor,
      'lat': lat,
      'lng': lng,
      'openingHours': openingHours,
      'contactInfo': contactInfo,
    };
  }

  @override
  String toString() {
    return 'LocationModel(id: $id, name: $name, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

