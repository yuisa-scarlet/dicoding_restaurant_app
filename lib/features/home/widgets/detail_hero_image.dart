import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dicoding_restaurant_app/core/config.dart';
import 'package:dicoding_restaurant_app/shared/models/restaurant.dart';

class DetailHeroImage extends StatelessWidget {
  final Restaurant restaurant;
  final String heroTagPrefix;

  const DetailHeroImage({
    super.key,
    required this.restaurant,
    this.heroTagPrefix = '',
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: '$heroTagPrefix${restaurant.pictureId}',
      child: CachedNetworkImage(
        imageUrl: '${Config.baseUrl}/images/medium/${restaurant.pictureId}',
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 350),
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: double.infinity,
            height: 250,
            color: Colors.white,
          ),
        ),
        errorWidget: (context, url, error) => const SizedBox(
          height: 250,
          child: Center(child: Icon(Icons.error)),
        ),
      ),
    );
  }
}
