import 'package:sqflite/sqflite.dart';
import 'package:budzet/models/category.dart';

class CategoryRepository {
  final Database _database;

  CategoryRepository(this._database);

  Future<List<Category>> getCategories({bool? isExpense, int? monthYear}) async {
    String whereClause = '';
    List<dynamic> whereArgs = [];

    if (isExpense != null) {
      whereClause += 'isExpense = ?';
      whereArgs.add(isExpense ? 1 : 0);
    }

    if (monthYear != null) {
      if (whereClause.isNotEmpty) {
        whereClause += ' AND ';
      }
      whereClause += '(monthYear = ? OR (monthYear IS NULL AND isDefault = 1))';
      whereArgs.add(monthYear);
    }

    final List<Map<String, dynamic>> maps = await _database.query(
      'categories',
      where: whereClause.isNotEmpty ? whereClause : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: 'name ASC',
    );

    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

  Future<List<Category>> getDefaultCategories({bool? isExpense, int? monthYear}) async {
    String whereClause = 'monthYear IS NULL AND isDefault = 1';

    final List<Map<String, dynamic>> maps = await _database.query(
      'categories',
      where: whereClause.isNotEmpty ? whereClause : null,
      orderBy: 'name ASC',
    );

    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

  Future<int> insertCategory(Category category) async {
    return await _database.insert(
      'categories',
      category.toMap(),
    );
  }

  Future<int> updateCategory(Category category) async {
    return await _database.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> deleteCategory(int id) async {
    return await _database.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Category?> getCategoryById(int id) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Category.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Category>> getCategoriesForMonth(int monthYear, {bool? isExpense}) async {
    String whereClause = '(monthYear = ? OR (isDefault = 1 AND monthYear IS NULL))';
    List<dynamic> whereArgs = [monthYear];

    if (isExpense != null) {
      whereClause += ' AND isExpense = ?';
      whereArgs.add(isExpense ? 1 : 0);
    }

    final List<Map<String, dynamic>> maps = await _database.query(
      'categories',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'name ASC',
    );

    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

  Future<int> updateOrCreateMonthlyCategory(Category category, int monthYear) async {
    // Check if there's already a monthly version of this category
    final List<Map<String, dynamic>> maps = await _database.query(
      'categories',
      where: 'name = ? AND monthYear = ? AND isExpense = ?',
      whereArgs: [category.name, monthYear, category.isExpense ? 1 : 0],
    );

    if (maps.isNotEmpty) {
      final existingCategory = Category.fromMap(maps.first);
      final updatedCategory = existingCategory.copyWith(
        plannedAmount: category.plannedAmount,
      );
      return await updateCategory(updatedCategory);
    } else {
      // TODO poprawić by edycja domyślnej kategorii zastępowała ją, a nie dodawała nową - zmienić sposób pobierania kategorii?
      // TODO jakoś muszę rozpoznać, że to jest ta sama kategoria co defaultowa, tylko jak? ID, isDefault, monthYear, wszystko będzie inne, tylko nazwa się będzie zgadzać
      // TODO muszę rozpoznawać, po nazwie, a przy dodawaniu nowej kategorii nie pozwalać na dodanie drugiej o takiej samej nazwie
      final monthlyCategory = Category(
        id: await getNextTransactionId(),
        name: category.name,
        isDefault: false,
        monthYear: monthYear,
        plannedAmount: category.plannedAmount,
        isExpense: category.isExpense,
      );
      return await insertCategory(monthlyCategory);
    }
  }

  Future<int> getNextTransactionId() async {
    final List<Map<String, dynamic>> result = await _database.rawQuery('SELECT MAX(id) as maxId FROM categories');
    final maxId = result.first['maxId'] as int?;
    return (maxId ?? 0) + 1;
  }
}