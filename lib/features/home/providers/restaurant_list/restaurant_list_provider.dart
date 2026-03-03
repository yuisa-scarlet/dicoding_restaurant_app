import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/core/api_client.dart';
import 'package:dicoding_restaurant_app/core/base_result_state.dart';
import 'package:dicoding_restaurant_app/shared/model/restaurant.dart';

class RestaurantListProvider extends ChangeNotifier {
  final ApiClient apiClient;

  RestaurantListProvider({required this.apiClient}) {
    getAllRestaurants();
  }

  BaseResultState<List<Restaurant>> _state = BaseResultStateInitial();
  BaseResultState<List<Restaurant>> get state => _state;

  Future<void> getAllRestaurants() async {
    _getRestaurantData('/list');
  }

  Future<void> searchRestaurants(String query) async {
    if (query.isEmpty) {
      return getAllRestaurants();
    }
    _getRestaurantData('/search?q=$query');
  }

  Future<void> _getRestaurantData(String endpoint) async {
    _state = BaseResultStateLoading();
    notifyListeners();

    try {
      final response = await apiClient.get(endpoint);

      if (response.statusCode != 200) {
        throw Exception('Failed to load restaurant');
      }

      final result = jsonDecode(response.body);
      final List<Restaurant> restaurants = List<Restaurant>.from(
        result['restaurants'].map((x) => Restaurant.fromJson(x)),
      );

      if (restaurants.isEmpty) {
        _state = BaseResultStateError('No restaurant data');
      } else {
        _state = BaseResultStateSuccess(restaurants);
      }
    } catch (e) {
      _state = BaseResultStateError('Failed to load restaurant');
    }

    notifyListeners();
  }
}
