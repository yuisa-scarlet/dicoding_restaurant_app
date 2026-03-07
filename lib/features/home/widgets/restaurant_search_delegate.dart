import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dicoding_restaurant_app/core/base_result_state.dart';
import 'package:dicoding_restaurant_app/shared/models/restaurant.dart';
import 'package:dicoding_restaurant_app/features/home/providers/restaurant_list/restaurant_list_provider.dart';
import 'package:dicoding_restaurant_app/features/home/widgets/home_loading_view.dart';
import 'package:dicoding_restaurant_app/features/home/widgets/home_error_view.dart';
import 'package:dicoding_restaurant_app/features/home/widgets/home_success_view.dart';

class RestaurantSearchDelegate extends SearchDelegate<String?> {
  Timer? _debounce;

  @override
  String get searchFieldLabel => 'Search restaurants...';

  @override
  TextStyle? get searchFieldStyle => const TextStyle(fontSize: 14);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        context.read<RestaurantListProvider>().getAllRestaurants();
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        context.read<RestaurantListProvider>().searchRestaurants(query);
      } else {
        context.read<RestaurantListProvider>().getAllRestaurants();
      }
    });

    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    return Consumer<RestaurantListProvider>(
      builder: (context, provider, child) {
        return switch (provider.state) {
          BaseResultStateLoading() ||
          BaseResultStateInitial() => const HomeLoadingView(),
          BaseResultStateError<List<Restaurant>>(errorMessage: final message) =>
            HomeErrorView(
              message: message,
              onRetry: () => provider.searchRestaurants(query),
            ),
          BaseResultStateSuccess<List<Restaurant>>(data: final restaurants) =>
            HomeSuccessView(restaurants: restaurants),
        };
      },
    );
  }
}
