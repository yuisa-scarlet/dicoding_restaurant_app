import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/core/api_client.dart';
import 'package:dicoding_restaurant_app/core/result_state.dart';
import 'package:dicoding_restaurant_app/shared/model/restaurant.dart';

class RestaurantListProvider extends ChangeNotifier {
  final ApiClient apiClient;

  RestaurantListProvider({required this.apiClient}) {
    getAllRestaurants();
  }

  ResultState<List<Restaurant>> _state = ResultStateInitial();
  ResultState<List<Restaurant>> get state => _state;

  Future<void> getAllRestaurants() async {
    _state = ResultStateLoading();
    notifyListeners();

    try {
      final response = await apiClient.get('/list');

      if (response.statusCode != 200) {
        throw Exception('Failed to load restaurant');
      }

      final result = jsonDecode(response.body);
      final List<Restaurant> restaurants = List<Restaurant>.from(
        result['restaurants'].map((x) => Restaurant.fromJson(x)),
      );

      if (restaurants.isEmpty) {
        _state = ResultStateError('No restaurant data');
      } else {
        _state = ResultStateSuccess(restaurants);
      }
    } catch (e) {
      _state = ResultStateError('Failed to load restaurant');
    }

    notifyListeners();
  }
}
