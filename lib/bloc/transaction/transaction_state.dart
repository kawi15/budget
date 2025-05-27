import 'package:budzet/models/category.dart';
import 'package:equatable/equatable.dart';
import '../../models/transaction.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionsLoaded extends TransactionState {
  final List<Transaction> transactions;

  const TransactionsLoaded(this.transactions);

  @override
  List<Object> get props => [transactions];
}

class TransactionOperationSuccess extends TransactionState {}

class TransactionOperationFailure extends TransactionState {
  final String message;

  const TransactionOperationFailure(this.message);

  @override
  List<Object> get props => [message];
}
