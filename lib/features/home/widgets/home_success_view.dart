import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/shared/models/restaurant.dart';
import 'package:dicoding_restaurant_app/features/home/widgets/restaurant_card.dart';

class HomeSuccessView extends StatelessWidget {
  final List<Restaurant> restaurants;

  const HomeSuccessView({super.key, required this.restaurants});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final restaurant = restaurants[index];
        return RestaurantCard(
          restaurant: restaurant,
          onTap: () => Navigator.pushNamed(
            context,
            '/home/detail',
            arguments: restaurant.id,
          ),
        );
      },
    );
  }
}
