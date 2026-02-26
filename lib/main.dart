import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Core
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';

// Providers
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/user_provider.dart';

// Screens
import 'screens/splash/splash_screen.dart';

/// Main entry point of the application
///
/// This e-commerce app is built with:
/// - Clean Architecture pattern
/// - Provider for state management
/// - Responsive design for all screen sizes
/// - Network images throughout
/// - Professional UI/UX design
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

/// Root widget of the application
/// Sets up providers and theme configuration
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Theme provider instance
  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  void initState() {
    super.initState();
    // Initialize theme from saved preferences
    _themeProvider.init();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Register all providers
      providers: [
        // Theme provider for dark/light mode
        ChangeNotifierProvider.value(value: _themeProvider),

        // Cart provider for shopping cart management
        ChangeNotifierProvider(create: (_) => CartProvider()),

        // Wishlist provider for favorites management
        ChangeNotifierProvider(create: (_) => WishlistProvider()),

        // User provider for user profile management
        ChangeNotifierProvider(
          create: (_) {
            final userProvider = UserProvider();
            // Initialize with sample user for demo
            userProvider.initSampleUser();
            return userProvider;
          },
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            // App configuration
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,

            // Theme configuration
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,

            // Enable scrolling on web with mouse drag
            scrollBehavior: AppScrollBehavior(),

            // Home screen
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

/// Custom scroll behavior to enable drag scrolling on all platforms
/// This fixes the web scrolling issue where mouse drag doesn't work by default
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };
}
