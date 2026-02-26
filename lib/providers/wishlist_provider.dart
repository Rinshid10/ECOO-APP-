import 'package:flutter/foundation.dart';
import '../data/models/product_model.dart';

/// Wishlist provider managing wishlist state
/// Uses Provider for state management
class WishlistProvider with ChangeNotifier {
  // Private list of wishlist products
  final List<Product> _items = [];

  /// Get all wishlist items
  List<Product> get items => List.unmodifiable(_items);

  /// Get wishlist item count
  int get itemCount => _items.length;

  /// Check if wishlist is empty
  bool get isEmpty => _items.isEmpty;

  /// Check if wishlist is not empty
  bool get isNotEmpty => _items.isNotEmpty;

  /// Check if a product is in wishlist
  bool isInWishlist(String productId) {
    return _items.any((product) => product.id == productId);
  }

  /// Toggle product in wishlist (add if not exists, remove if exists)
  void toggleWishlist(Product product) {
    if (isInWishlist(product.id)) {
      removeFromWishlist(product.id);
    } else {
      addToWishlist(product);
    }
  }

  /// Add product to wishlist
  void addToWishlist(Product product) {
    if (!isInWishlist(product.id)) {
      _items.add(product);
      notifyListeners();
    }
  }

  /// Remove product from wishlist
  void removeFromWishlist(String productId) {
    _items.removeWhere((product) => product.id == productId);
    notifyListeners();
  }

  /// Clear entire wishlist
  void clearWishlist() {
    _items.clear();
    notifyListeners();
  }

  /// Get wishlist item by ID
  Product? getWishlistItem(String productId) {
    try {
      return _items.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null;
    }
  }
}
