import 'dart:ui';

import 'package:ec/screens/auth/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Core
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'core/constants/supabase_keys.dart';
import 'core/routing/app_router.dart';

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
  WidgetsFlutterBinding.ensureInitialized();
  // await Supabase.initialize(
  //   anonKey: SupabaseKeys.supaKey,
  //   url: SupabaseKeys.supabaseUrl,
  // );
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
          // Use router for web (better URL support), regular MaterialApp for mobile
          if (kIsWeb) {
            return MaterialApp.router(
              title: AppStrings.appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeProvider.themeMode,
              scrollBehavior: AppScrollBehavior(),
              routerConfig: AppRouter.router,
            );
          } else {
            return MaterialApp(
              title: AppStrings.appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeProvider.themeMode,
              scrollBehavior: AppScrollBehavior(),
              home: const WelcomeScreen(),
            );
          }
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
