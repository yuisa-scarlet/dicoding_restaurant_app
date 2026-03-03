import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class RestaurantBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const RestaurantBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0.2,
      backgroundColor: Theme.of(context).colorScheme.surface,
      type: BottomNavigationBarType.fixed,
      unselectedFontSize: 12,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      selectedFontSize: 12,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      items: [
        _buildNavItem(LucideIcons.home, 'Home'),
        _buildNavItem(LucideIcons.settings, 'Setting'),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
      tooltip: label,
    );
  }
}
