import 'package:flutter/foundation.dart';
import '../data/models/user_model.dart';

/// User provider managing user state
/// Handles user profile and authentication state
class UserProvider with ChangeNotifier {
  // Current user (null if not logged in)
  User? _user;

  // Loading state
  bool _isLoading = false;

  /// Get current user
  User? get user => _user;

  /// Check if user is logged in
  bool get isLoggedIn => _user != null;

  /// Get loading state
  bool get isLoading => _isLoading;

  /// Initialize with a sample user for demo
  void initSampleUser() {
    _user = User(
      id: 'user_1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '+1 234 567 8900',
      avatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200',
      defaultAddress: Address(
        id: 'addr_1',
        name: 'Home',
        street: '123 Main Street',
        city: 'New York',
        state: 'NY',
        zipCode: '10001',
        country: 'USA',
        phone: '+1 234 567 8900',
        isDefault: true,
      ),
      addresses: [
        Address(
          id: 'addr_1',
          name: 'Home',
          street: '123 Main Street',
          city: 'New York',
          state: 'NY',
          zipCode: '10001',
          country: 'USA',
          phone: '+1 234 567 8900',
          isDefault: true,
        ),
        Address(
          id: 'addr_2',
          name: 'Office',
          street: '456 Business Ave',
          city: 'New York',
          state: 'NY',
          zipCode: '10002',
          country: 'USA',
          phone: '+1 234 567 8901',
          isDefault: false,
        ),
      ],
      createdAt: DateTime(2024, 1, 15),
    );
    notifyListeners();
  }

  /// Update user profile
  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
  }) {
    if (_user != null) {
      _user = _user!.copyWith(
        name: name ?? _user!.name,
        email: email ?? _user!.email,
        phone: phone ?? _user!.phone,
        avatarUrl: avatarUrl ?? _user!.avatarUrl,
      );
      notifyListeners();
    }
  }

  /// Add new address
  void addAddress(Address address) {
    if (_user != null) {
      final updatedAddresses = [...?_user!.addresses, address];
      _user = _user!.copyWith(addresses: updatedAddresses);
      notifyListeners();
    }
  }

  /// Update address
  void updateAddress(Address updatedAddress) {
    if (_user != null && _user!.addresses != null) {
      final updatedAddresses = _user!.addresses!.map((addr) {
        return addr.id == updatedAddress.id ? updatedAddress : addr;
      }).toList();
      _user = _user!.copyWith(addresses: updatedAddresses);
      notifyListeners();
    }
  }

  /// Remove address
  void removeAddress(String addressId) {
    if (_user != null && _user!.addresses != null) {
      final updatedAddresses =
          _user!.addresses!.where((addr) => addr.id != addressId).toList();
      _user = _user!.copyWith(addresses: updatedAddresses);
      notifyListeners();
    }
  }

  /// Set default address
  void setDefaultAddress(String addressId) {
    if (_user != null && _user!.addresses != null) {
      final newDefault = _user!.addresses!.firstWhere((a) => a.id == addressId);
      _user = _user!.copyWith(defaultAddress: newDefault);
      notifyListeners();
    }
  }

  /// Logout user
  void logout() {
    _user = null;
    notifyListeners();
  }
}
