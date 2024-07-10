import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const userTable = '''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''';

    await db.execute(userTable);

    await db.insert('users', {'username': 'satrio', 'password': 'mukti'});
  }

  Future<User?> getUser(String username, String password) async {
    if (kIsWeb) {
      // Ketika dijalankan di web, gunakan shared preferences
      final prefs = await SharedPreferences.getInstance();
      final storedUsername = prefs.getString('username');
      final storedPassword = prefs.getString('password');

      if (storedUsername == username && storedPassword == password) {
        return User(username: storedUsername!, password: storedPassword!);
      } else {
        return null;
      }
    } else {
      // Ketika dijalankan di platform selain web, gunakan database
      final db = await instance.database;

      final maps = await db.query(
        'users',
        columns: ['username', 'password'],
        where: 'username = ? AND password = ?',
        whereArgs: [username, password],
      );

      if (maps.isNotEmpty) {
        return User.fromMap(maps.first);
      } else {
        return null;
      }
    }
  }

  Future<int> updateUserPassword(String username, String newPassword) async {
    if (kIsWeb) {
      // Ketika dijalankan di web, perbarui shared preferences
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString('username') == username) {
        await prefs.setString('password', newPassword);
        return 1;
      }
      return 0;
    } else {
      // Ketika dijalankan di platform selain web, perbarui database
      final db = await instance.database;

      return await db.update(
        'users',
        {'password': newPassword},
        where: 'username = ?',
        whereArgs: [username],
      );
    }
  }
}
