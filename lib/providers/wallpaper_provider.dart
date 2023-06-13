import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/wallpaper_model.dart';

class WallpaperProvider extends ChangeNotifier {
  List<Wallpaper> wallpapers = [];
  bool isLoading = false;

  Future<void> fetchWallpapers() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await http.get(Uri.parse('https://api.pexels.com/v1/curated?per_page=50'), headers: {
        'Authorization': 'XelNoZMfUXKx38ZlNlL6rA0PNTFd8dbQTIE4GRsSOMth0xhfuh3gCXgq',
      });

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final wallpapersData = jsonData['photos'];

        wallpapers = wallpapersData.map<Wallpaper>((item) {
          return Wallpaper(id: item['id'].toString(), imageUrl: item['src']['medium']);
        }).toList();

        isLoading = false;
        notifyListeners();
      }
    } catch (error) {
      isLoading = false;
      notifyListeners();
      throw error;
    }
  }

  Future<void> searchWallpapers(String query) async {
    final url = Uri.parse('https://api.pexels.com/v1/search?query=$query&per_page=30&page=1');
    final response = await http.get(url, headers: {'Authorization': 'XelNoZMfUXKx38ZlNlL6rA0PNTFd8dbQTIE4GRsSOMth0xhfuh3gCXgq'});

    final responseData = json.decode(response.body);
    final List<Wallpaper> loadedWallpapers = [];

    responseData['photos'].forEach((wallpaperData) {
      final wallpaper = Wallpaper(
        id: wallpaperData['id'].toString(),
        imageUrl: wallpaperData['src']['portrait'],
      );
      loadedWallpapers.add(wallpaper);
    });

    wallpapers.clear();
    wallpapers.addAll(loadedWallpapers);

    notifyListeners();
  }
}
