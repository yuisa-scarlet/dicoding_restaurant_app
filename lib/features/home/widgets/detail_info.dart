import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/core/app_color.dart';
import 'package:dicoding_restaurant_app/shared/model/restaurant.dart';

class DetailInfo extends StatelessWidget {
  final Restaurant restaurant;

  const DetailInfo({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          restaurant.name.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'InstrumentSerif',
            fontSize: 28,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),

        Row(
          children: [
            Icon(Icons.location_on, size: 14, color: AppColor.selected),
            const SizedBox(width: 2),
            Text(restaurant.city, style: const TextStyle(fontSize: 12)),
            if (restaurant.address != null &&
                restaurant.address!.isNotEmpty) ...[
              const Text(', ', style: TextStyle(fontSize: 12)),
              Expanded(
                child: Text(
                  restaurant.address!,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            const SizedBox(width: 12),
            Icon(Icons.star_rounded, size: 14, color: AppColor.selected),
            const SizedBox(width: 2),
            Text(
              restaurant.rating.toString(),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),

        const SizedBox(height: 16),

        const Text(
          'Description',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(restaurant.description),
      ],
    );
  }
}
