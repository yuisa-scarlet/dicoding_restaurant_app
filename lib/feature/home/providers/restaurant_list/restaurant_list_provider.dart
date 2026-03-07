import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/core/api_client.dart';
import 'package:dicoding_restaurant_app/core/base_result_state.dart';
import 'package:dicoding_restaurant_app/shared/models/restaurant.dart';

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
        throw Exception();
      }

      final result = jsonDecode(response.body);
      final List<Restaurant> restaurants = List<Restaurant>.from(
        result['restaurants'].map((x) => Restaurant.fromJson(x)),
      );

      if (restaurants.isEmpty) {
        _state = BaseResultStateError('No restaurants found.');
      } else {
        _state = BaseResultStateSuccess(restaurants);
      }
    } on SocketException {
      _state = BaseResultStateError(
        'Unable to connect to the server. Please check your internet connection.',
      );
    } catch (e) {
      _state = BaseResultStateError(
        'An error occurred while loading restaurant data. Please try again.',
      );
    }

    notifyListeners();
  }
}
