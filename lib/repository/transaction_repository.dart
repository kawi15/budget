import 'package:sqflite/sqflite.dart';
import 'package:budzet/models/transaction.dart' as model;

class TransactionRepository {
  final Database _database;

  TransactionRepository(this._database);

  Future<List<model.Transaction>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final List<Map<String, dynamic>> maps;

    if (startDate != null && endDate != null) {
      maps = await _database.query(
        'transactions',
        where: 'date BETWEEN ? AND ?',
        whereArgs: [
          startDate.toIso8601String(),
          endDate.toIso8601String(),
        ],
        orderBy: 'date DESC',
      );
    } else {
      maps = await _database.query(
        'transactions',
        orderBy: 'date DESC',
      );
    }

    return List.generate(maps.length, (i) {
      return model.Transaction.fromMap(maps[i]);
    });
  }

  Future<int> insertTransaction(model.Transaction transaction) async {
    return await _database.insert(
      'transactions',
      transaction.toMap(),
    );
  }

  Future<int> updateTransaction(model.Transaction transaction) async {
    return await _database.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    return await _database.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<model.Transaction>> getTransactionsByCategory(int categoryId) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      'transactions',
      where: 'categoryId = ?',
      whereArgs: [categoryId],
    );

    return List.generate(maps.length, (i) {
      return model.Transaction.fromMap(maps[i]);
    });
  }

  Future<double> getAmountByCategory(int categoryId, DateTime startDate, DateTime endDate) async {
    final result = await _database.rawQuery(
      '''
      SELECT SUM(amount) as total
      FROM transactions
      WHERE categoryId = ? AND date BETWEEN ? AND ?
      ''',
      [
        categoryId,
        startDate.toIso8601String(),
        endDate.toIso8601String(),
      ],
    );

    return result.first['total'] as double? ?? 0.0;
  }
}