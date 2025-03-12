import 'dart:async';
import 'package:budzet/models/category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/transaction.dart';
import '../../repository/transaction_repository.dart';
import './transaction_event.dart';
import './transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository transactionRepository;

  TransactionBloc({required this.transactionRepository}) : super(TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
    on<ChangeMonth>(_onChangeMonth);
  }

  Future<void> _onLoadTransactions(
      LoadTransactions event,
      Emitter<TransactionState> emit,
      ) async {
    emit(TransactionLoading());
    try {
      final transactions = await transactionRepository.loadTransactions();
      final monthTransactions = _filterTransactionsByMonth(transactions, event.month);
      final monthTransactionExpenses = monthTransactions.where((element) => element.isCost == true).toList();
      final monthTransactionIncomes = monthTransactions.where((element) => element.isCost == false).toList();
      final statistics = _calculateStatistics(monthTransactions);

      emit(TransactionLoaded(
        transactions: monthTransactions,
        transactionsExpenses: monthTransactionExpenses,
        transactionsIncomes: monthTransactionIncomes,
        currentMonth: event.month,
        totalIncome: statistics['totalIncome'],
        totalExpense: statistics['totalExpense'],
        expenseByCategory: statistics['expenseByCategory'],
      ));
    } catch (e) {
      emit(TransactionError('Failed to load transactions: ${e.toString()}'));
    }
  }

  Future<void> _onAddTransaction(
      AddTransaction event,
      Emitter<TransactionState> emit,
      ) async {
    try {
      if (state is TransactionLoaded) {
        final currentState = state as TransactionLoaded;
        final updatedTransactions = await transactionRepository.addTransaction(event.transaction);
        final monthTransactions = _filterTransactionsByMonth(
            updatedTransactions,
            currentState.currentMonth
        );
        final monthTransactionExpenses = monthTransactions.where((element) => element.isCost == true).toList();
        final monthTransactionIncomes = monthTransactions.where((element) => element.isCost == false).toList();
        final statistics = _calculateStatistics(monthTransactions);

        emit(TransactionLoaded(
          transactions: monthTransactions,
          transactionsExpenses: monthTransactionExpenses,
          transactionsIncomes: monthTransactionIncomes,
          currentMonth: currentState.currentMonth,
          totalIncome: statistics['totalIncome'],
          totalExpense: statistics['totalExpense'],
          expenseByCategory: statistics['expenseByCategory'],
        ));
      }
    } catch (e) {
      emit(TransactionError('Failed to add transaction: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateTransaction(
      UpdateTransaction event,
      Emitter<TransactionState> emit,
      ) async {
    try {
      if (state is TransactionLoaded) {
        final currentState = state as TransactionLoaded;
        final updatedTransactions = await transactionRepository.updateTransaction(event.transaction);
        final monthTransactions = _filterTransactionsByMonth(
            updatedTransactions,
            currentState.currentMonth
        );
        final monthTransactionExpenses = monthTransactions.where((element) => element.isCost == true).toList();
        final monthTransactionIncomes = monthTransactions.where((element) => element.isCost == false).toList();
        final statistics = _calculateStatistics(monthTransactions);

        emit(TransactionLoaded(
          transactions: monthTransactions,
          transactionsExpenses: monthTransactionExpenses,
          transactionsIncomes: monthTransactionIncomes,
          currentMonth: currentState.currentMonth,
          totalIncome: statistics['totalIncome'],
          totalExpense: statistics['totalExpense'],
          expenseByCategory: statistics['expenseByCategory'],
        ));
      }
    } catch (e) {
      emit(TransactionError('Failed to update transaction: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteTransaction(
      DeleteTransaction event,
      Emitter<TransactionState> emit,
      ) async {
    try {
      if (state is TransactionLoaded) {
        final currentState = state as TransactionLoaded;
        final updatedTransactions = await transactionRepository.deleteTransaction(event.id);
        final monthTransactions = _filterTransactionsByMonth(
            updatedTransactions,
            currentState.currentMonth
        );
        final monthTransactionExpenses = monthTransactions.where((element) => element.isCost == true).toList();
        final monthTransactionIncomes = monthTransactions.where((element) => element.isCost == false).toList();
        final statistics = _calculateStatistics(monthTransactions);

        emit(TransactionLoaded(
          transactions: monthTransactions,
          transactionsExpenses: monthTransactionExpenses,
          transactionsIncomes: monthTransactionIncomes,
          currentMonth: currentState.currentMonth,
          totalIncome: statistics['totalIncome'],
          totalExpense: statistics['totalExpense'],
          expenseByCategory: statistics['expenseByCategory'],
        ));
      }
    } catch (e) {
      emit(TransactionError('Failed to delete transaction: ${e.toString()}'));
    }
  }

  Future<void> _onChangeMonth(
      ChangeMonth event,
      Emitter<TransactionState> emit,
      ) async {
    try {
      if (state is TransactionLoaded) {
        final currentState = state as TransactionLoaded;
        final allTransactions = await transactionRepository.loadTransactions();
        final monthTransactions = _filterTransactionsByMonth(allTransactions, event.month);
        final monthTransactionExpenses = monthTransactions.where((element) => element.isCost == true).toList();
        final monthTransactionIncomes = monthTransactions.where((element) => element.isCost == false).toList();
        final statistics = _calculateStatistics(monthTransactions);

        emit(TransactionLoaded(
          transactions: monthTransactions,
          transactionsExpenses: monthTransactionExpenses,
          transactionsIncomes: monthTransactionIncomes,
          currentMonth: event.month,
          totalIncome: statistics['totalIncome'],
          totalExpense: statistics['totalExpense'],
          expenseByCategory: statistics['expenseByCategory'],
        ));
      }
    } catch (e) {
      emit(TransactionError('Failed to change month: ${e.toString()}'));
    }
  }

  List<Transaction> _filterTransactionsByMonth(List<Transaction> transactions, DateTime month) {
    return transactions.where((transaction) =>
    transaction.date.month == month.month &&
        transaction.date.year == month.year
    ).toList();
  }

  Map<String, dynamic> _calculateStatistics(List<Transaction> transactions) {
    double totalIncome = 0;
    double totalExpense = 0;
    Map<Category, double> expenseByCategory = {};

    for (var transaction in transactions) {
      if (transaction.isCost) {
        totalExpense += transaction.amount;

        // Update category totals
        if (expenseByCategory.containsKey(transaction.category)) {
          expenseByCategory[transaction.category] =
              expenseByCategory[transaction.category]! + transaction.amount;
        } else {
          expenseByCategory[transaction.category] = transaction.amount;
        }
      } else {
        totalIncome += transaction.amount;
      }
    }

    return {
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'expenseByCategory': expenseByCategory,
    };
  }
}