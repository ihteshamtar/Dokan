import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<String> _favoriteProducts = [];

  List<String> get favoriteProducts => _favoriteProducts;

  void toggleFavorite(String productName) {
    if (_favoriteProducts.contains(productName)) {
      _favoriteProducts.remove(productName);
    } else {
      _favoriteProducts.add(productName);
    }
    notifyListeners();
  }

  bool isFavorite(String productName) {
    return _favoriteProducts.contains(productName);
  }
}
