import 'package:budzet/models/category.dart';
import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final int id;
  final String name;
  final double amount;
  final Category category;
  final DateTime date;
  final bool isCost;

  const Transaction({
    required this.id,
    required this.name,
    required this.amount,
    required this.category,
    required this.date,
    required this.isCost
  });

  @override
  List<Object> get props => [id, name, amount, date, category, isCost];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'is_cost': isCost,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      category: json['category'],
      isCost: json['is_cost'],
    );
  }

  Transaction copyWith({
    int? id,
    String? name,
    double? amount,
    DateTime? date,
    Category? category,
    bool? isCost,
  }) {
    return Transaction(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      isCost: isCost ?? this.isCost,
    );
  }
}