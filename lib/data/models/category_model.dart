import 'package:flutter/material.dart';

/// Category model representing a product category
/// Contains category information including icon and color for UI
class Category {
  final String id;
  final String name;
  final String imageUrl;
  final IconData icon;
  final Color color;
  final int productCount;
  final String? description;
  final List<String>? subCategories;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.icon,
    required this.color,
    this.productCount = 0,
    this.description,
    this.subCategories,
  });

  /// Create a copy with modified fields
  Category copyWith({
    String? id,
    String? name,
    String? imageUrl,
    IconData? icon,
    Color? color,
    int? productCount,
    String? description,
    List<String>? subCategories,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      productCount: productCount ?? this.productCount,
      description: description ?? this.description,
      subCategories: subCategories ?? this.subCategories,
    );
  }
}
