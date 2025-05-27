import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/budget/budget_bloc.dart';
import '../bloc/budget/budget_event.dart';
import '../bloc/budget/budget_state.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_state.dart';
import '../widgets/category_item.dart';
import 'budget_summary_widget.dart';

// TODO dodać plannedAmount jako 0 w domyślnych kategoriach
// TODO poprawić by edycja domyślnej kategorii zastępowała ją, a nie dodawała nową

class BudgetSummaryScreen extends StatefulWidget {
  final int monthYear;

  const BudgetSummaryScreen({
    Key? key,
    required this.monthYear,
  }) : super(key: key);

  @override
  State<BudgetSummaryScreen> createState() => _BudgetSummaryScreenState();
}

class _BudgetSummaryScreenState extends State<BudgetSummaryScreen> {
  @override
  void initState() {
    super.initState();
    _loadBudgetData();
  }

  @override
  void didUpdateWidget(BudgetSummaryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.monthYear != widget.monthYear) {
      _loadBudgetData();
    }
  }

  void _loadBudgetData() {
    context.read<BudgetBloc>().add(LoadBudgetSummary(widget.monthYear));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _loadBudgetData();
      },
      child: BlocListener<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategoryOperationSuccess) {
            _loadBudgetData();
          }
        },
        child: BlocBuilder<BudgetBloc, BudgetState>(
          builder: (context, state) {
            if (state is BudgetLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is BudgetSummaryLoaded) {
              final summary = state.summary;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overall summary
                    BudgetSummaryWidget(
                      totalIncome: summary.totalIncome,
                      totalExpenses: summary.totalExpenses,
                    ),
                    const SizedBox(height: 24),
        
                    // Expenses
                    const Text(
                      'Wydatki',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (summary.expenseCategories.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: Text('Brak wydatków w tym miesiącu'),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: summary.expenseCategories.length,
                        itemBuilder: (context, index) {
                          final categorySummary = summary.expenseCategories[index];
                          return CategoryItem(
                            categorySummary: categorySummary,
                            monthYear: widget.monthYear,
                            onCategoryUpdated: _loadBudgetData,
                          );
                        },
                      ),
        
                    const SizedBox(height: 24),
        
                    // Income
                    const Text(
                      'Przychody',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (summary.incomeCategories.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: Text('Brak przychodów w tym miesiącu'),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: summary.incomeCategories.length,
                        itemBuilder: (context, index) {
                          final categorySummary = summary.incomeCategories[index];
                          return CategoryItem(
                            categorySummary: categorySummary,
                            monthYear: widget.monthYear,
                            onCategoryUpdated: _loadBudgetData,
                          );
                        },
                      ),
                  ],
                ),
              );
            } else if (state is BudgetOperationFailure) {
              return Center(
                child: Text('Błąd: ${state.message}'),
              );
            } else {
              return const Center(
                child: Text('Wybierz miesiąc, aby zobaczyć podsumowanie budżetu'),
              );
            }
          },
        ),
      ),
    );
  }
}