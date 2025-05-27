

class Category {
  final int? id;
  final String name;
  final bool isDefault;
  final int? monthYear; // Format: YYYYMM, null for default categories
  //final double? amount;
  final double? plannedAmount;
  final bool isExpense;

  const Category({
    this.id,
    required this.name,
    required this.isDefault,
    this.monthYear,
    this.plannedAmount,
    required this.isExpense,
  });


  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      isDefault: map['isDefault'] == 1,
      monthYear: map['monthYear'],
      plannedAmount: map['plannedAmount'],
      isExpense: map['isExpense'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isDefault': isDefault ? 1 : 0,
      'monthYear': monthYear,
      'plannedAmount': plannedAmount,
      'isExpense': isExpense ? 1 : 0,
    };
  }

  Category copyWith({
    int? id,
    String? name,
    bool? isDefault,
    int? monthYear,
    double? plannedAmount,
    bool? isExpense,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      isDefault: isDefault ?? this.isDefault,
      monthYear: monthYear ?? this.monthYear,
      plannedAmount: plannedAmount ?? this.plannedAmount,
      isExpense: isExpense ?? this.isExpense,
    );
  }
}