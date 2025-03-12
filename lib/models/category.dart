import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final double amount;
  final double plannedAmount;

  const Category({
    required this.id,
    required this.name,
    required this.amount,
    required this.plannedAmount
  });

  @override
  List<Object> get props => [id, name, amount, plannedAmount];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'planned_amount': plannedAmount,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
      plannedAmount: json['planned_amount'],
    );
  }
}