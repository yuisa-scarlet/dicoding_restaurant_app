import 'package:dicoding_restaurant_app/core/config.dart';
import 'package:dicoding_restaurant_app/features/setting/screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dicoding_restaurant_app/core/api_client.dart';
import 'package:dicoding_restaurant_app/features/home/providers/restaurant_list/restaurant_list_provider.dart';
import 'package:dicoding_restaurant_app/features/home/providers/restaurant_detail/restaurant_detail_provider.dart';
import 'package:dicoding_restaurant_app/features/setting/providers/theme_provider.dart';
import 'package:dicoding_restaurant_app/features/home/screens/main_screen.dart';
import 'package:dicoding_restaurant_app/features/home/screens/home_screen.dart';
import 'package:dicoding_restaurant_app/features/home/screens/home_detail_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiClient>(
          create: (_) =>
            ApiClient(
              baseUrl: Config.baseUrl
            ),
        ),
        ChangeNotifierProvider<RestaurantListProvider>(
          create: (context) => RestaurantListProvider(
            apiClient: context.read<ApiClient>()
          ),
        ),
        ChangeNotifierProvider<RestaurantDetailProvider>(
          create: (context) => RestaurantDetailProvider(
            apiClient: context.read<ApiClient>()
          ),
        ),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Dicoding Restaurant',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepOrange,
                brightness: Brightness.light,
              ),
              fontFamily: 'PlusJakartaSans',
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepOrange,
                brightness: Brightness.dark,
              ),
              fontFamily: 'PlusJakartaSans',
            ),
            themeMode: themeProvider.themeMode,
            home: const MainScreen(),
            routes: {
              MainScreen.routeName: (context) => const MainScreen(),
              HomeScreen.routeName: (context) => const HomeScreen(),
              SettingScreen.routeName: (context) => const SettingScreen(),
              HomeDetailScreen.routeName: (context) => const HomeDetailScreen(),
            },
          );
        },
      ),
    );
  }
}
