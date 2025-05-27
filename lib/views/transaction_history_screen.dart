import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/category/category_state.dart';
import '../bloc/transaction/transaction_bloc.dart';
import '../bloc/transaction/transaction_event.dart';
import '../bloc/transaction/transaction_state.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../widgets/transaction_item.dart';

class TransactionHistoryScreen extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  const TransactionHistoryScreen({
    Key? key,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  Map<int, Category> _categoriesMap = {};

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    _loadCategories();
  }

  @override
  void didUpdateWidget(TransactionHistoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startDate != widget.startDate ||
        oldWidget.endDate != widget.endDate) {
      _loadTransactions();
    }
  }

  void _loadTransactions() {
    context.read<TransactionBloc>().add(
      LoadTransactions(
        startDate: widget.startDate,
        endDate: widget.endDate,
      ),
    );
  }

  void _loadCategories() {
    context.read<CategoryBloc>().add(const LoadCategories());
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _loadTransactions();
      },
      child: BlocListener<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategoriesLoaded) {
            setState(() {
              _categoriesMap = {
                for (var category in state.categories)
                  category.id!: category
              };
            });
          }
        },
        child: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is TransactionLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TransactionsLoaded) {
              if (state.transactions.isEmpty) {
                return const Center(
                  child: Text('Brak transakcji w wybranym okresie'),
                );
              }

              // Group transactions by date
              final Map<String, List<Transaction>> groupedTransactions = {};
              for (final transaction in state.transactions) {
                final dateStr = DateFormat('yyyy-MM-dd').format(transaction.date);
                if (!groupedTransactions.containsKey(dateStr)) {
                  groupedTransactions[dateStr] = [];
                }
                groupedTransactions[dateStr]!.add(transaction);
              }

              // Sort dates in descending order
              final dates = groupedTransactions.keys.toList()
                ..sort((a, b) => b.compareTo(a));

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: dates.length,
                itemBuilder: (context, index) {
                  final date = dates[index];
                  final transactions = groupedTransactions[date]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          DateFormat.yMMMd().format(DateTime.parse(date)),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      ...transactions.map((transaction) {
                        final category = _categoriesMap[transaction.categoryId];
                        return TransactionItem(
                          transaction: transaction,
                          category: category,
                          onDelete: () {
                            context.read<TransactionBloc>().add(
                              DeleteTransaction(transaction.id!),
                            );
                            _loadTransactions();
                          },
                        );
                      }).toList(),
                      const Divider(),
                    ],
                  );
                },
              );
            } else if (state is TransactionOperationFailure) {
              return Center(
                child: Text('Błąd: ${state.message}'),
              );
            } else {
              return const Center(
                child: Text('Wybierz miesiąc, aby zobaczyć historię transakcji'),
              );
            }
          },
        ),
      ),
    );
  }
}