import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dicoding_restaurant_app/core/api_client.dart';
import 'package:dicoding_restaurant_app/core/result_state.dart';
import 'package:dicoding_restaurant_app/shared/model/restaurant.dart';

class RestaurantListProvider extends ChangeNotifier {
  final ApiClient apiClient;

  RestaurantListProvider({required this.apiClient}) {
    fetchRestaurants();
  }

  ResultState<List<Restaurant>> _state = ResultStateInitial();
  ResultState<List<Restaurant>> get state => _state;

  Future<void> fetchRestaurants() async {
    _state = ResultStateLoading();
    notifyListeners();

    try {
      final response = await apiClient.get('/list');
      
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['error'] == false) {
          final List<Restaurant> restaurants = List<Restaurant>.from(
            result['restaurants'].map((x) => Restaurant.fromJson(x)),
          );

          if (restaurants.isEmpty) {
            _state = ResultStateError('Tidak ada data restoran');
          } else {
            _state = ResultStateSuccess(restaurants);
          }
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
