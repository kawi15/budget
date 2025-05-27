import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/budget.dart';
import '../../repository/category_repository.dart';
import '../../repository/transaction_repository.dart';
import 'budget_event.dart';
import 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final TransactionRepository transactionRepository;
  final CategoryRepository categoryRepository;

  BudgetBloc({
    required this.transactionRepository,
    required this.categoryRepository,
  }) : super(BudgetInitial()) {
    on<LoadBudgetSummary>(_onLoadBudgetSummary);
  }

  Future<void> _onLoadBudgetSummary(
      LoadBudgetSummary event,
      Emitter<BudgetState> emit,
      ) async {
    emit(BudgetLoading());
    try {
      final monthYear = event.monthYear;
      final year = monthYear ~/ 100;
      final month = monthYear % 100;

      final startDate = DateTime(year, month, 1);
      final endDate = DateTime(year, month + 1, 0);

      // Get categories for this month (including default ones)
      final expenseCategories = await categoryRepository.getCategoriesForMonth(
        monthYear,
        isExpense: true,
      );

      final incomeCategories = await categoryRepository.getCategoriesForMonth(
        monthYear,
        isExpense: false,
      );

      // Calculate actual amounts for each category
      final expenseSummaries = await Future.wait(
        expenseCategories.map((category) async {
          final amount = await transactionRepository.getAmountByCategory(
            category.id!,
            startDate,
            endDate,
          );

          return CategorySummary(
            category: category,
            actualAmount: amount,
            plannedAmount: category.plannedAmount,
            percentage: category.plannedAmount != null && category.plannedAmount! > 0
                ? (amount / category.plannedAmount!) * 100
                : 0,
          );
        }),
      );

      final incomeSummaries = await Future.wait(
        incomeCategories.map((category) async {
          final amount = await transactionRepository.getAmountByCategory(
            category.id!,
            startDate,
            endDate,
          );

          return CategorySummary(
            category: category,
            actualAmount: amount,
            plannedAmount: category.plannedAmount,
            percentage: category.plannedAmount != null && category.plannedAmount! > 0
                ? (amount / category.plannedAmount!) * 100
                : 0,
          );
        }),
      );

      // Calculate totals
      final totalExpenses = expenseSummaries.fold<double>(
          0, (sum, summary) => sum + summary.actualAmount);

      final totalIncome = incomeSummaries.fold<double>(
          0, (sum, summary) => sum + summary.actualAmount);

      final budgetSummary = BudgetSummary(
        expenseCategories: expenseSummaries,
        incomeCategories: incomeSummaries,
        totalExpenses: totalExpenses,
        totalIncome: totalIncome,
      );

      emit(BudgetSummaryLoaded(budgetSummary, monthYear));
    } catch (e) {
      emit(BudgetOperationFailure(e.toString()));
    }
  }
}