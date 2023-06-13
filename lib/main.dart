import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/providers/favorite_provider.dart';

import './providers/wallpaper_provider.dart';
import './screens/home_screen.dart';
import './screens/wallpaper_details_screen.dart';
import './screens/favorite_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WallpaperProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Wallpaper App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (ctx) => HomeScreen(),
          WallpaperDetailsScreen.routeName: (ctx) => const WallpaperDetailsScreen(),
          FavoriteScreen.routeName: (ctx) => const FavoriteScreen(),
        },
      ),
    );
  }
}
