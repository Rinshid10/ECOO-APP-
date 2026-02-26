import 'product_model.dart';

/// Cart item model representing a product in the shopping cart
/// Contains the product and additional cart-specific information
class CartItem {
  final Product product;
  final int quantity;
  final String? selectedSize;
  final String? selectedColor;
  final DateTime addedAt;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedSize,
    this.selectedColor,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  /// Calculate total price for this cart item
  double get totalPrice => product.price * quantity;

  /// Calculate total original price (for discount display)
  double? get totalOriginalPrice {
    if (product.originalPrice != null) {
      return product.originalPrice! * quantity;
    }
    return null;
  }

  /// Calculate savings amount
  double get savings {
    if (product.originalPrice != null) {
      return (product.originalPrice! - product.price) * quantity;
    }
    return 0;
  }

  /// Create a copy with modified quantity
  CartItem copyWith({
    Product? product,
    int? quantity,
    String? selectedSize,
    String? selectedColor,
    DateTime? addedAt,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  /// Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
      'selectedSize': selectedSize,
      'selectedColor': selectedColor,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  /// Create from Map
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: Product.fromMap(map['product']),
      quantity: map['quantity'] ?? 1,
      selectedSize: map['selectedSize'],
      selectedColor: map['selectedColor'],
      addedAt: map['addedAt'] != null ? DateTime.parse(map['addedAt']) : null,
    );
  }
}
