import 'package:dicoding_restaurant_app/core/app_color.dart';
import 'package:dicoding_restaurant_app/core/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dicoding_restaurant_app/shared/services/shared_preference_service.dart';
import 'package:dicoding_restaurant_app/core/api_client.dart';
import 'package:dicoding_restaurant_app/features/home/providers/restaurant_list/restaurant_list_provider.dart';
import 'package:dicoding_restaurant_app/features/home/providers/restaurant_detail/restaurant_detail_provider.dart';
import 'package:dicoding_restaurant_app/features/setting/providers/theme_provider.dart';
import 'package:dicoding_restaurant_app/features/home/screens/home_screen.dart';
import 'package:dicoding_restaurant_app/features/home/screens/home_detail_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final appBarColor = isDark ? AppColor.selected : Colors.white;
    final appBarForeground = isDark ? Colors.white : AppColor.primary;
    final bottomNavBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final statusBarIconBrightness = isDark ? Brightness.light : Brightness.dark;

    final base = ColorScheme.fromSeed(
      seedColor: AppColor.selected,
      primary: isDark ? AppColor.selected : AppColor.primary,
      secondary: AppColor.selected,
      brightness: brightness,
      surface: isDark ? const Color(0xFF1E1E1E) : Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: base,
      scaffoldBackgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      fontFamily: 'PlusJakartaSans',
      appBarTheme: AppBarTheme(
        backgroundColor: appBarColor,
        foregroundColor: appBarForeground,
        elevation: isDark ? 0 : 0.5,
        shadowColor: Colors.black26,
        iconTheme: IconThemeData(color: appBarForeground),
        actionsIconTheme: IconThemeData(color: appBarForeground),
        titleTextStyle: TextStyle(
          color: appBarForeground,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'PlusJakartaSans',
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: appBarColor,
          statusBarIconBrightness: statusBarIconBrightness,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: bottomNavBg,
        selectedItemColor: isDark ? Colors.white : AppColor.selected,
        unselectedItemColor: isDark ? Colors.white60 : Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(),
      ),
      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        elevation: isDark ? 0 : 1,
        surfaceTintColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.selected,
          foregroundColor: Colors.white,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColor.selected,
        foregroundColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiClient>(create: (_) => ApiClient(baseUrl: Config.baseUrl)),
        ChangeNotifierProvider<RestaurantListProvider>(
          create: (context) =>
              RestaurantListProvider(apiClient: context.read<ApiClient>()),
        ),
        ChangeNotifierProvider<RestaurantDetailProvider>(
          create: (context) =>
              RestaurantDetailProvider(apiClient: context.read<ApiClient>()),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) =>
              ThemeProvider(context.read<SharedPreferenceService>()),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Dicoding Restaurant',
            theme: _buildTheme(Brightness.light),
            darkTheme: _buildTheme(Brightness.dark),
            themeMode: themeProvider.themeMode,
            home: const HomeScreen(),
            routes: {
              HomeDetailScreen.routeName: (context) => const HomeDetailScreen(),
            },
          );
        },
      ),
    );
  }
}
