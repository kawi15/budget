import 'package:budzet/models/category.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../models/transaction.dart';

@immutable
abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<Transaction> transactions;
  final List<Transaction> transactionsExpenses;
  final List<Transaction> transactionsIncomes;
  final DateTime currentMonth;
  final double totalIncome;
  final double totalExpense;
  final Map<Category, double> expenseByCategory;

  const TransactionLoaded({
    required this.transactions,
    required this.transactionsExpenses,
    required this.transactionsIncomes,
    required this.currentMonth,
    required this.totalIncome,
    required this.totalExpense,
    required this.expenseByCategory,
  });

  @override
  List<Object> get props => [transactions, currentMonth, totalIncome, totalExpense, expenseByCategory];

  TransactionLoaded copyWith({
    List<Transaction>? transactions,
    List<Transaction>? transactionsExpenses,
    List<Transaction>? transactionsIncomes,
    DateTime? currentMonth,
    double? totalIncome,
    double? totalExpense,
    Map<Category, double>? expenseByCategory,
  }) {
    return TransactionLoaded(
      transactions: transactions ?? this.transactions,
      transactionsExpenses: transactionsExpenses ?? this.transactionsExpenses,
      transactionsIncomes: transactionsIncomes ?? this.transactionsIncomes,
      currentMonth: currentMonth ?? this.currentMonth,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      expenseByCategory: expenseByCategory ?? this.expenseByCategory,
    );
  }
}

class TransactionError extends TransactionState {
  final String message;

  const TransactionError(this.message);

  @override
  List<Object> get props => [message];
}
