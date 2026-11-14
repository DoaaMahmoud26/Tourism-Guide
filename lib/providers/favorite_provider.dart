
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/attraction.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Attraction> _favorites = [];

  List<Attraction> get favorites => _favorites;

  bool isFavorite(Attraction attraction) {
    return _favorites.contains(attraction);
  }

  void toggleFavorite(Attraction attraction) {
    if (isFavorite(attraction)) {
      _favorites.remove(attraction);
    } else {
      _favorites.add(attraction);
    }

    notifyListeners();
  }
}
