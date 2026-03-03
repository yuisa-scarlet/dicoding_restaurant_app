import 'package:cached_network_image/cached_network_image.dart';
import 'package:dicoding_restaurant_app/core/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:dicoding_restaurant_app/core/base_result_state.dart';
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
            BaseResultStateLoading() ||
            BaseResultStateInitial() => const _DetailLoadingView(),
            BaseResultStateError<Restaurant>(errorMessage: final message) =>
              _DetailErrorView(message: message),
            BaseResultStateSuccess<Restaurant>(data: final restaurant) =>
              _DetailSuccessView(restaurant: restaurant),
          };
        },
      ),
      floatingActionButton: Consumer<RestaurantDetailProvider>(
        builder: (context, provider, child) {
          if (provider.state is BaseResultStateSuccess<Restaurant>) {
            return FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) => const _AddReviewSheet(),
                );
              },
              child: const Icon(Icons.rate_review),
            );
          }
          return const SizedBox.shrink();
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
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailHeroImage(restaurant: restaurant),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailInfo(restaurant: restaurant),
                  const SizedBox(height: 16),
                  _DetailMenuSection(
                    title: 'Foods',
                    items:
                        restaurant.menus?.foods.map((e) => e.name).toList() ??
                        [],
                  ),
                  const SizedBox(height: 16),
                  _DetailMenuSection(
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

class _AddReviewSheet extends StatefulWidget {
  const _AddReviewSheet();

  @override
  State<_AddReviewSheet> createState() => _AddReviewSheetState();
}

class _AddReviewSheetState extends State<_AddReviewSheet> {
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  void _submitReview() async {
    final name = _nameController.text.trim();
    final review = _reviewController.text.trim();

    if (name.isEmpty || review.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and Review cannot be empty')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await context.read<RestaurantDetailProvider>().addReview(name, review);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review added successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Add Review',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _reviewController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Review',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitReview,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Submit Review', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
