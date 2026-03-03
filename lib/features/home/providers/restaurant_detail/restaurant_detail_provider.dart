import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/core/api_client.dart';
import 'package:dicoding_restaurant_app/core/result_state.dart';
import 'package:dicoding_restaurant_app/shared/model/restaurant.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiClient apiClient;

  RestaurantDetailProvider({required this.apiClient});

  ResultState<Restaurant> _state = ResultStateInitial();
  ResultState<Restaurant> get state => _state;

  Future<void> fetchRestaurantDetail(String id) async {
    _state = ResultStateLoading();
    notifyListeners();

    try {
      final response = await apiClient.get('/detail/$id');
      
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['error'] == false) {
          final restaurant = Restaurant.fromJson(result['restaurant']);
          _state = ResultStateSuccess(restaurant);
        } else {
          _state = ResultStateError(result['message'] ?? 'Load failed');
        }
      } else {
        _state = ResultStateError('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      _state = ResultStateError('Tolong cek koneksi internet anda');
    }

    notifyListeners();
  }
}
