import 'package:equatable/equatable.dart';

abstract class BudgetEvent extends Equatable {
  const BudgetEvent();

  @override
  List<Object?> get props => [];
}

class LoadBudgetSummary extends BudgetEvent {
  final int monthYear;

  const LoadBudgetSummary(this.monthYear);

  @override
  List<Object> get props => [monthYear];
}