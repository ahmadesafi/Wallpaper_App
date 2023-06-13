import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../model/wallpaper_model.dart';
import '../providers/favorite_provider.dart';
import 'favorite_screen.dart';

class WallpaperDetailsScreen extends StatelessWidget {
  static const routeName = '/wallpaper-details';

  const WallpaperDetailsScreen({Key? key}) : super(key: key);

  Future<Uint8List> _fetchImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    return response.bodyBytes;
  }

  Future<void> _downloadImage(BuildContext context, String imageUrl) async {
    try {
      final imageBytes = await _fetchImage(imageUrl);
      await ImageGallerySaver.saveImage(Uint8List.fromList(imageBytes));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image saved to gallery')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final wallpaper = ModalRoute.of(context)?.settings.arguments as Wallpaper?;

    if (wallpaper == null) {
      // Handle the case where wallpaper is null
      return const Scaffold(
        body: Center(
          child: Text('No wallpaper found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Center(child: Text('Wallpaper Details')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(wallpaper.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Add to Favorites',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                Provider.of<FavoriteProvider>(context, listen: false)
                    .addFavorite(wallpaper);
                Navigator.pushNamed(context, FavoriteScreen.routeName);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Download Image',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                _downloadImage(context, wallpaper.imageUrl);
              },
            ),
          ],
        ),
      ),
    );

  }
}
