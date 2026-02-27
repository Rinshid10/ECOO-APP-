import 'package:flutter/material.dart';
import '../models/admin_user.dart';
import '../models/dashboard_stats.dart';

/// Admin state management provider
class AdminProvider extends ChangeNotifier {
  AdminUser? _currentAdmin;
  DashboardStats? _dashboardStats;
  bool _isLoading = false;

  AdminUser? get currentAdmin => _currentAdmin;
  DashboardStats? get dashboardStats => _dashboardStats;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentAdmin != null;

  /// Login admin user
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Demo login - accept any credentials
    if (email.isNotEmpty && password.length >= 6) {
      _currentAdmin = AdminUser(
        id: 'admin_001',
        name: 'Admin User',
        email: email,
        avatarUrl: 'https://i.pravatar.cc/200?img=12',
        role: AdminRole.superAdmin,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
      );
      await loadDashboardStats();
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// Logout admin
   logout() {
    _currentAdmin = null;
    _dashboardStats = null;
    notifyListeners();
  }

  /// Load dashboard statistics
  Future<void> loadDashboardStats() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    _dashboardStats = DashboardStats(
      totalRevenue: 125840.50,
      revenueGrowth: 12.5,
      totalOrders: 1584,
      ordersGrowth: 8,
      totalCustomers: 3240,
      customersGrowth: 15,
      totalProducts: 456,
      lowStockProducts: 12,
      pendingOrders: 45,
      processingOrders: 32,
      shippedOrders: 28,
      deliveredOrders: 1479,
      revenueChart: [
        RevenueData(label: 'Mon', value: 12500),
        RevenueData(label: 'Tue', value: 18200),
        RevenueData(label: 'Wed', value: 15800),
        RevenueData(label: 'Thu', value: 22400),
        RevenueData(label: 'Fri', value: 28600),
        RevenueData(label: 'Sat', value: 32100),
        RevenueData(label: 'Sun', value: 24800),
      ],
      ordersChart: [
        OrderData(label: 'Mon', value: 45),
        OrderData(label: 'Tue', value: 62),
        OrderData(label: 'Wed', value: 55),
        OrderData(label: 'Thu', value: 78),
        OrderData(label: 'Fri', value: 92),
        OrderData(label: 'Sat', value: 105),
        OrderData(label: 'Sun', value: 88),
      ],
      topProducts: [
        TopProduct(
          id: '1',
          name: 'Wireless Earbuds Pro',
          imageUrl: 'https://picsum.photos/seed/earbuds/200',
          soldCount: 245,
          revenue: 24255.00,
        ),
        TopProduct(
          id: '2',
          name: 'Smart Watch Series X',
          imageUrl: 'https://picsum.photos/seed/watch/200',
          soldCount: 189,
          revenue: 37611.00,
        ),
        TopProduct(
          id: '3',
          name: 'Premium Leather Bag',
          imageUrl: 'https://picsum.photos/seed/bag/200',
          soldCount: 156,
          revenue: 18564.00,
        ),
        TopProduct(
          id: '4',
          name: 'Running Shoes Elite',
          imageUrl: 'https://picsum.photos/seed/shoes/200',
          soldCount: 134,
          revenue: 16046.00,
        ),
        TopProduct(
          id: '5',
          name: 'Organic Face Serum',
          imageUrl: 'https://picsum.photos/seed/serum/200',
          soldCount: 128,
          revenue: 5632.00,
        ),
      ],
      recentOrders: [
        RecentOrder(
          id: 'ORD-2024-001',
          customerName: 'John Doe',
          customerAvatar: 'https://i.pravatar.cc/100?img=1',
          amount: 156.99,
          status: 'pending',
          createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        ),
        RecentOrder(
          id: 'ORD-2024-002',
          customerName: 'Jane Smith',
          customerAvatar: 'https://i.pravatar.cc/100?img=5',
          amount: 289.50,
          status: 'processing',
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        RecentOrder(
          id: 'ORD-2024-003',
          customerName: 'Mike Johnson',
          customerAvatar: 'https://i.pravatar.cc/100?img=3',
          amount: 432.00,
          status: 'shipped',
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
        RecentOrder(
          id: 'ORD-2024-004',
          customerName: 'Sarah Wilson',
          customerAvatar: 'https://i.pravatar.cc/100?img=9',
          amount: 89.99,
          status: 'delivered',
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        RecentOrder(
          id: 'ORD-2024-005',
          customerName: 'Tom Brown',
          customerAvatar: 'https://i.pravatar.cc/100?img=8',
          amount: 567.25,
          status: 'pending',
          createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        ),
      ],
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Refresh dashboard data
  Future<void> refreshDashboard() async {
    await loadDashboardStats();
  }
}
