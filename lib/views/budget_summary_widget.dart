import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetSummaryWidget extends StatelessWidget {
  final double totalIncome;
  final double totalExpenses;

  const BudgetSummaryWidget({
    Key? key,
    required this.totalIncome,
    required this.totalExpenses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final balance = totalIncome - totalExpenses;
    final currencyFormat = NumberFormat.currency(
      locale: 'pl_PL',
      symbol: 'zł',
      decimalDigits: 2,
    );

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Podsumowanie',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            _buildSummaryRow(
              'Przychody:',
              currencyFormat.format(totalIncome),
              Colors.green,
            ),
            const SizedBox(height: 8),
            _buildSummaryRow(
              'Wydatki:',
              currencyFormat.format(totalExpenses),
              Colors.red,
            ),
            const Divider(),
            _buildSummaryRow(
              'Bilans:',
              currencyFormat.format(balance),
              balance >= 0 ? Colors.green : Colors.red,
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
      String label,
      String value,
      Color valueColor, {
        bool isBold = false,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 18 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: isBold ? 18 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}