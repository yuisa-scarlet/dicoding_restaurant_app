import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dicoding_restaurant_app/core/base_result_state.dart';
import 'package:dicoding_restaurant_app/shared/models/restaurant.dart';
import 'package:dicoding_restaurant_app/shared/providers/sqlite_database_provider.dart';
import 'package:dicoding_restaurant_app/feature/favorite/widgets/favorite_empty_view.dart';
import 'package:dicoding_restaurant_app/feature/favorite/widgets/favorite_error_view.dart';
import 'package:dicoding_restaurant_app/feature/favorite/widgets/favorite_success_view.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<SqliteDatabaseProvider>().getFavorites();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Restaurants')),
      body: Consumer<SqliteDatabaseProvider>(
        builder: (context, provider, child) {
          return switch (provider.state) {
            BaseResultStateInitial() || BaseResultStateLoading() =>
              const Center(child: CircularProgressIndicator()),
            BaseResultStateError(errorMessage: final message) =>
              FavoriteErrorView(message: message),
            BaseResultStateSuccess<List<Restaurant>>(
              data: final List<Restaurant> data,
            ) =>
              data.isEmpty
                  ? const FavoriteEmptyView()
                  : FavoriteSuccessView(restaurants: data),
          };
        },
      ),
    );
  }
}
