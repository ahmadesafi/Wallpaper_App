import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart' as path;

import 'model/wallpaper_model.dart';

class FavoriteDataHelper {
  final String tableName = 'favorites';
  final String columnId = 'id';
  final String columnImageUrl = 'imageUrl';

  Future<void> insert(Wallpaper wallpaper) async {
    final db = await _openDatabase();
    await db.insert(
      tableName,
      {
        columnId: wallpaper.id,
        columnImageUrl: wallpaper.imageUrl,
      },
      conflictAlgorithm: sqflite.ConflictAlgorithm.replace,
    );
    await db.close();
  }

  Future<void> delete(String id) async {
    final db = await _openDatabase();
    await db.delete(
      tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    await db.close();
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await _openDatabase();
    final List<Map<String, dynamic>> favoritesData = await db.query(tableName);
    await db.close();
    return favoritesData;
  }

  Future<sqflite.Database> _openDatabase() async {
    final dbPath = await sqflite.getDatabasesPath();
    final dbLocation = path.join(dbPath, 'favorites.db');
    return sqflite.openDatabase(dbLocation, version: 1,
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE $tableName($columnId TEXT PRIMARY KEY, $columnImageUrl TEXT)',
          );
        });
  }
}
