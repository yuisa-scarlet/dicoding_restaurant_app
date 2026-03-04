import 'package:dicoding_restaurant_app/core/config.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dicoding_restaurant_app/shared/models/restaurant.dart';

class SqliteDatabaseService {
  static const String _databaseName = Config.databaseName;
  static const String _tableName = Config.tableName;
  static const int _dbVersion = 1;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    return openDatabase(
      _databaseName,
      version: _dbVersion,
      onCreate: (Database database, int version) async {
        await createTables(database);
      },
    );
  }

  Future<void> createTables(Database database) async {
    await database.execute("""CREATE TABLE $_tableName(
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        pictureId TEXT,
        city TEXT,
        rating REAL
      )
      """);
  }

  Future<void> insertFavorite(Restaurant restaurant) async {
    final db = await database;
    await db.insert(
      _tableName,
      restaurant.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Restaurant>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(_tableName);
    return results.map((res) => Restaurant.fromMap(res)).toList();
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isFavorite(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty;
  }
}
