import 'package:dicoding_restaurant_app/core/app_color.dart';
import 'package:dicoding_restaurant_app/core/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dicoding_restaurant_app/core/api_client.dart';
import 'package:dicoding_restaurant_app/features/home/providers/restaurant_list/restaurant_list_provider.dart';
import 'package:dicoding_restaurant_app/features/home/providers/restaurant_detail/restaurant_detail_provider.dart';
import 'package:dicoding_restaurant_app/features/setting/providers/theme_provider.dart';
import 'package:dicoding_restaurant_app/features/home/screens/home_screen.dart';
import 'package:dicoding_restaurant_app/features/home/screens/home_detail_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  ThemeData _buildTheme(Brightness brightness) {
    final base = ColorScheme.fromSeed(
      seedColor: AppColor.primary,
      primary: AppColor.primary,
      secondary: AppColor.selected,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: base,
      fontFamily: 'PlusJakartaSans',
      appBarTheme: AppBarTheme(
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'PlusJakartaSans',
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColor.primary,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColor.primary,
        selectedItemColor: AppColor.selected,
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: TextStyle(
          color: AppColor.selected,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(color: Colors.white70),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
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
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
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
