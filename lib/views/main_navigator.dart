import 'package:budzet/views/add_transaction.dart';
import 'package:budzet/views/budget.dart';
import 'package:budzet/views/edit_categories.dart';
import 'package:budzet/views/transaction_history.dart';
import 'package:budzet/widgets/theme_switch.dart';
import 'package:flutter/material.dart';

import '../widgets/fab.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({Key? key}) : super(key: key);

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {

  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Październik 2024',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                //TODO select month
              },
              borderRadius: BorderRadius.circular(4),
              child: const Icon(Icons.calendar_month),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.greenAccent
              ),
              margin: EdgeInsets.zero,
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Kategorie'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const EditCategories()));
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const ThemeSwitch()
          ]
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
          children: const [
            Budget(),
            TransactionHistory()
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
                      const Text("Home")
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
                      const Text("Stats")
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
