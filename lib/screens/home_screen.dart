import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/wallpaper_provider.dart';
import '../screens/wallpaper_details_screen.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final wallpaperProvider = Provider.of<WallpaperProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Center(child: Center(child: Text('Wallpaper App'))),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius:  BorderRadius.all(Radius.circular(20)),

                ),
                focusedBorder: const OutlineInputBorder(
                borderRadius:  BorderRadius.all(
                  Radius.circular(20),
                ),

              ),
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _performSearch,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _searchQuery.isEmpty ? wallpaperProvider.fetchWallpapers() : wallpaperProvider.searchWallpapers(_searchQuery),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.error != null) {
                  return const Center(child: Text('An error occurred!'));
                } else {
                  return GridView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: wallpaperProvider.wallpapers.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 3 / 5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (ctx, index) {
                      final wallpaper = wallpaperProvider.wallpapers[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(WallpaperDetailsScreen.routeName, arguments: wallpaper);
                        },
                        child: GridTile(
                          child: Image.network(wallpaper.imageUrl, fit: BoxFit.cover),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
