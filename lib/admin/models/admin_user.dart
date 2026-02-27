/// Admin user model
class AdminUser {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final AdminRole role;
  final DateTime createdAt;
  final bool isActive;

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.role,
    required this.createdAt,
    this.isActive = true,
  });
}

/// Admin roles enum
enum AdminRole {
  superAdmin,
  admin,
  manager,
  support,
}

/// Extension for admin role display
extension AdminRoleExtension on AdminRole {
  String get displayName {
    switch (this) {
      case AdminRole.superAdmin:
        return 'Super Admin';
      case AdminRole.admin:
        return 'Admin';
      case AdminRole.manager:
        return 'Manager';
      case AdminRole.support:
        return 'Support';
    }
  }

  String get description {
    switch (this) {
      case AdminRole.superAdmin:
        return 'Full access to all features';
      case AdminRole.admin:
        return 'Manage products, orders, and users';
      case AdminRole.manager:
        return 'Manage products and orders';
      case AdminRole.support:
        return 'View and respond to customer queries';
    }
  }
}
