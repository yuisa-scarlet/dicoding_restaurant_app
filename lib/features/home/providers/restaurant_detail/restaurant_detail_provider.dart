import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/core/api_client.dart';
import 'package:dicoding_restaurant_app/core/base_result_state.dart';
import 'package:dicoding_restaurant_app/shared/model/restaurant.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiClient apiClient;

  RestaurantDetailProvider({required this.apiClient});

  BaseResultState<Restaurant> _state = BaseResultStateInitial();
  BaseResultState<Restaurant> get state => _state;

  Future<void> getRestaurantById(String id) async {
    _state = BaseResultStateLoading();
    notifyListeners();

    try {
      final response = await apiClient.get('/detail/$id');

      if (response.statusCode != 200) {
        throw Exception('Failed to load restaurant');
      }

      final result = jsonDecode(response.body);
      final restaurant = Restaurant.fromJson(result['restaurant']);
      _state = BaseResultStateSuccess(restaurant);
    } catch (e) {
      _state = BaseResultStateError('Failed to load restaurant');
    }

    notifyListeners();
  }
}
