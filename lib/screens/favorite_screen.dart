import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/screens/wallpaper_details_screen.dart';

import '../providers/favorite_provider.dart';

class FavoriteScreen extends StatefulWidget {
  static const routeName = '/favorites';

  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<FavoriteProvider>(context, listen: false).fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final favorites = favoriteProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Center(child: Text('Favorite Wallpapers')),
      ),
      body: favorites.isEmpty
          ? const Center(
        child: Text('No favorite wallpapers yet.'),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: favorites.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 3 / 5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, index) {
          final wallpaper = favorites[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                WallpaperDetailsScreen.routeName,
                arguments: wallpaper,
              );
            },
            child: GridTile(
              child: Image.network(
                wallpaper.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
