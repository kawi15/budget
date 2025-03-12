import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';

class TransactionRepository {
  static const String _storageKey = 'budget_transactions';

  Future<List<Transaction>> loadTransactions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? transactionsJson = prefs.getString(_storageKey);

      if (transactionsJson == null) {
        return [];
      }

      List<dynamic> decodedJson = jsonDecode(transactionsJson);
      return decodedJson.map((item) => Transaction.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to load transactions: ${e.toString()}');
    }
  }

  Future<List<Transaction>> addTransaction(Transaction transaction) async {
    try {
      final List<Transaction> currentTransactions = await loadTransactions();
      final List<Transaction> updatedTransactions = List.from(currentTransactions)..add(transaction);
      await _saveTransactions(updatedTransactions);
      return updatedTransactions;
    } catch (e) {
      throw Exception('Failed to add transaction: ${e.toString()}');
    }
  }

  Future<List<Transaction>> updateTransaction(Transaction updatedTransaction) async {
    try {
      final List<Transaction> currentTransactions = await loadTransactions();
      final List<Transaction> updatedTransactions = currentTransactions.map((transaction) {
        return transaction.id == updatedTransaction.id ? updatedTransaction : transaction;
      }).toList();

      await _saveTransactions(updatedTransactions);
      return updatedTransactions;
    } catch (e) {
      throw Exception('Failed to update transaction: ${e.toString()}');
    }
  }

  Future<List<Transaction>> deleteTransaction(int id) async {
    try {
      final List<Transaction> currentTransactions = await loadTransactions();
      final List<Transaction> updatedTransactions = currentTransactions
          .where((transaction) => transaction.id != id)
          .toList();

      await _saveTransactions(updatedTransactions);
      return updatedTransactions;
    } catch (e) {
      throw Exception('Failed to delete transaction: ${e.toString()}');
    }
  }

  Future<void> _saveTransactions(List<Transaction> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedJson = jsonEncode(
        transactions.map((transaction) => transaction.toJson()).toList()
    );
    await prefs.setString(_storageKey, encodedJson);
  }
}