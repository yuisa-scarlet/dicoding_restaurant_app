import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/shared/models/restaurant.dart';
import 'package:dicoding_restaurant_app/features/home/widgets/detail_hero_image.dart';
import 'package:dicoding_restaurant_app/features/home/widgets/detail_info.dart';
import 'package:dicoding_restaurant_app/features/home/widgets/detail_menu_section.dart';

class DetailSuccessView extends StatelessWidget {
  final Restaurant restaurant;
  final String heroTagPrefix;

  const DetailSuccessView({
    super.key,
    required this.restaurant,
    this.heroTagPrefix = '',
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailHeroImage(
              restaurant: restaurant,
              heroTagPrefix: heroTagPrefix,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailInfo(restaurant: restaurant),
                  const SizedBox(height: 16),
                  DetailMenuSection(
                    title: 'Foods',
                    items:
                        restaurant.menus?.foods.map((e) => e.name).toList() ??
                        [],
                  ),
                  const SizedBox(height: 16),
                  DetailMenuSection(
                    title: 'Drinks',
                    items:
                        restaurant.menus?.drinks.map((e) => e.name).toList() ??
                        [],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Reviews',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  if (restaurant.customerReviews != null)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: restaurant.customerReviews!.length,
                      itemBuilder: (context, index) {
                        final review = restaurant.customerReviews![index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(review.name),
                          subtitle: Text(review.review),
                          trailing: Text(
                            review.date,
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
