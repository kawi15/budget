import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/budget/budget_bloc.dart';
import '../bloc/budget/budget_event.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../models/budget.dart';

class CategoryItem extends StatelessWidget {
  final CategorySummary categorySummary;
  final int monthYear;
  final VoidCallback onCategoryUpdated;

  const CategoryItem({
    Key? key,
    required this.categorySummary,
    required this.monthYear,
    required this.onCategoryUpdated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'pl_PL',
      symbol: 'zł',
      decimalDigits: 2,
    );

    final category = categorySummary.category;
    final plannedAmount = categorySummary.plannedAmount;
    final actualAmount = categorySummary.actualAmount;
    final percentage = categorySummary.percentage.isFinite
        ? categorySummary.percentage
        : 0.0;

    // Calculate progress color based on expense/income and percentage
    Color progressColor;
    if (category.isExpense) {
      progressColor = percentage <= 80
          ? Colors.green
          : percentage <= 100
          ? Colors.orange
          : Colors.red;
    } else {
      progressColor = percentage >= 100 ? Colors.green : Colors.blue;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    category.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  currencyFormat.format(actualAmount),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: category.isExpense ? Colors.red : Colors.green,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _showBudgetDialog(context),
                ),
              ],
            ),
            if (plannedAmount != null && plannedAmount > 0) ...[
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Zaplanowano: ${currencyFormat.format(plannedAmount)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: progressColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: plannedAmount > 0
                    ? (actualAmount / plannedAmount).clamp(0.0, 2.0) / 2
                    : 0,
                backgroundColor: Colors.grey[200],
                color: progressColor,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showBudgetDialog(BuildContext context) {
    final category = categorySummary.category;
    final controller = TextEditingController(
      text: categorySummary.plannedAmount?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Budżet dla: ${category.name}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Zaplanowana kwota',
            hintText: 'Wprowadź kwotę',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Anuluj'),
          ),
          TextButton(
            onPressed: () {
              double? amount;
              if (controller.text.isNotEmpty) {
                try {
                  amount = double.parse(controller.text);
                } catch (_) {
                  // Handle invalid input
                  return;
                }
              }

              final updatedCategory = category.copyWith(
                plannedAmount: amount,
              );


              context.read<CategoryBloc>().add(
                SetMonthlyBudget(updatedCategory, monthYear),
              );

              Navigator.pop(context);

            },
            child: const Text('Zapisz'),
          ),
        ],
      ),
    );
  }
}