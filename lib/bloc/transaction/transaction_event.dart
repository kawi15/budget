import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../models/transaction.dart';

@immutable
abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class LoadTransactions extends TransactionEvent {
  final DateTime month;

  const LoadTransactions(this.month);

  @override
  List<Object> get props => [month];
}

class AddTransaction extends TransactionEvent {
  final Transaction transaction;

  const AddTransaction(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class UpdateTransaction extends TransactionEvent {
  final Transaction transaction;

  const UpdateTransaction(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class DeleteTransaction extends TransactionEvent {
  final int id;

  const DeleteTransaction(this.id);

  @override
  List<Object> get props => [id];
}

class ChangeMonth extends TransactionEvent {
  final DateTime month;

  const ChangeMonth(this.month);

  @override
  List<Object> get props => [month];
}