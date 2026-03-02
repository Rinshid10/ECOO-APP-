import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kReleaseMode;
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

// Admin providers
import 'admin/providers/admin_provider.dart';

// Screens
import 'screens/splash/splash_screen.dart';

/// Main entry point of the application
void main() async {
  // Error handling for web
  if (kIsWeb) {
    // Catch and log errors
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      if (kReleaseMode) {
        // In production, you might want to send errors to a logging service
        print('Flutter Error: ${details.exception}');
      }
    };

    // Handle platform errors
    PlatformDispatcher.instance.onError = (error, stack) {
      print('Platform Error: $error');
      return true;
    };

    // Custom error widget builder for better error display
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Material(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Something went wrong',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    details.exception.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Reload the page on web
                    if (kIsWeb) {
                      // Use JavaScript to reload
                      // ignore: avoid_web_libraries_in_flutter
                    }
                  },
                  child: const Text('Reload'),
                ),
              ],
            ),
          ),
        ),
      );
    };
  }

  WidgetsFlutterBinding.ensureInitialized();

  // Only lock orientation on mobile platforms, not on web
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  // Run app with error boundary
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
  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  void initState() {
    super.initState();
    _themeProvider.init();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _themeProvider),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(
          create: (_) {
            final userProvider = UserProvider();
            userProvider.initSampleUser();
            return userProvider;
          },
        ),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            scrollBehavior: AppScrollBehavior(),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

/// Custom scroll behavior to enable drag scrolling on all platforms
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
