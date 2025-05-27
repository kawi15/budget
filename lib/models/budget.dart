import 'category.dart';

class BudgetSummary {
  final List<CategorySummary> expenseCategories;
  final List<CategorySummary> incomeCategories;
  final double totalExpenses;
  final double totalIncome;

  BudgetSummary({
    required this.expenseCategories,
    required this.incomeCategories,
    required this.totalExpenses,
    required this.totalIncome,
  });
}

class CategorySummary {
  final Category category;
  final double actualAmount;
  final double? plannedAmount;
  final double percentage; // Percentage of actual/planned

  CategorySummary({
    required this.category,
    required this.actualAmount,
    this.plannedAmount,
    required this.percentage,
  });
}