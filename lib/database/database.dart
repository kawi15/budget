import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  static Database? _database;

  factory AppDatabase() => _instance;

  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    await _initDefaultCategories(_database!);
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'budget_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
    CREATE TABLE categories(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      isDefault INTEGER NOT NULL,
      monthYear INTEGER,
      plannedAmount REAL,
      isExpense INTEGER NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE transactions(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      amount REAL NOT NULL,
      date TEXT NOT NULL,
      categoryId INTEGER NOT NULL,
      isExpense INTEGER NOT NULL,
      FOREIGN KEY (categoryId) REFERENCES categories (id)
        ON DELETE CASCADE
    )
    ''');
  }

  Future<void> _initDefaultCategories(Database db) async {
    final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM categories WHERE isDefault = 1')
    );

    if (count == 0) {
      // Default expense categories
      await db.insert('categories', {
        'name': 'Jedzenie',
        'isDefault': 1,
        'isExpense': 1,
      });
      await db.insert('categories', {
        'name': 'Transport',
        'isDefault': 1,
        'isExpense': 1,
      });
      await db.insert('categories', {
        'name': 'Rachunki',
        'isDefault': 1,
        'isExpense': 1,
      });
      await db.insert('categories', {
        'name': 'Rozrywka',
        'isDefault': 1,
        'isExpense': 1,
      });

      // Default income categories
      await db.insert('categories', {
        'name': 'Wynagrodzenie',
        'isDefault': 1,
        'isExpense': 0,
      });
      await db.insert('categories', {
        'name': 'Premia',
        'isDefault': 1,
        'isExpense': 0,
      });
      await db.insert('categories', {
        'name': 'Inne przychody',
        'isDefault': 1,
        'isExpense': 0,
      });
    }
  }
}