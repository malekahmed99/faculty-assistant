import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String iconName;

  CategoryModel({
    required this.id,
    required this.name,
    required this.iconName,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map, String id) {
    return CategoryModel(
      id: id,
      name: map['name'] ?? '',
      iconName: map['iconName'] ?? 'category',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'iconName': iconName,
    };
  }

  IconData get icon {
    switch (iconName.toLowerCase()) {
      case 'school':
        return Icons.school;
      case 'science':
        return Icons.science;
      case 'computer':
        return Icons.computer;
      case 'business':
        return Icons.business;
      case 'restaurant':
        return Icons.restaurant;
      case 'local_library':
        return Icons.local_library;
      case 'event_seat':
        return Icons.event_seat;
      case 'support_agent':
        return Icons.support_agent;
      case 'assignment':
        return Icons.assignment;
      case 'engineering':
        return Icons.engineering;
      default:
        return Icons.category;
    }
  }

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, iconName: $iconName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

