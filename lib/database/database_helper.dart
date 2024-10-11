import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tags.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tags (
        id INTEGER PRIMARY KEY,
        tag TEXT NOT NULL,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  Future<int> addTag(String tag) async {
    Database db = await instance.database;
    return await db.insert('tags', {'tag': tag});
  }

  Future<List<Map<String, dynamic>>> getTags() async {
    Database db = await instance.database;
    return await db.query('tags', orderBy: 'timestamp DESC');
  }

  Future<void> deleteOldTags() async {
    Database db = await instance.database;
    // пока указала время хранения 30 дней, попоравим, если что
        await db.delete('tags', where: 'timestamp < ?', whereArgs: [DateTime.now().subtract(Duration(days: 30)).toIso8601String()]); 
  }
}
