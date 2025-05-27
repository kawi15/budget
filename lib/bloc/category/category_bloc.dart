import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/category_repository.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;

  CategoryBloc(this._categoryRepository) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
    on<SetMonthlyBudget>(_onSetMonthlyBudget);
  }

  Future<void> _onLoadCategories(
      LoadCategories event,
      Emitter<CategoryState> emit,
      ) async {
    emit(CategoryLoading());
    try {
      final categories = await _categoryRepository.getCategories(
        isExpense: event.isExpense,
        monthYear: event.monthYear,
      );
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(CategoryOperationFailure(e.toString()));
    }
  }

  Future<void> _onAddCategory(
      AddCategory event,
      Emitter<CategoryState> emit,
      ) async {
    emit(CategoryLoading());
    try {
      await _categoryRepository.insertCategory(event.category);
      emit(CategoryOperationSuccess());
      add(LoadCategories());
    } catch (e) {
      emit(CategoryOperationFailure(e.toString()));
    }
  }

  Future<void> _onUpdateCategory(
      UpdateCategory event,
      Emitter<CategoryState> emit,
      ) async {
    emit(CategoryLoading());
    try {
      await _categoryRepository.updateCategory(event.category);
      emit(CategoryOperationSuccess());
      add(LoadCategories());
    } catch (e) {
      emit(CategoryOperationFailure(e.toString()));
    }
  }

  Future<void> _onDeleteCategory(
      DeleteCategory event,
      Emitter<CategoryState> emit,
      ) async {
    emit(CategoryLoading());
    try {
      await _categoryRepository.deleteCategory(event.id);
      emit(CategoryOperationSuccess());
      add(LoadCategories());
    } catch (e) {
      emit(CategoryOperationFailure(e.toString()));
    }
  }

  Future<void> _onSetMonthlyBudget(
      SetMonthlyBudget event,
      Emitter<CategoryState> emit,
      ) async {
    emit(CategoryLoading());
    try {
      await _categoryRepository.updateOrCreateMonthlyCategory(
        event.category,
        event.monthYear,
      );
      emit(CategoryOperationSuccess());
      add(LoadCategories(monthYear: event.monthYear));
    } catch (e) {
      emit(CategoryOperationFailure(e.toString()));
    }
  }
}