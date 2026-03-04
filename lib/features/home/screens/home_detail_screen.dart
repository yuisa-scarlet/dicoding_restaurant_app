import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dicoding_restaurant_app/core/base_result_state.dart';
import 'package:dicoding_restaurant_app/shared/models/restaurant.dart';
import 'package:dicoding_restaurant_app/features/home/providers/restaurant_detail/restaurant_detail_provider.dart';
import 'package:dicoding_restaurant_app/features/home/widgets/detail_loading_view.dart';
import 'package:dicoding_restaurant_app/features/home/widgets/detail_error_view.dart';
import 'package:dicoding_restaurant_app/features/home/widgets/detail_success_view.dart';
import 'package:dicoding_restaurant_app/features/home/widgets/add_review_sheet.dart';

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
            BaseResultStateInitial() => const DetailLoadingView(),
            BaseResultStateError<Restaurant>(errorMessage: final message) =>
              DetailErrorView(message: message),
            BaseResultStateSuccess<Restaurant>(data: final restaurant) =>
              DetailSuccessView(restaurant: restaurant),
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
