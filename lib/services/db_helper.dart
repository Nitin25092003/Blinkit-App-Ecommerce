import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/product.dart';

class DBHelper {
  static Database? _db;

  static Future<void> initDb() async {
    if (_db != null) return;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'blinkit_api.db');

    _db = await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          email TEXT UNIQUE,
          password TEXT,
          profileImagePath TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE products (
          id INTEGER PRIMARY KEY,
          title TEXT,
          price REAL,
          description TEXT,
          category TEXT,
          image TEXT
        )
      ''');
    });
  }

  // Users
  static Future<int> insertUser(User u) async {
    final db = _db!;
    return await db.insert('users', u.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<User?> getUserByEmail(String email) async {
    final db = _db!;
    final res = await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (res.isEmpty) return null;
    return User.fromMap(res.first);
  }

  static Future<User?> getUserById(int id) async {
    final db = _db!;
    final res = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (res.isEmpty) return null;
    return User.fromMap(res.first);
  }

  static Future<int> updateUser(User u) async {
    final db = _db!;
    return await db.update('users', u.toMap(), where: 'id = ?', whereArgs: [u.id]);
  }

  // Products cache
  static Future<void> insertProductsBatch(List<Product> products) async {
    final db = _db!;
    final batch = db.batch();
    for (var p in products) {
      batch.insert('products', p.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  static Future<List<Product>> getProductsByCategory(String category) async {
    final db = _db!;
    final res = await db.query('products', where: 'category = ?', whereArgs: [category]);
    return res.map((e) => Product.fromMap(e)).toList();
  }

  static Future<List<Product>> getAllProducts() async {
    final db = _db!;
    final res = await db.query('products');
    return res.map((e) => Product.fromMap(e)).toList();
  }
}
