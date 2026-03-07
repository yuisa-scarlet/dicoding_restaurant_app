import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/core/api_client.dart';
import 'package:dicoding_restaurant_app/core/base_result_state.dart';
import 'package:dicoding_restaurant_app/shared/models/restaurant.dart';
import 'package:dicoding_restaurant_app/shared/models/customer_review.dart';

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
        throw Exception();
      }

      final result = jsonDecode(response.body);
      final restaurant = Restaurant.fromJson(result['restaurant']);
      _state = BaseResultStateSuccess(restaurant);
    } on SocketException {
      _state = BaseResultStateError(
        'Unable to connect to the server. Please check your internet connection.',
      );
    } catch (e) {
      _state = BaseResultStateError(
        'An error occurred while loading restaurant details. Please try again.',
      );
    }

    notifyListeners();
  }

  Future<void> addReview(String name, String review) async {
    final currentState = _state;
    if (currentState is! BaseResultStateSuccess<Restaurant>) return;

    final restaurantId = currentState.data.id;
    final response = await apiClient.post(
      '/review',
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': restaurantId, 'name': name, 'review': review}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to submit review. Please try again later.');
    }

    final result = jsonDecode(response.body);
    if (result['error'] == true) {
      throw Exception(
        result['message'] ?? 'Failed to submit review. Please try again.',
      );
    }

    final newReviews = List<CustomerReview>.from(
      result['customerReviews'].map((x) => CustomerReview.fromJson(x)),
    );

    _state = BaseResultStateSuccess(
      currentState.data.copyWith(customerReviews: newReviews),
    );
    notifyListeners();
  }
}
