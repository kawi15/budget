import 'package:equatable/equatable.dart';

import '../../models/budget.dart';

abstract class BudgetState extends Equatable {
  const BudgetState();

  @override
  List<Object?> get props => [];
}

class BudgetInitial extends BudgetState {}

class BudgetLoading extends BudgetState {}

class BudgetSummaryLoaded extends BudgetState {
  final BudgetSummary summary;
  final int monthYear;

  const BudgetSummaryLoaded(this.summary, this.monthYear);

  @override
  List<Object> get props => [summary, monthYear];
}

class BudgetOperationFailure extends BudgetState {
  final String message;

  const BudgetOperationFailure(this.message);

  @override
  List<Object> get props => [message];
}