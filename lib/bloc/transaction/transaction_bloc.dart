import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/transaction_repository.dart';
import './transaction_event.dart';
import './transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _transactionRepository;

  TransactionBloc(this._transactionRepository) : super(TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
  }

  Future<void> _onLoadTransactions(
      LoadTransactions event,
      Emitter<TransactionState> emit,
      ) async {
    emit(TransactionLoading());
    try {
      final transactions = await _transactionRepository.getTransactions(
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(TransactionsLoaded(transactions));
    } catch (e) {
      emit(TransactionOperationFailure(e.toString()));
    }
  }

  Future<void> _onAddTransaction(
      AddTransaction event,
      Emitter<TransactionState> emit,
      ) async {
    emit(TransactionLoading());
    try {
      await _transactionRepository.insertTransaction(event.transaction);
      emit(TransactionOperationSuccess());
      final transactions = await _transactionRepository.getTransactions();
      emit(TransactionsLoaded(transactions));
    } catch (e) {
      emit(TransactionOperationFailure(e.toString()));
    }
  }

  Future<void> _onUpdateTransaction(
      UpdateTransaction event,
      Emitter<TransactionState> emit,
      ) async {
    emit(TransactionLoading());
    try {
      await _transactionRepository.updateTransaction(event.transaction);
      emit(TransactionOperationSuccess());
      final transactions = await _transactionRepository.getTransactions();
      emit(TransactionsLoaded(transactions));
    } catch (e) {
      emit(TransactionOperationFailure(e.toString()));
    }
  }

  Future<void> _onDeleteTransaction(
      DeleteTransaction event,
      Emitter<TransactionState> emit,
      ) async {
    emit(TransactionLoading());
    try {
      await _transactionRepository.deleteTransaction(event.id);
      emit(TransactionOperationSuccess());
      final transactions = await _transactionRepository.getTransactions();
      emit(TransactionsLoaded(transactions));
    } catch (e) {
      emit(TransactionOperationFailure(e.toString()));
    }
  }
}