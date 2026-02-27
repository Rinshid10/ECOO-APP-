/// Dashboard statistics model
class DashboardStats {
  final double totalRevenue;
  final double revenueGrowth;
  final int totalOrders;
  final int ordersGrowth;
  final int totalCustomers;
  final int customersGrowth;
  final int totalProducts;
  final int lowStockProducts;
  final int pendingOrders;
  final int processingOrders;
  final int shippedOrders;
  final int deliveredOrders;
  final List<RevenueData> revenueChart;
  final List<OrderData> ordersChart;
  final List<TopProduct> topProducts;
  final List<RecentOrder> recentOrders;

  DashboardStats({
    required this.totalRevenue,
    required this.revenueGrowth,
    required this.totalOrders,
    required this.ordersGrowth,
    required this.totalCustomers,
    required this.customersGrowth,
    required this.totalProducts,
    required this.lowStockProducts,
    required this.pendingOrders,
    required this.processingOrders,
    required this.shippedOrders,
    required this.deliveredOrders,
    required this.revenueChart,
    required this.ordersChart,
    required this.topProducts,
    required this.recentOrders,
  });
}

/// Revenue chart data
class RevenueData {
  final String label;
  final double value;

  RevenueData({required this.label, required this.value});
}

/// Orders chart data
class OrderData {
  final String label;
  final int value;

  OrderData({required this.label, required this.value});
}

/// Top selling product
class TopProduct {
  final String id;
  final String name;
  final String imageUrl;
  final int soldCount;
  final double revenue;

  TopProduct({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.soldCount,
    required this.revenue,
  });
}

/// Recent order for dashboard
class RecentOrder {
  final String id;
  final String customerName;
  final String customerAvatar;
  final double amount;
  final String status;
  final DateTime createdAt;

  RecentOrder({
    required this.id,
    required this.customerName,
    required this.customerAvatar,
    required this.amount,
    required this.status,
    required this.createdAt,
  });
}
