import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class RestaurantBottomNavigation extends StatefulWidget {
  const RestaurantBottomNavigation({super.key});

  @override
  State<RestaurantBottomNavigation> createState() => _RestaurantBottomNavigationState();
}

class _RestaurantBottomNavigationState extends State<RestaurantBottomNavigation> {
  void _onItemTapped(int index) {
    
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0.2,
      backgroundColor: Theme.of(context).colorScheme.surface,
      type: BottomNavigationBarType.fixed,
      unselectedFontSize: 12,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      selectedFontSize: 12,
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
      ),
      items: [
        _buildNavItem(LucideIcons.home, 'Home'),
        _buildNavItem(LucideIcons.settings, 'Setting'),
      ]
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
      tooltip: label
    );
  }
}