import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dicoding_restaurant_app/core/base_result_state.dart';
import 'package:dicoding_restaurant_app/shared/model/restaurant.dart';
import 'package:dicoding_restaurant_app/features/home/providers/navigation_provider.dart';
import 'package:dicoding_restaurant_app/features/home/providers/restaurant_list/restaurant_list_provider.dart';
import 'package:dicoding_restaurant_app/features/home/widgets/home_loading_view.dart';
import 'package:dicoding_restaurant_app/features/home/widgets/home_error_view.dart';
import 'package:dicoding_restaurant_app/features/home/widgets/home_success_view.dart';
import 'package:dicoding_restaurant_app/features/setting/screens/setting_screen.dart';
import 'package:dicoding_restaurant_app/shared/widgets/restaurant_bottom_navigation.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/';

  const HomeScreen({super.key});

  static const List<Widget> _pages = [_HomeBody(), SettingScreen()];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NavigationProvider(),
      child: Consumer<NavigationProvider>(
        builder: (context, nav, _) {
          return Scaffold(
            body: IndexedStack(index: nav.currentIndex, children: _pages),
            bottomNavigationBar: RestaurantBottomNavigation(
              currentIndex: nav.currentIndex,
              onTap: nav.setIndex,
            ),
          );
        },
      ),
    );
  }
}

class _HomeBody extends StatefulWidget {
  const _HomeBody();

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<RestaurantListProvider>().getAllRestaurants();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.read<RestaurantListProvider>().searchRestaurants(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search restaurant...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _onSearchChanged('');
                FocusScope.of(context).unfocus();
              },
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
          ),
          onChanged: _onSearchChanged,
        ),
      ),
      body: Consumer<RestaurantListProvider>(
        builder: (context, provider, child) {
          return switch (provider.state) {
            BaseResultStateLoading() ||
            BaseResultStateInitial() => const HomeLoadingView(),
            BaseResultStateError<List<Restaurant>>(
              errorMessage: final message,
            ) =>
              HomeErrorView(
                message: message,
                onRetry: provider.getAllRestaurants,
              ),
            BaseResultStateSuccess<List<Restaurant>>(data: final restaurants) =>
              HomeSuccessView(restaurants: restaurants),
          };
        },
      ),
    );
  }
}
