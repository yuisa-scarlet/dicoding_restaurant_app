import 'package:flutter/foundation.dart';
import 'package:dicoding_restaurant_app/core/base_result_state.dart';
import 'package:dicoding_restaurant_app/shared/models/restaurant.dart';
import 'package:dicoding_restaurant_app/shared/services/sqlite_database_service.dart';

class SqliteDatabaseProvider extends ChangeNotifier {
  final SqliteDatabaseService _service;

  SqliteDatabaseProvider(this._service) {
    _loadFavorites();
  }

  BaseResultState<List<Restaurant>> _state = const BaseResultStateInitial();
  BaseResultState<List<Restaurant>> get state => _state;

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;

  Future<void> _loadFavorites() async {
    _state = const BaseResultStateLoading();
    notifyListeners();

    try {
      final favorites = await _service.getFavorites();
      _state = BaseResultStateSuccess(favorites);
    } catch (e) {
      _state = BaseResultStateError('Gagal memuat favorit: $e');
    }
    notifyListeners();
  }

  Future<void> getFavorites() async {
    await _loadFavorites();
  }

  Future<void> checkIsFavorite(String id) async {
    _isFavorite = await _service.isFavorite(id);
    notifyListeners();
  }

  Future<void> toggleFavorite(Restaurant restaurant) async {
    try {
      final isFav = await _service.isFavorite(restaurant.id);

      if (isFav) {
        await _service.removeFavorite(restaurant.id);
      } else {
        await _service.insertFavorite(restaurant);
      }

      await checkIsFavorite(restaurant.id);
      await _loadFavorites();
    } catch (e) {
      debugPrint('Gagal menambahkan ke favorit: $e');
    }
  }
}
