import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/features/home/screens/home_screen.dart';
import 'package:dicoding_restaurant_app/features/setting/screens/setting_screen.dart';
import 'package:dicoding_restaurant_app/shared/widgets/restaurant_bottom_navigation.dart';

class MainScreen extends StatefulWidget {
  static const String routeName = '/main';
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [HomeScreen(), SettingScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: RestaurantBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
