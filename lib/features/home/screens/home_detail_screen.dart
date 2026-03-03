import 'package:cached_network_image/cached_network_image.dart';
import 'package:dicoding_restaurant_app/core/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dicoding_restaurant_app/core/result_state.dart';
import 'package:dicoding_restaurant_app/shared/model/restaurant.dart';
import 'package:dicoding_restaurant_app/features/home/providers/restaurant_detail/restaurant_detail_provider.dart';

class HomeDetailScreen extends StatefulWidget {
  static const String routePath = '/home/detail';
  static const String routeName = '/home/detail';

  const HomeDetailScreen({super.key});

  @override
  State<HomeDetailScreen> createState() => _HomeDetailScreenState();
}

class _HomeDetailScreenState extends State<HomeDetailScreen> {
  String? _restaurantId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as String?;
    if (args != null && _restaurantId == null) {
      _restaurantId = args;
      Future.microtask(() {
        if (!mounted) return;
        context.read<RestaurantDetailProvider>().getRestaurantById(
          _restaurantId!,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurant Detail')),
      body: Consumer<RestaurantDetailProvider>(
        builder: (context, provider, child) {
          return switch (provider.state) {
            ResultStateLoading() ||
            ResultStateInitial() => const _DetailLoadingView(),
            ResultStateError<Restaurant>(errorMessage: final message) =>
              _DetailErrorView(message: message),
            ResultStateSuccess<Restaurant>(data: final restaurant) =>
              _DetailSuccessView(restaurant: restaurant),
          };
        },
      ),
    );
  }
}

class _DetailLoadingView extends StatelessWidget {
  const _DetailLoadingView();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: double.infinity, height: 250, color: Colors.white),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 200, height: 24, color: Colors.white),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 16,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 16,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailErrorView extends StatelessWidget {
  final String message;

  const _DetailErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message, style: const TextStyle(color: Colors.red)),
    );
  }
}

class _DetailSuccessView extends StatelessWidget {
  final Restaurant restaurant;

  const _DetailSuccessView({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DetailHeroImage(restaurant: restaurant),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailInfo(restaurant: restaurant),
                const SizedBox(height: 16),
                _DetailMenuSection(
                  title: 'Foods',
                  items:
                      restaurant.menus?.foods.map((e) => e.name).toList() ?? [],
                ),
                const SizedBox(height: 16),
                _DetailMenuSection(
                  title: 'Drinks',
                  items:
                      restaurant.menus?.drinks.map((e) => e.name).toList() ??
                      [],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailHeroImage extends StatelessWidget {
  final Restaurant restaurant;

  const _DetailHeroImage({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: restaurant.pictureId,
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

class _DetailInfo extends StatelessWidget {
  final Restaurant restaurant;

  const _DetailInfo({required this.restaurant});

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

class _DetailMenuSection extends StatelessWidget {
  final String title;
  final List<String> items;

  const _DetailMenuSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) => Chip(label: Text(items[index])),
          ),
        ),
      ],
    );
  }
}
