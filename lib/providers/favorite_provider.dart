import 'package:flutter/foundation.dart';
import '../database_helper.dart';
import '../model/wallpaper_model.dart';


class FavoriteProvider with ChangeNotifier {
  final List<Wallpaper> _favorites = [];
  final FavoriteDataHelper _dataHelper = FavoriteDataHelper();

  List<Wallpaper> get favorites {
    return [..._favorites];
  }

  Future<void> addFavorite(Wallpaper wallpaper) async {
    _favorites.add(wallpaper);
    notifyListeners();
    await _dataHelper.insert(wallpaper);
  }

  Future<void> removeFavorite(Wallpaper wallpaper) async {
    _favorites.remove(wallpaper);
    notifyListeners();
    await _dataHelper.delete(wallpaper.id);
  }

  bool isFavorite(Wallpaper wallpaper) {
    return _favorites.contains(wallpaper);
  }

  Future<void> fetchFavorites() async {
    final List<Map<String, dynamic>> favoritesData =
    await _dataHelper.getFavorites();
    _favorites.clear();
    _favorites.addAll(
      favoritesData.map((map) => Wallpaper(
        id: map['id'],
        imageUrl: map['imageUrl'],
      )),
    );
    notifyListeners();
  }
}
