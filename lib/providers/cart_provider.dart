import 'package:flutter/foundation.dart';
import '../data/models/product_model.dart';
import '../data/models/cart_item_model.dart';

/// Cart provider managing shopping cart state
/// Uses Provider for state management
class CartProvider with ChangeNotifier {
  // Private list of cart items
  final List<CartItem> _items = [];

  /// Get all cart items
  List<CartItem> get items => List.unmodifiable(_items);

  /// Get total number of items in cart
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  /// Get unique product count
  int get uniqueItemCount => _items.length;

  /// Check if cart is empty
  bool get isEmpty => _items.isEmpty;

  /// Check if cart is not empty
  bool get isNotEmpty => _items.isNotEmpty;

  /// Calculate subtotal (before tax and shipping)
  double get subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);

  /// Calculate total savings
  double get totalSavings => _items.fold(0, (sum, item) => sum + item.savings);

  /// Shipping cost (free above $50)
  double get shippingCost => subtotal >= 50 ? 0 : 5.99;

  /// Tax amount (assuming 8% tax)
  double get tax => subtotal * 0.08;

  /// Total amount including tax and shipping
  double get total => subtotal + tax + shippingCost;

  /// Check if a product is in the cart
  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  /// Get quantity of a specific product in cart
  int getProductQuantity(String productId) {
    try {
      final item = _items.firstWhere((item) => item.product.id == productId);
      return item.quantity;
    } catch (e) {
      return 0;
    }
  }

  /// Add a product to cart
  void addToCart(
    Product product, {
    int quantity = 1,
    String? selectedSize,
    String? selectedColor,
  }) {
    // Check if product already exists in cart
    final existingIndex = _items.indexWhere((item) =>
        item.product.id == product.id &&
        item.selectedSize == selectedSize &&
        item.selectedColor == selectedColor);

    if (existingIndex >= 0) {
      // Update quantity if product exists
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + quantity,
      );
    } else {
      // Add new item if product doesn't exist
      _items.add(CartItem(
        product: product,
        quantity: quantity,
        selectedSize: selectedSize,
        selectedColor: selectedColor,
      ));
    }
    notifyListeners();
  }

  /// Remove a product from cart
  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  /// Update quantity of a cart item
  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(quantity: quantity);
      notifyListeners();
    }
  }

  /// Increment quantity
  void incrementQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + 1,
      );
      notifyListeners();
    }
  }

  /// Decrement quantity
  void decrementQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index] = _items[index].copyWith(
          quantity: _items[index].quantity - 1,
        );
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  /// Clear entire cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  /// Get cart item by product ID
  CartItem? getCartItem(String productId) {
    try {
      return _items.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      return null;
    }
  }
}
