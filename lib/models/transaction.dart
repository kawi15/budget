import 'package:budzet/models/category.dart';
import 'package:equatable/equatable.dart';

class Transaction {
  final int? id;
  final String title;
  final double amount;
  final int? categoryId;
  final DateTime date;
  final bool isExpense;

  const Transaction({
    this.id,
    required this.title,
    required this.amount,
    this.categoryId,
    required this.date,
    required this.isExpense
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      categoryId: map['categoryId'],
      isExpense: map['isExpense'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'categoryId': categoryId,
      'isExpense': isExpense ? 1 : 0,
    };
  }

  Transaction copyWith({
    int? id,
    String? title,
    double? amount,
    DateTime? date,
    int? categoryId,
    bool? isExpense,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      categoryId: categoryId ?? this.categoryId,
      isExpense: isExpense ?? this.isExpense,
    );
  }
}