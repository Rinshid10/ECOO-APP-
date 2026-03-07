import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

// Screens
import '../../screens/splash/splash_screen.dart';
import '../../screens/auth/welcome_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/signup_screen.dart';
import '../../screens/main_navigation.dart';
import '../../screens/product_detail/product_detail_screen.dart';
import '../../screens/search/search_screen.dart';
import '../../screens/notifications/notifications_screen.dart';
import '../../screens/settings/settings_screen.dart';

// Data models (for route parameters)
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

/// Application router configuration
/// Handles navigation and URL routing for web and mobile
class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: kDebugMode,
    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const MainNavigation(),
        routes: [
          GoRoute(
            path: 'product/:id',
            name: 'product-detail',
            builder: (context, state) {
              // For web, we'll need to fetch product by ID
              // For now, using a placeholder - you can enhance this
              final productId = state.pathParameters['id'] ?? '';
              // In a real app, you'd fetch the product here
              // For now, we'll navigate to a generic product detail
              // You may want to pass product data through state.extra
              return ProductDetailScreen(
                product: _getProductById(productId),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) {
          final query = state.uri.queryParameters['q'];
          return SearchScreen(initialQuery: query);
        },
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    // Redirect logic
    redirect: (context, state) {
      // Add any authentication redirects here if needed
      return null;
    },
  );

  /// Helper method to get product by ID
  /// In a real app, this would fetch from your data source
  static Product _getProductById(String id) {
    // Try to find product in repository
    try {
      final product = ProductRepository.products.firstWhere(
        (p) => p.id == id,
        orElse: () => ProductRepository.products.first,
      );
      return product;
    } catch (e) {
      // Return first product as fallback
      return ProductRepository.products.first;
    }
  }
}
