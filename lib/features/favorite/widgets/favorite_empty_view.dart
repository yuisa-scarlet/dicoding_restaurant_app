import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FavoriteEmptyView extends StatelessWidget {
  const FavoriteEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.heart, size: 100, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No favorite restaurants yet',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
