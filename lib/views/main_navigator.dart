import 'package:budzet/views/add_transaction.dart';
import 'package:budzet/views/budget.dart';
import 'package:budzet/views/budget_settings.dart';
import 'package:budzet/views/edit_categories.dart';
import 'package:budzet/views/transaction_history.dart';
import 'package:budzet/views/transaction_history_screen.dart';
import 'package:budzet/widgets/theme_switch.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../widgets/fab.dart';
import 'add_transaction_screen.dart';
import 'budget_summary_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  DateTime _selectedDate = DateTime.now();

  int get _currentMonthYear =>
      _selectedDate.year * 100 + _selectedDate.month;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _previousMonth() {
    setState(() {
      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month - 1,
        1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month + 1,
        1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_left),
              onPressed: _previousMonth,
            ),
            Text(DateFormat('MMMM yyyy').format(_selectedDate)),
            IconButton(
              icon: const Icon(Icons.arrow_right),
              onPressed: _nextMonth,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          BudgetSummaryScreen(monthYear: _currentMonthYear),
          TransactionHistoryScreen(
            startDate: DateTime(_selectedDate.year, _selectedDate.month, 1),
            endDate: DateTime(_selectedDate.year, _selectedDate.month + 1, 0),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Podsumowanie',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historia',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransactionScreen(
                monthYear: _currentMonthYear,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
