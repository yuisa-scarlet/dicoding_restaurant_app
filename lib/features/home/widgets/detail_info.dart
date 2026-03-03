import 'package:flutter/material.dart';
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
          restaurant.name,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.grey),
            const SizedBox(width: 8),
            Text('${restaurant.city}, ${restaurant.address ?? ""}'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber),
            const SizedBox(width: 8),
            Text(restaurant.rating.toString()),
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
