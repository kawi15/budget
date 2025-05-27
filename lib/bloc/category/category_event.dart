import 'package:equatable/equatable.dart';

import '../../models/category.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {
  final bool? isExpense;
  final int? monthYear;

  const LoadCategories({this.isExpense, this.monthYear});

  @override
  List<Object?> get props => [isExpense, monthYear];
}

class AddCategory extends CategoryEvent {
  final Category category;

  const AddCategory(this.category);

  @override
  List<Object> get props => [category];
}

class UpdateCategory extends CategoryEvent {
  final Category category;

  const UpdateCategory(this.category);

  @override
  List<Object> get props => [category];
}

class DeleteCategory extends CategoryEvent {
  final int id;

  const DeleteCategory(this.id);

  @override
  List<Object> get props => [id];
}

class SetMonthlyBudget extends CategoryEvent {
  final Category category;
  final int monthYear;

  const SetMonthlyBudget(this.category, this.monthYear);

  @override
  List<Object> get props => [category, monthYear];
}