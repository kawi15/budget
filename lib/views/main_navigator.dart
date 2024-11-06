import 'package:budzet/views/add_transaction.dart';
import 'package:budzet/views/budget.dart';
import 'package:budzet/views/budget_settings.dart';
import 'package:budzet/views/edit_categories.dart';
import 'package:budzet/views/transaction_history.dart';
import 'package:budzet/widgets/theme_switch.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../widgets/fab.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({Key? key}) : super(key: key);

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {

  int _currentIndex = 0;
  DateTime selectedMonth = DateTime.now();
  final PageController _pageController = PageController();

  void changeMonth() {
    showMonthPicker(
        context: context,
        initialDate: selectedMonth,
        locale: const Locale('pl'),
        dismissible: true
    ).then((date) {
      if (date != null) {
        setState(() {
          selectedMonth = date;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          DateFormat.yMMMM(Localizations.localeOf(context).languageCode).format(selectedMonth),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: changeMonth,
              borderRadius: BorderRadius.circular(4),
              child: const Icon(Icons.calendar_month),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                title: const Text('Kategorie'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EditCategories()));
                },
              ),
              ListTile(
                title: const Text('Ustawienia budżetu'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BudgetSettings()));
                },
              ),
              const ThemeSwitch()
            ]
          ),
        ),
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [
            Budget(month: selectedMonth),
            TransactionHistory(month: selectedMonth)
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
                customBorder: const CircleBorder(),
                splashFactory: NoSplash.splashFactory,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  _currentIndex = 0;
                  _pageController.animateToPage(_currentIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                },
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:[
                      Icon(Icons.home_outlined, color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white),
                      const Text("Podsumowanie")
                    ]
                )
            ),
            InkWell(
                customBorder: const CircleBorder(),
                splashFactory: NoSplash.splashFactory,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  _currentIndex = 1;
                  _pageController.animateToPage(_currentIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                },
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:[
                      Icon(Icons.multiline_chart, color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white),
                      const Text("Transakcje")
                    ]
                )
            ),
          ],
        ),
      ),
      floatingActionButton: const FAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
    );
  }
}
