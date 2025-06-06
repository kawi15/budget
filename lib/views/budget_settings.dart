import 'package:flutter/material.dart';

class BudgetSettings extends StatefulWidget {
  const BudgetSettings({Key? key}) : super(key: key);

  @override
  State<BudgetSettings> createState() => _BudgetSettingsState();
}

class _BudgetSettingsState extends State<BudgetSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustawienia budżetu'),
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('w budowie'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Autooszczędzanie'),
              SizedBox(width: 8),
              Text('Wartość autooszczędzania'),
            ],
          ),
          SizedBox(height: 8),
          Text('kolejne ustawienie'),
          SizedBox(height: 8),
          Text('kolejne ustawienie'),
        ],
      ),
    );
  }
}
