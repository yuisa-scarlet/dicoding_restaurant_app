import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/core/api_client.dart';
import 'package:dicoding_restaurant_app/core/base_result_state.dart';
import 'package:dicoding_restaurant_app/shared/model/restaurant.dart';

import 'package:dicoding_restaurant_app/shared/model/customer_review.dart';

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

  Future<void> addReview(String name, String review) async {
    final currentState = _state;
    if (currentState is! BaseResultStateSuccess<Restaurant>) return;

    final restaurantId = currentState.data.id;

    try {
      final response = await apiClient.post(
        '/review',
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': restaurantId, 'name': name, 'review': review}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = jsonDecode(response.body);
        if (result['error'] == false) {
          final newReviews = List<CustomerReview>.from(
            result['customerReviews'].map((x) => CustomerReview.fromJson(x)),
          );

          final updatedRestaurant = currentState.data.copyWith(
            customerReviews: newReviews,
          );

          _state = BaseResultStateSuccess(updatedRestaurant);
          notifyListeners();
        } else {
          throw Exception(result['message'] ?? 'Failed to add review');
        }
      } else {
        throw Exception('Failed to add review');
      }
    } catch (e) {
      rethrow;
    }
  }
}
