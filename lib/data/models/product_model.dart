/// Product model representing an item in the store
/// Contains all product information including pricing, images, and details
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice; // For discounted items
  final String imageUrl;
  final List<String> images; // Multiple product images
  final String category;
  final String brand;
  final double rating;
  final int reviewCount;
  final bool isInStock;
  final int stockQuantity;
  final List<String>? sizes;
  final List<String>? colors;
  final bool isFeatured;
  final bool isNewArrival;
  final bool isBestSeller;
  final Map<String, String>? specifications;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    required this.images,
    required this.category,
    required this.brand,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isInStock = true,
    this.stockQuantity = 0,
    this.sizes,
    this.colors,
    this.isFeatured = false,
    this.isNewArrival = false,
    this.isBestSeller = false,
    this.specifications,
  });

  /// Calculate discount percentage
  int? get discountPercentage {
    if (originalPrice != null && originalPrice! > price) {
      return (((originalPrice! - price) / originalPrice!) * 100).round();
    }
    return null;
  }

  /// Check if product has discount
  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  /// Create a copy with modified fields
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    String? imageUrl,
    List<String>? images,
    String? category,
    String? brand,
    double? rating,
    int? reviewCount,
    bool? isInStock,
    int? stockQuantity,
    List<String>? sizes,
    List<String>? colors,
    bool? isFeatured,
    bool? isNewArrival,
    bool? isBestSeller,
    Map<String, String>? specifications,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isInStock: isInStock ?? this.isInStock,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
      isFeatured: isFeatured ?? this.isFeatured,
      isNewArrival: isNewArrival ?? this.isNewArrival,
      isBestSeller: isBestSeller ?? this.isBestSeller,
      specifications: specifications ?? this.specifications,
    );
  }

  /// Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrl': imageUrl,
      'images': images,
      'category': category,
      'brand': brand,
      'rating': rating,
      'reviewCount': reviewCount,
      'isInStock': isInStock,
      'stockQuantity': stockQuantity,
      'sizes': sizes,
      'colors': colors,
      'isFeatured': isFeatured,
      'isNewArrival': isNewArrival,
      'isBestSeller': isBestSeller,
      'specifications': specifications,
    };
  }

  /// Create from Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      originalPrice: map['originalPrice']?.toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      category: map['category'] ?? '',
      brand: map['brand'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      isInStock: map['isInStock'] ?? true,
      stockQuantity: map['stockQuantity'] ?? 0,
      sizes: map['sizes'] != null ? List<String>.from(map['sizes']) : null,
      colors: map['colors'] != null ? List<String>.from(map['colors']) : null,
      isFeatured: map['isFeatured'] ?? false,
      isNewArrival: map['isNewArrival'] ?? false,
      isBestSeller: map['isBestSeller'] ?? false,
      specifications: map['specifications'] != null
          ? Map<String, String>.from(map['specifications'])
          : null,
    );
  }
}
