import 'package:budzet/bloc/budget/budget_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/budget/budget_bloc.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/category/category_event.dart';
import '../bloc/category/category_state.dart';
import '../bloc/transaction/transaction_bloc.dart';
import '../bloc/transaction/transaction_event.dart';
import '../models/category.dart';
import '../models/transaction.dart';

class AddTransactionScreen extends StatefulWidget {
  final int monthYear;
  final Transaction? transaction;

  const AddTransactionScreen({
    Key? key,
    required this.monthYear,
    this.transaction,
  }) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  late DateTime _selectedDate;
  bool _isExpense = true;
  Category? _selectedCategory;
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    // Set default date to current month if no transaction provided
    _selectedDate = widget.transaction?.date ?? DateTime.now();

    if (widget.transaction != null) {
      _titleController.text = widget.transaction!.title;
      _amountController.text = widget.transaction!.amount.toString();
      _isExpense = widget.transaction!.isExpense;
    }

    // Load categories for the selected type
    _loadCategories();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _loadCategories() {
    context.read<CategoryBloc>().add(
      LoadCategories(
        isExpense: _isExpense,
        monthYear: widget.monthYear,
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      final title = _titleController.text;
      final amount = double.parse(_amountController.text);

      final transaction = Transaction(
        id: widget.transaction?.id,
        title: title,
        amount: amount,
        date: _selectedDate,
        categoryId: _selectedCategory!.id!,
        isExpense: _isExpense,
      );

      if (widget.transaction == null) {
        context.read<TransactionBloc>().add(AddTransaction(transaction));
        context.read<BudgetBloc>().add(LoadBudgetSummary(widget.monthYear));
      } else {
        context.read<TransactionBloc>().add(UpdateTransaction(transaction));
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.transaction == null
            ? 'Nowa transakcja'
            : 'Edytuj transakcję'),
      ),
      body: BlocListener<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategoriesLoaded) {
            setState(() {
              _categories = state.categories;

              // If editing, find the category
              if (widget.transaction != null && _selectedCategory == null) {
                _selectedCategory = _categories.firstWhere(
                      (c) => c.id == widget.transaction!.categoryId,
                  orElse: () => /*_categories.isNotEmpty ? _categories.first : null*/_categories.first,
                );
              } else if (_categories.isNotEmpty && _selectedCategory == null) {
                _selectedCategory = _categories.first;
              }
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Transaction type switch
                Row(
                  children: [
                    const Text('Typ:'),
                    const SizedBox(width: 16),
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment<bool>(
                          value: true,
                          label: Text('Wydatek'),
                          icon: Icon(Icons.arrow_upward),
                        ),
                        ButtonSegment<bool>(
                          value: false,
                          label: Text('Przychód'),
                          icon: Icon(Icons.arrow_downward),
                        ),
                      ],
                      selected: {_isExpense},
                      onSelectionChanged: (Set<bool> selection) {
                        setState(() {
                          _isExpense = selection.first;
                          _selectedCategory = null;
                          _loadCategories();
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Title field
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Tytuł',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Wprowadź tytuł';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Amount field
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Kwota',
                    border: OutlineInputBorder(),
                    prefixText: 'PLN ',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Wprowadź kwotę';
                    }
                    try {
                      final amount = double.parse(value);
                      if (amount <= 0) {
                        return 'Kwota musi być większa od zera';
                      }
                    } catch (e) {
                      return 'Nieprawidłowy format kwoty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Date picker
                Row(
                  children: [
                    const Text('Data:'),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: () => _selectDate(context),
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        DateFormat.yMMMd().format(_selectedDate),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Category dropdown
                DropdownButtonFormField<Category>(
                  decoration: const InputDecoration(
                    labelText: 'Kategoria',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedCategory,
                  items: _categories.map((category) {
                    return DropdownMenuItem<Category>(
                      value: category,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (Category? newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Wybierz kategorię';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      widget.transaction == null ? 'Dodaj' : 'Zapisz zmiany',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}