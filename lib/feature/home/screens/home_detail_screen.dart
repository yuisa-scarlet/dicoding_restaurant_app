import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dicoding_restaurant_app/core/base_result_state.dart';
import 'package:dicoding_restaurant_app/shared/models/restaurant.dart';
import 'package:dicoding_restaurant_app/feature/home/providers/restaurant_detail/restaurant_detail_provider.dart';
import 'package:dicoding_restaurant_app/feature/home/widgets/detail_loading_view.dart';
import 'package:dicoding_restaurant_app/feature/home/widgets/detail_error_view.dart';
import 'package:dicoding_restaurant_app/feature/home/widgets/detail_success_view.dart';
import 'package:dicoding_restaurant_app/feature/home/widgets/add_review_sheet.dart';
import 'package:dicoding_restaurant_app/shared/providers/sqlite_database_provider.dart';

class HomeDetailScreen extends StatefulWidget {
  static const String routePath = '/home/detail';
  static const String routeName = '/home/detail';

  const HomeDetailScreen({super.key});

  @override
  State<HomeDetailScreen> createState() => _HomeDetailScreenState();
}

class _HomeDetailScreenState extends State<HomeDetailScreen> {
  String? _restaurantId;
  String _heroTagPrefix = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is String) {
      if (_restaurantId == null) {
        _restaurantId = args;
        _fetchRestaurantDetails();
      }
    } else if (args is Map<String, dynamic>) {
      if (_restaurantId == null) {
        _restaurantId = args['id'] as String?;
        _heroTagPrefix = args['heroTagPrefix'] as String? ?? '';
        _fetchRestaurantDetails();
      }
    }
  }

  void _fetchRestaurantDetails() {
    if (_restaurantId != null) {
      Future.microtask(() {
        if (!mounted) return;
        context.read<RestaurantDetailProvider>().getRestaurantById(
          _restaurantId!,
        );
        context.read<SqliteDatabaseProvider>().checkIsFavorite(_restaurantId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Detail'),
        actions: [
          Consumer2<RestaurantDetailProvider, SqliteDatabaseProvider>(
            builder: (context, detailProvider, sqliteProvider, _) {
              if (detailProvider.state is BaseResultStateSuccess<Restaurant>) {
                final restaurant =
                    (detailProvider.state as BaseResultStateSuccess<Restaurant>)
                        .data;
                final isFavorite = sqliteProvider.isFavorite;
                final iconColor =
                    Theme.of(context).appBarTheme.actionsIconTheme?.color ??
                    Theme.of(context).colorScheme.onSurface;

                return IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite
                        ? (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.red)
                        : iconColor,
                  ),
                  onPressed: () async {
                    final willRemove = isFavorite;
                    await sqliteProvider.toggleFavorite(restaurant);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          willRemove
                              ? '${restaurant.name} removed from favorites'
                              : '${restaurant.name} added to favorites',
                        ),
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<RestaurantDetailProvider>(
        builder: (_, provider, _) {
          return switch (provider.state) {
            BaseResultStateLoading() ||
            BaseResultStateInitial() => const DetailLoadingView(),
            BaseResultStateError<Restaurant>(errorMessage: final message) =>
              DetailErrorView(message: message),
            BaseResultStateSuccess<Restaurant>(data: final restaurant) =>
              DetailSuccessView(
                restaurant: restaurant,
                heroTagPrefix: _heroTagPrefix,
              ),
          };
        },
      ),
      floatingActionButton: Consumer<RestaurantDetailProvider>(
        builder: (context, provider, _) {
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
                  builder: (context) => const AddReviewSheet(),
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
