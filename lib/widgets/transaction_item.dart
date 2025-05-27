import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/category.dart';
import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final Category? category;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.category,
    this.onDelete,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'pl_PL', symbol: 'zł', decimalDigits: 2);
    final isIncome = !transaction.isExpense;


    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: transaction.isExpense ? Colors.grey : Colors.greenAccent,
          child: Icon(
            _getCategoryIcon(),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          transaction.title.isNotEmpty
              ? transaction.title
              : 'Bez nazwy',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (category != null)
              Text(
                category!.name,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            Text(
              DateFormat.Hm().format(transaction.date),
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currencyFormat.format(transaction.amount.abs()),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isIncome ? Colors.green : Colors.red,
              ),
            ),
            if (onEdit != null || onDelete != null)
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit?.call();
                      break;
                    case 'delete':
                      _showDeleteConfirmation(context);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  if (onEdit != null)
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Edytuj'),
                        ],
                      ),
                    ),
                  if (onDelete != null)
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Usuń', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon() {
    return _getIconFromString(category?.name);

    // Default icons based on transaction type
    if (transaction.amount > 0) {
      return Icons.arrow_downward; // Income
    } else {
      return Icons.arrow_upward; // Expense
    }
  }

  IconData _getIconFromString(String? iconName) {
    // Map string names to IconData
    switch (iconName) {
      case 'food':
      case 'restaurant':
        return Icons.restaurant;
      case 'transport':
      case 'car':
        return Icons.directions_car;
      case 'shopping':
      case 'shop':
        return Icons.shopping_cart;
      case 'entertainment':
      case 'movie':
        return Icons.movie;
      case 'health':
      case 'medical':
        return Icons.medical_services;
      case 'education':
      case 'school':
        return Icons.school;
      case 'home':
      case 'house':
        return Icons.home;
      case 'salary':
      case 'work':
        return Icons.work;
      case 'gift':
        return Icons.card_giftcard;
      case 'investment':
        return Icons.trending_up;
      default:
        return Icons.category;
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Usuń transakcję'),
          content: const Text('Czy na pewno chcesz usunąć tę transakcję?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Anuluj'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDelete?.call();
              },
              child: const Text(
                'Usuń',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}